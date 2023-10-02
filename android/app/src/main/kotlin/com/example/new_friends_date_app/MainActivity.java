package com.example.new_friends_date_app;

import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    public static final String CHANNEL = "com.example.new_friends_date_app/helper";
    MethodChannel channel;
    MethodChannel.Result result;
    public final static int REQUEST_CODE = -1010101;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

//    private void launchFromOverlay(Intent intent) {
//        Bundle bundle = intent.getBundleExtra("details");
//        if (bundle != null) {
//            int leadId = bundle.getInt("leadId", -1);
//            String type = bundle.getString("type");
//            HashMap<String, Object> map = new HashMap<>();
//            map.put("type", type);
//            map.put("leadId", leadId);
//            Log.e("TAG", "launchFromOverlay: " + map);
//            if (type == null) {
//                return;
//            }
//            channel.invokeMethod("onLeadClick", map);
//        }
//
//
//    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
//        launchFromOverlay(intent);
    }


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);

//        launchFromOverlay(getIntent());
        channel.setMethodCallHandler((call, result) -> {
            String methodName = call.method;
            this.result = result;
//            switch (methodName) {
//                case "checkPermission":
//                    int status1 = ContextCompat.checkSelfPermission(MainActivity.this, "android.permission.READ_PHONE_STATE");
//                    int status2 = ContextCompat.checkSelfPermission(MainActivity.this, "android.permission.READ_CALL_LOG");
//                    if (status1 == PackageManager.PERMISSION_GRANTED && status2 == PackageManager.PERMISSION_GRANTED) {
//                        this.result.success(true);
//
//                    } else {
//                        ActivityCompat.requestPermissions(MainActivity.this, new String[]{"android.permission.READ_PHONE_STATE", "android.permission.READ_CALL_LOG"}, 1212);
//                    }
//                    break;
//
//                case "startPopUp":
//                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                        startForegroundService(new Intent(MainActivity.this, IncomingCallService.class));
//                    } else {
//                        startService(new Intent(MainActivity.this, IncomingCallService.class));
//                    }
//                    break;
//
//                case "checkOverlayPermission":
//                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                        checkDrawOverlayPermission();
//                    }
//                    break;
//
//            }
//
        });
    }

//    @Override
//    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
//        int count = 0;
//        if (requestCode == 1212) {
//            for (int grantResult : grantResults) {
//                if (grantResult == PackageManager.PERMISSION_GRANTED) {
//                    count++;
//                }
//            }
//
//            if (count != grantResults.length) {
//                Toast.makeText(this, "Please allow permission", Toast.LENGTH_SHORT).show();
//                this.result.success(false);
//            } else {
//                this.result.success(true);
//            }
//
//        }
//
//    }

//    @RequiresApi(api = Build.VERSION_CODES.M)
//    public void checkDrawOverlayPermission() {
//        Log.v("App", "Package Name: " + getApplicationContext().getPackageName());
//
//        if (!Settings.canDrawOverlays(this)) {
//            Log.v("App", "Requesting Permission" + Settings.canDrawOverlays(this));
//            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + getApplicationContext().getPackageName()));
//
//            startActivityForResult(intent, REQUEST_CODE);
//        } else {
//            this.result.success(true);
//            addAutoStartup();
//            Log.v("App", "We already have permission for it.");
//        }
//    }

//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        Log.v("App", "OnActivity Result.");
//        if (requestCode == REQUEST_CODE) {
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                if (Settings.canDrawOverlays(this)) {
//                }
//            }
//            addAutoStartup();
//            this.result.success(true);
//
//        }
//    }

//    private void addAutoStartup() {
//
//        try {
//            SharedPreferences sharedPreferences = getSharedPreferences("appLocal", MODE_PRIVATE);
//            boolean showPermission = sharedPreferences.getBoolean("show_permission", false);
//            if (showPermission) {
//                return;
//            }
//            sharedPreferences.edit().putBoolean("show_permission", true).apply();
//
//            Intent intent = new Intent();
//            String manufacturer = android.os.Build.MANUFACTURER;
//            if ("xiaomi".equalsIgnoreCase(manufacturer)) {
//                intent.setComponent(new ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity"));
//            } else if ("oppo".equalsIgnoreCase(manufacturer)) {
//                intent.setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity"));
//            } else if ("vivo".equalsIgnoreCase(manufacturer)) {
//                intent.setComponent(new ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"));
//            } else if ("Letv".equalsIgnoreCase(manufacturer)) {
//                intent.setComponent(new ComponentName("com.letv.android.letvsafe", "com.letv.android.letvsafe.AutobootManageActivity"));
//            } else if ("Honor".equalsIgnoreCase(manufacturer)) {
//                intent.setComponent(new ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity"));
//            }
//
//            List<ResolveInfo> list = getPackageManager().queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
//            if (list.size() > 0) {
//                startActivity(intent);
//            }
//        } catch (Exception e) {
//            Log.e("exc", String.valueOf(e));
//        }
//    }

    @Override
    protected void onPause() {

        super.onPause();
//        if (!isMyServiceRunning(this, IncomingCallService.class)) {
//
//            Intent intent = new Intent(this, IncomingCallService.class);
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                startForegroundService(intent);
//            } else {
//                startService(new Intent(this, IncomingCallService.class));
//            }
//        }

    }

    @Override
    protected void onDestroy() {
        Log.d("TAG", "onDestroy: ");
            Intent intent = new Intent(this, NewService.class);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(intent);
            } else {
                startService(new Intent(this, NewService.class));
            }
        super.onDestroy();

    }

    public MethodChannel getMethodChannel(Context context) {
        new FlutterLoader().startInitialization(context.getApplicationContext());
        FlutterEngine engine = new FlutterEngine(context.getApplicationContext());


        DartExecutor.DartEntrypoint entrypoint = new DartExecutor.DartEntrypoint("lib/main.dart", "fromNative");

        engine.getDartExecutor().executeDartEntrypoint(entrypoint);
        return new MethodChannel(engine.getDartExecutor().getBinaryMessenger(), CHANNEL);
    }

    private boolean isMyServiceRunning(Context context, Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }
}
