// OpenCode 1.17.14+: refresh Strata's model metadata during config initialization.
// No config-file writes, inference calls, background polling, or extra packages.
const healthRequests = new Map();

function healthURL(baseURL) {
  const url = new URL(baseURL);
  if (!['http:', 'https:'].includes(url.protocol) || url.username || url.password) {
    throw new Error('invalid server URL');
  }
  url.pathname = url.pathname.replace(/\/v1\/?$/, '').replace(/\/$/, '') + '/health';
  url.search = '';
  url.hash = '';
  return url.href;
}

async function serverInfo(url) {
  if (!healthRequests.has(url)) {
    healthRequests.set(url, (async () => {
      let response;
      try {
        response = await fetch(url, {
          signal: AbortSignal.timeout(5000), redirect: 'error', cache: 'no-store',
        });
      } catch {
        throw new Error('server unavailable (5-second timeout or network error)');
      }
      if (!response.ok) throw new Error(`health HTTP ${response.status}`);
      let info;
      try { info = await response.json(); }
      catch { throw new Error('invalid health JSON'); }
      if (info?.service !== 'strata' || info.status !== 'ok' || info.loaded !== true) {
        throw new Error('Strata model is not ready');
      }
      if (typeof info.model !== 'string' || !info.model.trim() ||
          info.model.length > 512 || /[\x00-\x1f\x7f]/.test(info.model) ||
          !Number.isSafeInteger(info.max_context) || info.max_context < 1024) {
        throw new Error('invalid model name or context limit');
      }
      return { model: info.model, context: info.max_context };
    })());
  }
  return healthRequests.get(url);
}

async function log(client, level, message, extra = {}) {
  try {
    await client?.app?.log({ body: {
      service: 'strata-server-info', level, message, extra,
    } });
  } catch { /* Logging must not change the provider decision. */ }
}

export default async function StrataServerInfo({ client }) {
  return {
    async config(config) {
      const provider = config.provider?.strata;
      if (!provider || config.disabled_providers?.includes('strata') ||
          (config.enabled_providers && !config.enabled_providers.includes('strata'))) return;

      try {
        const info = await serverInfo(healthURL(provider.options?.baseURL));
        const entries = Object.entries(provider.models ?? {});
        if (!entries.length) throw new Error('no configured Strata model aliases');
        // Validate every alias before mutating any: saved sessions keep these keys.
        for (const [, model] of entries) {
          const output = model.limit?.output;
          if (!Number.isSafeInteger(output) || output <= 0 || output >= info.context) {
            throw new Error('configured output budget does not fit server context');
          }
        }
        for (const [, model] of entries) {
          model.id = info.model;
          model.name = info.model;
          model.limit.context = info.context;
          if (model.limit.input !== undefined) {
            if (!Number.isSafeInteger(model.limit.input) || model.limit.input <= 0) {
              delete model.limit.input;
            } else {
              model.limit.input = Math.min(model.limit.input, info.context - model.limit.output);
            }
          }
        }
        await log(client, 'info', 'Strata model metadata refreshed at startup', {
          model: info.model, context: info.context, aliases: entries.map(([key]) => key),
        });
      } catch (error) {
        // OpenCode ignores errors thrown by config hooks. Disable only Strata so
        // it cannot silently send a conversation using an unverified stale cap.
        config.disabled_providers = [...new Set([...(config.disabled_providers ?? []), 'strata'])];
        const reason = error instanceof TypeError ? 'invalid server configuration' : error.message;
        await log(client, 'error', `Strata startup sync failed: ${reason}. Start Strata and restart OpenCode.`);
      }
    },
  };
}
