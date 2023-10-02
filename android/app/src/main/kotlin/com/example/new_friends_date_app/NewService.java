package com.example.new_friends_date_app;

import static com.example.new_friends_date_app.MainActivity.CHANNEL;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.common.MethodChannel;

public class NewService extends Service {
	public MethodChannel getMethodChannel(Context context) {
		new FlutterLoader().startInitialization(context.getApplicationContext());
		FlutterEngine engine = new FlutterEngine(context.getApplicationContext());


		DartExecutor.DartEntrypoint entrypoint = new DartExecutor.DartEntrypoint("lib/main.dart", "fromNative");

		engine.getDartExecutor().executeDartEntrypoint(entrypoint);
		return new MethodChannel(engine.getDartExecutor().getBinaryMessenger(), CHANNEL);
	}


	@Override
	public void onCreate() {
		super.onCreate();
//		NotificationCompat.Builder builder;
//		builder = new NotificationCompat.Builder(this, "123456");
//		builder.setSmallIcon(R.mipmap.ic_launcher);
//		builder.setContentTitle("");
//		builder.setContentText("");
//		PowerManager powerManager = (PowerManager) getSystemService(POWER_SERVICE);
//		PowerManager.WakeLock wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP | PowerManager.ON_AFTER_RELEASE, "MyApp::");
//		wakeLock.acquire(10000);
//
//		wakeLock.release();
//		try {
//			Thread.sleep(1000);
//		} catch (InterruptedException e) {
//			e.printStackTrace();
//		}
//		startForeground(9090, builder.build());
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		Log.d("TAG", "onDestroy: CallFrom Service");
		MethodChannel getMethodChannel = getMethodChannel(this);
		getMethodChannel.invokeMethod("bgMethod", null);
		new Handler(Looper.getMainLooper()).postDelayed(this::stopSelf,5000);
		return START_STICKY;
	}

	@Override

	// execution of the service will
	// stop on calling this method
	public void onDestroy() {
		super.onDestroy();
	}

	@Nullable
	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}
}
