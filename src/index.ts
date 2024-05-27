import { registerPlugin } from '@capacitor/core';

import type { IeadpeCapacitorBrowserPlugin } from './definitions';

const IeadpeCapacitorBrowser = registerPlugin<IeadpeCapacitorBrowserPlugin>('IeadpeCapacitorBrowser', {
  web: () => import('./web').then(m => new m.BrowserWeb()),
});

export * from './definitions';
export { IeadpeCapacitorBrowser };
