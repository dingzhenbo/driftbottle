package io.flutter.plugins;
import android.os.Build;
import android.support.annotation.RequiresApi;
import com.example.drift_bottle.entity.ConversationDto;
import com.example.drift_bottle.listener.MessageListener;
import com.example.drift_bottle.listener.MyConnectionListener;
import com.example.drift_bottle.util.EMClientUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hyphenate.EMMessageListener;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMConversation;
import com.hyphenate.chat.EMMessage;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

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
    @RequiresApi(api = Build.VERSION_CODES.N)
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
        }else if(methodCall.method.equals("getCurrentUser")){  //获取登录id
            String currentUser = EMClient.getInstance().getCurrentUser();
            result.success(currentUser);
        }else if(methodCall.method.equals("getToken")){
            String accessToken = EMClient.getInstance().getAccessToken();
            result.success(accessToken);
        }else if(methodCall.method.equals("sendMessage")){
            String content = methodCall.argument("content");
            String toUser  = methodCall.argument("toUser");
            EMClientUtil.sendMessage(content,toUser);
        }else if(methodCall.method.equals("allConversations")){
            EMClient.getInstance().chatManager().loadAllConversations();
            Map<String, EMConversation> conversations = EMClient.getInstance().chatManager().getAllConversations();
            List<ConversationDto> conversationDtoList = new ArrayList<>();
            conversations.forEach((key,value)->{
                ConversationDto conversationDto = new ConversationDto();
                conversationDto.setEmid(key);
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
                Date date  = new Date(value.getLastMessage().getMsgTime());
                conversationDto.setLastMessageTime(simpleDateFormat.format(date));
                String str = value.getLastMessage().getBody().toString();
                String lastMessage = str.substring(5,str.length()-1);
                conversationDto.setLastMessage(lastMessage);
                conversationDto.setUnread(value.getUnreadMsgCount());
                conversationDtoList.add( conversationDto);

            });

            ObjectMapper mapper = new ObjectMapper();
            try {
                System.out.println("转换json"+mapper.writeValueAsString(conversationDtoList));
                result.success(mapper.writeValueAsString(conversationDtoList));
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }

        }else if(methodCall.method.equals("chatRecord")){
            String emid = methodCall.argument("emid");
            EMClientUtil.chatRecord(emid,result);
        }else if(methodCall.method.equals("clearUnread")){
            String emid = methodCall.argument("emid");
            EMConversation conversation = EMClient.getInstance().chatManager().getConversation(emid);
            conversation.markAllMessagesAsRead();
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
    EMClient.getInstance().addConnectionListener(new MyConnectionListener(activity,eventSink));
    EMClient.getInstance().chatManager().addMessageListener(MessageListener.get().register(eventSink,activity));


    }

    @Override
    public void onCancel(Object o) {

    }
}
