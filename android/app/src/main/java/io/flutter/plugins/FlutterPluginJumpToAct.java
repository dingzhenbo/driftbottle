package io.flutter.plugins;
import com.example.drift_bottle.listener.MyConnectionListener;
import com.example.drift_bottle.util.EMClientUtil;
import com.hyphenate.chat.EMClient;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
public class FlutterPluginJumpToAct implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    public static String CHANNEL = "channel";
    public static String EVENTCHANNEL="eventChannel";
    private FlutterActivity activity;
    private FlutterPluginJumpToAct(FlutterActivity activity) {
        this.activity = activity;
    }

    public static void registerWith(FlutterActivity activity) {
        FlutterPluginJumpToAct instance = new FlutterPluginJumpToAct(activity);
        //flutter调用原生
        MethodChannel   channel = new MethodChannel(activity.registrarFor(CHANNEL).messenger(), CHANNEL);
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
        System.out.println("注册flutter调用原生通道成功");
        //原生调用flutter
        EventChannel  eventChannel = new EventChannel(activity.registrarFor(EVENTCHANNEL).messenger(),EVENTCHANNEL);
        eventChannel.setStreamHandler(instance);
        System.out.println("注册原生调用flutter成功");


    }
    @Override
    public void onMethodCall(MethodCall methodCall,MethodChannel.Result result) {

        if (methodCall.method.equals("register")){
            String account= methodCall.argument("account");
            String password = methodCall.argument("password");
            EMClientUtil.register(account,password,activity,result);

        }else if (methodCall.method.equals("login")){
            String loginName =methodCall.argument("loginName");
            String password =methodCall.argument("password");
            EMClientUtil.login(loginName,password,activity,result);

        }else if(methodCall.method.equals(("autoLogin"))){
            EMClientUtil.autoLogin(activity,result);
        }else if(methodCall.method.equals("loginOut")){
            EMClient.getInstance().logout(true);
            System.out.println("注销账号。");

        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
    EMClient.getInstance().addConnectionListener(new MyConnectionListener(activity,eventSink));
    }

    @Override
    public void onCancel(Object o) {

    }
}
