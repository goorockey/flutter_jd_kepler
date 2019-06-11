package com.example.flutter_jd_kepler;

import android.app.Application;
import android.app.Activity;

import com.kepler.jd.Listener.ActionCallBck;
import com.kepler.jd.Listener.AsyncInitListener;
import com.kepler.jd.Listener.LoginListener;
import com.kepler.jd.login.KeplerApiManager;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterJdKeplerPlugin */
public class FlutterJdKeplerPlugin implements MethodCallHandler {
  private final Registrar mRegistrar;

  FlutterJdKeplerPlugin(Registrar registrar) {
    mRegistrar = registrar;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_jd_kepler");
    channel.setMethodCallHandler(new FlutterJdKeplerPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("init")) {
      this.initJDSDK(call, result);
    } else if (call.method.equals("isLogin")) {
      this.jdCheckLogin(call, result);
    } else if (call.method.equals("login")) {
      this.jdLogin(call, result);
    } else if (call.method.equals("logout")) {
      this.jdLogout(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void initJDSDK(final MethodCall call, final Result result) {
    String appKey = call.argument("appKey");
    String appSecret = call.argument("appSecret");
    Activity activity = mRegistrar.activity();

    KeplerApiManager.asyncInitSdk(activity.getApplication(), appKey, appSecret, new AsyncInitListener() {
      @Override
      public void onSuccess() {
        result.success(true);
      }

      @Override
      public void onFailure() {
        result.success(false);
      }
    });
  }

  private void jdCheckLogin(final MethodCall call, final Result result) {
    KeplerApiManager.getWebViewService().checkLoginState(new ActionCallBck() {
      @Override
      public boolean onDateCall(int key, String info) {
        result.success(true);
        return false;
      }

      @Override
      public boolean onErrCall(int key, String error) {
        result.success(false);
        return false;
      }
    });
  }

  private void jdLogin(final MethodCall call, final Result result) {
    Activity activity = mRegistrar.activity();

    KeplerApiManager.getWebViewService().login(activity, new LoginListener() {
      @Override
      public void authSuccess() {
        result.success(true);
      }

      @Override
      public void authFailed(final int errCode) {
        result.success(false);
      }
    });
  }

  private void jdLogout(final MethodCall call, final Result result) {
    Activity activity = mRegistrar.activity();

    KeplerApiManager.getWebViewService().cancelAuth(activity);
    result.success(null);
  }
}
