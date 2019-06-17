package com.example.drift_bottle;

import android.os.Bundle;
import com.example.drift_bottle.listener.MyConnectionListener;
import com.hyphenate.chat.EMClient;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.FlutterPluginJumpToAct;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    registerCustomPlugin(this);
   /* //注册一个监听连接状态的listener
    EMClient.getInstance().addConnectionListener(new MyConnectionListener());*/
  }

  private static void registerCustomPlugin(FlutterActivity activity) {
    FlutterPluginJumpToAct.registerWith(activity);

  }

/*  //实现ConnectionListener接口
  private class MyConnectionListener implements EMConnectionListener {
    @Override
    public void onConnected() {
    }
    @Override
    public void onDisconnected(final int error) {
      runOnUiThread(new Runnable() {

        @Override
        public void run() {
          if(error == EMError.USER_REMOVED){
            System.out.println("显示帐号已经被移除");
            // 显示帐号已经被移除
          }else if (error == EMError.USER_LOGIN_ANOTHER_DEVICE) {
            System.out.println("显示帐号在其他设备登录");
            // 显示帐号在其他设备登录
          } else {
            if (NetUtils.hasNetwork(MainActivity.this)){
              System.out.println("连接不到聊天服务器");
              //连接不到聊天服务器
            }
            else{
              System.out.println("当前网络不可用，请检查网络设置");
              //当前网络不可用，请检查网络设置
            }

          }
        }
      });
    }
  }*/
}
