package com.example.drift_bottle.util;

import android.app.Activity;
import android.util.Log;
import com.example.drift_bottle.entity.MessageDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hyphenate.EMCallBack;
import com.hyphenate.EMError;
import com.hyphenate.chat.EMChatManager;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMConversation;
import com.hyphenate.chat.EMMessage;
import com.hyphenate.exceptions.HyphenateException;
import io.flutter.plugin.common.MethodChannel;

import java.util.ArrayList;
import java.util.List;

public class EMClientUtil {

   public static void register(String account,String password, Activity activity, MethodChannel.Result result){
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    EMClient.getInstance().createAccount(account,password);
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success("ok");
                        }
                    });
                } catch (HyphenateException e) {
                    e.printStackTrace();
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success("not_ok");
                        }
                    });
                }
            }
        }).start();

    }

    public static void login(String loginName,String password,Activity activity,MethodChannel.Result result){
       new Thread(new Runnable() {
           @Override
           public void run() {
                EMClient.getInstance().login(loginName, password, new EMCallBack() {
                    @Override
                    public void onSuccess() {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                EMClient.getInstance().groupManager().loadAllGroups();
                                EMClient.getInstance().chatManager().loadAllConversations();

                                Log.d("main", "登录聊天服务器成功！");
                                result.success("登录成功");
                            }
                        });
                    }

                    @Override
                    public void onError(int code, String error) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                System.out.println("==============="+code+error);

                                switch (code) {
                                    // 网络异常 2
                                    case EMError.NETWORK_ERROR:
                                        result.success("IM 网络错误");
                                        break;
                                    // 无效的用户名 101
                                    case EMError.INVALID_USER_NAME:
                                        result.success("IM无效的用户名");
                                        break;
                                    // 无效的密码 102
                                    case EMError.INVALID_PASSWORD:
                                        result.success("IM无效的密码");
                                        break;
                                    // 用户认证失败，用户名或密码错误 202
                                    case EMError.USER_AUTHENTICATION_FAILED:
                                        result.success("IM用户认证失败，用户名或密码错误");
                                        break;
                                    // 用户不存在 204
                                    case EMError.USER_NOT_FOUND:
                                        result.success("IM用户不存在");
                                        break;
                                    // 无法访问到服务器 300
                                    case EMError.SERVER_NOT_REACHABLE:
                                        result.success("IM无法访问到服务器 ");
                                        break;
                                    // 等待服务器响应超时 301
                                    case EMError.SERVER_TIMEOUT:
                                        result.success("IM等待服务器响应超时 ");
                                        break;
                                    // 服务器繁忙 302
                                    case EMError.SERVER_BUSY:
                                        result.success("IM服务器繁忙");
                                        break;
                                    // 未知 Server 异常 303 一般断网会出现这个错误
                                    case EMError.SERVER_UNKNOWN_ERROR:
                                        result.success("IM未知的服务器异常");
                                        break;
                                    default:
                                        result.success("IM ml_sign_in_failed");
                                        break;
                                }
                            }
                        });
                    }

                    @Override
                    public void onProgress(int progress, String status) {
                         System.out.println("正在登录");
                    }
                });
           }
       }).start();
    }


    public static void autoLogin(Activity activity,MethodChannel.Result result){
       //判断是否登录
       if(EMClient.getInstance().isLoggedInBefore()){  //已经登陆

           //获取登录账号环信id
           EMClient.getInstance().getCurrentUser();

           //根据id查询账号信息保存全局

           //跳转主页
           result.success("ok");

       }else { //未登录过
           //跳转登录
           result.success("not_ok");
       }
    }

    /**
     * 发送消息
     * @param content 文本内容
     * @param toUsername 对方用户id
     */
    public static void sendMessage(String content,String toUsername){


        System.out.println("准备发送信息；内容为"+content+"发送给："+toUsername);

        //创建一条文本消息，
        EMMessage message  = EMMessage.createTxtSendMessage(content,toUsername);

        //发送消息
        EMClient.getInstance().chatManager().sendMessage(message);

    }


    /**
     * 聊天记录
     */
    public static void chatRecord(String emid,String lastMessageId,MethodChannel.Result result){
        System.out.println("开始获取聊天记录======================>");
        EMConversation conversation = EMClient.getInstance().chatManager().getConversation(emid);
        //获取此会话的所有消息
        List<EMMessage> messages = conversation.loadMoreMsgFromDB(lastMessageId, 20);
       // List<EMMessage> messages = conversation.getAllMessages();
        List<MessageDto> messageDtos = new ArrayList<>();

        System.out.println("获取聊天记录完成======================>");
        System.out.println("聊天记录个数："+messages.size());
        if (messages!=null){  //存在聊天记录

            for (EMMessage emm:messages) {
                MessageDto messageDto = new MessageDto();
                messageDto.setFrom(emm.getFrom());
                messageDto.setMessageId(emm.getMsgId());
                messageDto.setContent_type(emm.getType().toString());
                String str = emm.getBody().toString();
                String content = str.substring(5,str.length()-1);
                messageDto.setContent(content);
                messageDtos.add(messageDto);
            }

            EMMessage message = conversation.getMessage(lastMessageId, false);
            MessageDto lastMessage = new MessageDto();
            lastMessage.setContent_type(message.getType().toString());
            lastMessage.setFrom(message.getFrom());
            String str = message.getBody().toString();
            String content = str.substring(5,str.length()-1);
            lastMessage.setContent(content);
            messageDtos.add(lastMessage);



        }


        ObjectMapper mapper = new ObjectMapper();

        try {
            System.out.println("聊天记录======================》"+ mapper.writeValueAsString(messageDtos));
            result.success( mapper.writeValueAsString(messageDtos));
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
    }
}

