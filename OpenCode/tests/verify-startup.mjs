import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const source = await readFile(new URL('../plugins/strata-server-info.js', import.meta.url), 'utf8');
const fixture = () => ({
  model: 'strata/old-iq3',
  provider: {
    strata: { npm: '@ai-sdk/openai-compatible', options: {
      baseURL: 'http://127.0.0.1:8090/v1', apiKey: 'fixture-secret-do-not-log',
    }, models: {
      'old-iq3': { name: 'IQ3_S', attachment: true, limit: { context: 196608, output: 16384 } },
    } },
    other: { models: { other: { limit: { context: 8192 } } } },
  },
});
const health = { service: 'strata', status: 'ok', loaded: true,
  model: 'qwen3.8-flash-next-nvfp4-nvfp4-qad', max_context: 131072 };
const originalFetch = globalThis.fetch;
let caseNumber = 0;
async function load(fetcher) {
  globalThis.fetch = fetcher;
  const module = await import(`data:text/javascript;base64,${Buffer.from(source + `\n// case ${caseNumber++}`).toString('base64')}`);
  const logs = [];
  const hooks = await module.default({ client: { app: { log: async (entry) => logs.push(entry) } } });
  return { hooks, logs };
}
try {
  let calls = 0;
  const success = await load(async (url, options) => {
    calls++;
    assert.equal(url, 'http://127.0.0.1:8090/health');
    assert.equal(options.headers, undefined);
    return Response.json(health);
  });
  const config = fixture();
  const other = structuredClone(config.provider.other);
  await success.hooks.config(config);
  const model = config.provider.strata.models['old-iq3'];
  assert.equal(config.model, 'strata/old-iq3');
  assert.equal(model.id, health.model);
  assert.equal(model.name, health.model);
  assert.deepEqual(model.limit, { context: 131072, output: 16384 });
  assert.equal(model.attachment, true);
  assert.deepEqual(config.provider.other, other);
  assert.equal(config.provider.strata.options.apiKey, 'fixture-secret-do-not-log');
  await success.hooks.config(fixture());
  assert.equal(calls, 1, 'one health request per process/server');
  assert.ok(!JSON.stringify(success.logs).includes('fixture-secret-do-not-log'));

  const low = fixture();
  low.provider.strata.models['old-iq3'].limit.input = 64000;
  await success.hooks.config(low);
  assert.equal(low.provider.strata.models['old-iq3'].limit.input, 64000);
  const high = fixture();
  high.provider.strata.models['old-iq3'].limit.input = 180000;
  await success.hooks.config(high);
  assert.equal(high.provider.strata.models['old-iq3'].limit.input, 114688);

  for (const [label, fetcher] of [
    ['offline', async () => { throw new Error('fixture-secret-do-not-log'); }],
    ['loading', async () => Response.json({ ...health, loaded: false })],
    ['bad context', async () => Response.json({ ...health, max_context: 0 })],
    ['output too large', async () => Response.json({ ...health, max_context: 8192 })],
    ['wrong service', async () => Response.json({ ...health, service: 'other' })],
    ['HTTP failure', async () => new Response('fixture-secret-do-not-log', { status: 503 })],
  ]) {
    const { hooks, logs } = await load(fetcher);
    const failed = fixture();
    const before = structuredClone(failed.provider);
    await hooks.config(failed);
    assert.deepEqual(failed.disabled_providers, ['strata'], label);
    assert.deepEqual(failed.provider, before, label);
    assert.ok(!JSON.stringify(logs).includes('fixture-secret-do-not-log'), label);
  }
  console.log('Startup sync verified: server metadata, legacy sessions, output/input budgets, offline/loading failures, no credential logging.');
} finally { globalThis.fetch = originalFetch; }
