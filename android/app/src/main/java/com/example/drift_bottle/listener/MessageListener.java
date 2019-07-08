package com.example.drift_bottle.listener;
import com.example.drift_bottle.entity.MessageDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hyphenate.EMMessageListener;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMMessage;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;

import java.util.ArrayList;
import java.util.List;

public class MessageListener implements EMMessageListener {

    private EventChannel.EventSink mSink;
    private FlutterActivity activity;
    private static final MessageListener LISTENER = new MessageListener();

    public static MessageListener get(){
        return LISTENER;
    }

    private MessageListener(){}

    //注册
    public MessageListener register(EventChannel.EventSink sink,FlutterActivity activity){
        this.mSink = sink;
        this.activity=activity;
        return LISTENER;
    }


    //删除
    public void unRegister(){
        EMClient.getInstance().chatManager().removeMessageListener(LISTENER);
    }

    @Override
    public void onMessageReceived(List<EMMessage> messages) {

        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                List<MessageDto> messageDtoList = new ArrayList<MessageDto>();
                for (EMMessage emm:messages) {
                    MessageDto messageDto = new MessageDto();
                    messageDto.setFrom(emm.getFrom());
                    String str = emm.getBody().toString();
                    String content = str.substring(5,str.length()-1);
                    messageDto.setContent(content);
                    messageDto.setContent_type(emm.getType().toString());
                    messageDtoList.add(messageDto);
                }
                ObjectMapper mapper = new ObjectMapper();
                try {
                    mSink.success(mapper.writeValueAsString(messageDtoList) );
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }
            }
        });



    }

    @Override
    public void onCmdMessageReceived(List<EMMessage> messages) {

    }

    @Override
    public void onMessageRead(List<EMMessage> messages) {

    }

    @Override
    public void onMessageDelivered(List<EMMessage> messages) {

    }

    @Override
    public void onMessageChanged(EMMessage message, Object change) {

    }
}
