import {WebPlugin} from '@capacitor/core';

import type {EccCapacitorBrowserPlugin, EccCapacitorBrowserOpenOptions} from './definitions';

export class BrowserWeb extends WebPlugin implements EccCapacitorBrowserPlugin {
    _lastWindow: Window | null;

    constructor() {
        super();
        this._lastWindow = null;
    }

    async open(options: EccCapacitorBrowserOpenOptions): Promise<void> {
        this._lastWindow = window.open(options.url, options.windowName || '_blank');
    }

    async close(): Promise<void> {
        return new Promise((resolve, reject) => {
            if (this._lastWindow != null) {
                this._lastWindow.close();
                this._lastWindow = null;
                resolve();
            } else {
                reject('No active window to close!');
            }
        });
    }
}

const EccCapacitorBrowser = new BrowserWeb();

export {EccCapacitorBrowser};
