// OpenCode tool: generate_image
// WORK2 は Strata と ComfyUI が同じ GPU を取り合うので、Strata を止めて画像を作り、Strata を戻す
// (E:\local-image-generation\gpu_swap\swap_image.ps1)。この間 Strata は応答しないが、会話は OpenCode が持っている。
//
// 入れ替え本体は WMI (Win32_Process.Create) で起動する。SSH から直接起動すると SSH セッションの Job Object に入り、
// 切断やツールの中断と一緒に殺されて Strata が止まったまま残るため。こちらは結果ファイルができるのを待つだけ。
import { execFile } from 'node:child_process';
import { mkdtemp, mkdir, rm, writeFile } from 'node:fs/promises';
import { homedir, tmpdir } from 'node:os';
import { basename, join } from 'node:path';
import { pathToFileURL } from 'node:url';

const HOST = 'tikyu@work2.local';
const PORT = '50041';
const SWAP_DIR = 'E:\\local-image-generation\\gpu_swap';
const POLL_MS = 10_000;
const TIMEOUT_MS = 25 * 60_000;

// 本体は dotfiles にあり node_modules が無いので、OpenCode 設定ディレクトリの SDK (zod 入り) を読む。
const sdk = await import(pathToFileURL(
  join(homedir(), '.config', 'opencode', 'node_modules', '@opencode-ai', 'plugin', 'dist', 'index.js')).href);
const z = sdk.tool.schema;

function run(file, args, timeout = 60_000) {
  return new Promise((resolve, reject) => {
    execFile(file, args, { timeout, windowsHide: true, maxBuffer: 4 << 20 }, (error, stdout, stderr) => {
      if (error) reject(new Error(`${file} failed: ${(stderr || error.message).trim().slice(0, 500)}`));
      else resolve(stdout);
    });
  });
}

// リモートは PowerShell 5.1。引用符の事故を避けるため -EncodedCommand (UTF-16LE base64) で渡す。
function remotePs(script, timeout) {
  const encoded = Buffer.from(`$ProgressPreference='SilentlyContinue'; ${script}`, 'utf16le').toString('base64');
  return run('ssh', ['-p', PORT, '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=10', HOST,
    `powershell -NoProfile -NonInteractive -EncodedCommand ${encoded}`], timeout);
}

const scp = (from, to) => run('scp', ['-P', PORT, '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=10', from, to], 120_000);
const remotePath = (p) => `${HOST}:${p.replaceAll('\\', '/')}`;
const sleep = (ms, signal) => new Promise((resolve) => {
  const onAbort = () => { clearTimeout(timer); resolve(); };
  const timer = setTimeout(() => { signal?.removeEventListener('abort', onAbort); resolve(); }, ms);
  signal?.addEventListener('abort', onAbort, { once: true });
});

export default async function GpuSwapImage() {
  return {
    tool: {
      generate_image: sdk.tool({
        description:
          'Generate one image with the local Flux3 klein model on WORK2 and save it into the project. ' +
          'The local LLM (you) is stopped while the image is generated and restarted afterwards, so the call ' +
          'takes about 4 minutes and the next reply re-reads the whole conversation. Write the prompt in English, ' +
          'as a detailed description of the picture. Returns the saved file path.',
        args: {
          prompt: z.string().min(1).max(8000).describe('English description of the image'),
          width: z.number().int().min(256).max(2048).optional().describe('pixels, default 1024'),
          height: z.number().int().min(256).max(2048).optional().describe('pixels, default 1024'),
        },
        async execute(args, context) {
          const id = `oc-${Date.now()}-${Math.random().toString(16).slice(2, 8)}`;
          const reqRemote = `${SWAP_DIR}\\requests\\${id}.json`;
          const resRemote = `${SWAP_DIR}\\requests\\${id}.result.json`;
          const tmp = await mkdtemp(join(tmpdir(), 'gpu-swap-'));
          try {
            const reqLocal = join(tmp, `${id}.json`);
            await writeFile(reqLocal, JSON.stringify({ prompt: args.prompt, width: args.width, height: args.height }), 'utf8');
            await remotePs(`New-Item -ItemType Directory -Force -Path '${SWAP_DIR}\\requests' | Out-Null`);
            await scp(reqLocal, remotePath(reqRemote));

            const cmd = `powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden ` +
              `-File "${SWAP_DIR}\\swap_image.ps1" -RequestFile "${reqRemote}" -ResultFile "${resRemote}"`;
            const created = await remotePs(
              `(Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = '${cmd.replaceAll("'", "''")}' }).ReturnValue`);
            if (created.trim() !== '0') throw new Error(`Win32_Process.Create returned ${created.trim()}`);
            context.metadata({ title: 'GPU swap: LLM stopped, generating image' });

            // ツールが中断されても WORK2 側は最後まで走り Strata を戻す。ここは待つのをやめるだけ。
            const deadline = Date.now() + TIMEOUT_MS;
            let result = null;
            while (Date.now() < deadline && !context.abort.aborted) {
              await sleep(POLL_MS, context.abort);
              const text = await remotePs(`if (Test-Path -LiteralPath '${resRemote}') { Get-Content -LiteralPath '${resRemote}' -Raw -Encoding UTF8 }`).catch(() => '');
              if (text.trim()) { result = JSON.parse(text); break; }
            }
            if (!result) {
              return `Stopped waiting (${context.abort.aborted ? 'cancelled' : 'timeout'}). WORK2 keeps going and restarts the LLM; ` +
                `result will appear at ${resRemote}.`;
            }
            if (!result.ok) {
              return `Image generation failed: ${result.error}. LLM restored: ${result.llm_restored ?? 'n/a'}.`;
            }

            const outDir = join(context.directory, 'generated');
            await mkdir(outDir, { recursive: true });
            const saved = [];
            for (const remote of [].concat(result.images ?? [])) {
              const local = join(outDir, `${id}-${basename(remote.replaceAll('\\', '/'))}`);
              await scp(remotePath(remote), local);
              saved.push(local);
            }
            const s = result.seconds ?? {};
            return {
              title: `Image generated (${saved.length})`,
              output: `Saved: ${saved.join(', ')}\n` +
                `Seconds: llm_stop ${s.llm_stop}, image_load ${s.image_load}, generate ${s.image_generate}, ` +
                `image_unload ${s.image_unload}, llm_start ${s.llm_start}. LLM restored: ${result.llm_restored}.`,
              metadata: { files: saved, seconds: s },
            };
          } finally {
            await rm(tmp, { recursive: true, force: true });
          }
        },
      }),
    },
  };
}
