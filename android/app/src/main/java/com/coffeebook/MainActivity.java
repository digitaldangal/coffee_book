package com.coffeebook;

import android.Manifest;
import android.annotation.TargetApi;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "runtimepermission";
    private final static int WRITE_EXTERNAL_RESULT = 101;
    private final static int READ_EXTERNAL_RESULT = 102;
    private final static int[] permissions = {WRITE_EXTERNAL_RESULT};
    private final static String[] permissionsMF = {Manifest.permission.WRITE_EXTERNAL_STORAGE};
    private PermissionCallback getPermissionCallback;
    private boolean rationaleJustShown = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @TargetApi(Build.VERSION_CODES.CUPCAKE)
                    @Override
                    public void onMethodCall(MethodCall call, final MethodChannel.Result result) {
                        getPermissionCallback = new PermissionCallback() {
                            @Override
                            public void granted() {
                                rationaleJustShown = false;
                                result.success(0);
                            }

                            @Override
                            public void denied() {
                                rationaleJustShown = false;
                                result.success(1);
                            }

                            @Override
                            public void showRationale() {
                                rationaleJustShown = true;
                                result.success(2);
                            }
                        };
                        if (call.method.equals("hasPermission")) {
                            hasPermission();
                        }
                    }
                });
    }

    private void hasPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (rationaleJustShown) {
                requestPermissions(permissionsMF, WRITE_EXTERNAL_RESULT);
            } else {
                for (int i = 0; i < permissions.length; i++) {
                    if (checkSelfPermission(permissionsMF[i]) != PackageManager.PERMISSION_GRANTED) {
                        if (shouldShowRequestPermissionRationale(Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                            getPermissionCallback.showRationale();
                        } else {
                            requestPermissions(permissionsMF, WRITE_EXTERNAL_RESULT);
                        }
                    } else {
                        getPermissionCallback.granted();
                    }
                }
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case WRITE_EXTERNAL_RESULT:
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    getPermissionCallback.granted();
                } else {
                    getPermissionCallback.denied();
                }
        }
    }

    public interface PermissionCallback {
        void granted();

        void denied();

        void showRationale();
    }
}