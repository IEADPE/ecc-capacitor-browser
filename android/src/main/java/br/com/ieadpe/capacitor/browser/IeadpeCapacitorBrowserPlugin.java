package br.com.ieadpe.capacitor.browser;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import com.getcapacitor.Logger;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.util.WebColor;

@CapacitorPlugin(name = "IeadpeCapacitorBrowser")
public class IeadpeCapacitorBrowserPlugin extends Plugin {

    private IeadpeCapacitorBrowser implementation;

    public static IeadpeCapacitorBrowserControllerListener browserControllerListener;
    private static IeadpeCapacitorBrowserControllerActivity browserControllerActivityInstance;

    public static void setBrowserControllerListener(IeadpeCapacitorBrowserControllerListener listener) {
        browserControllerListener = listener;
        if (listener == null) {
            browserControllerActivityInstance = null;
        }
    }

    public void load() {
        implementation = new IeadpeCapacitorBrowser(getContext());
        implementation.setBrowserEventListener(this::onBrowserEvent);
    }

    @PluginMethod
    public void open(PluginCall call) {
        // get the URL
        String urlString = call.getString("url");
        if (urlString == null) {
            call.reject("Must provide a URL to open");
            return;
        }
        if (urlString.isEmpty()) {
            call.reject("URL must not be empty");
            return;
        }
        Uri url;
        try {
            url = Uri.parse(urlString);
        } catch (Exception ex) {
            call.reject(ex.getLocalizedMessage());
            return;
        }

        // get the toolbar color, if provided
        String colorString = call.getString("toolbarColor");
        Integer toolbarColor = null;
        if (colorString != null) try {
            toolbarColor = WebColor.parseColor(colorString);
        } catch (IllegalArgumentException ex) {
            Logger.error(getLogTag(), "Invalid color provided for toolbarColor. Using default", null);
        }

        // open the browser and finish
        try {
            Intent intent = new Intent(getContext(), IeadpeCapacitorBrowserControllerActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            getContext().startActivity(intent);

            Integer finalToolbarColor = toolbarColor;
            setBrowserControllerListener(
                activity -> {
                    activity.open(implementation, url, finalToolbarColor);
                    browserControllerActivityInstance = activity;
                    call.resolve();
                }
            );
        } catch (ActivityNotFoundException ex) {
            Logger.error(getLogTag(), ex.getLocalizedMessage(), null);
            call.reject("Unable to display URL");
            return;
        }
    }

    @PluginMethod
    public void close(PluginCall call) {
        if (browserControllerActivityInstance != null) {
            browserControllerActivityInstance = null;
            Intent intent = new Intent(getContext(), IeadpeCapacitorBrowserControllerActivity.class);
            intent.putExtra("close", true);
            getContext().startActivity(intent);
        }
        call.resolve();
    }

    @Override
    protected void handleOnResume() {
        if (!implementation.bindService()) {
            Logger.error(getLogTag(), "Error binding to custom tabs service", null);
        }
    }

    @Override
    protected void handleOnPause() {
        implementation.unbindService();
    }

    void onBrowserEvent(int event) {
        switch (event) {
            case IeadpeCapacitorBrowser.BROWSER_LOADED:
                notifyListeners("ieadpeBrowserPageLoaded", null);
                break;
            case IeadpeCapacitorBrowser.BROWSER_FINISHED:
                notifyListeners("ieadpeBrowserFinished", null);
                break;
            case IeadpeCapacitorBrowser.BROWSER_LOGGED_IN:
                notifyListeners("ieadpeBrowserLoggedIn", null);
                break;
        }
    }
}
