import { registerPlugin } from '@capacitor/core';

import type { EccCapacitorBrowserPlugin } from './definitions';

const EccCapacitorBrowser = registerPlugin<EccCapacitorBrowserPlugin>('EccCapacitorBrowser', {
  web: () => import('./web').then(m => new m.BrowserWeb()),
});

export * from './definitions';
export { EccCapacitorBrowser };
