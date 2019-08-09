import 'dart:async';
import 'dart:convert';
import 'package:drift_bottle/dto/account.dart';
import 'package:drift_bottle/dto/base_reslut.dart';
import 'package:drift_bottle/dto/conversation.dart';
import 'package:drift_bottle/dto/message.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
import 'package:drift_bottle/utils/type_convert.dart';
import 'package:flutter/services.dart';

class ChannelUtils{
  static const MethodChannel _channel = const MethodChannel("channel");

  static const EventChannel eventChannel= const EventChannel('eventChannel');



  static Future<String> register(String account,String password) async{
    String result= await  _channel.invokeMethod("register",{'account':account,'password':password});
    return result;
  }

  static Future<String> login(String loginName,String password) async{
    String result = await _channel.invokeMethod("login",{'loginName':loginName,'password':password});
    return result;
  }

  //判断该用户是否登录
  static autoLogin() async {
    String result = await _channel.invokeMethod("autoLogin");
    return result;
  }

  static loginOut() {
     _channel.invokeMethod("loginOut");
  }

  //获取当前登录用户
  static getCurrentUser() async {
   String result = await _channel.invokeMethod("getCurrentUser");
   return result;
  }

  //获取环信token
  static getToken() async {
    String result = await _channel.invokeMethod("getToken");
    return result;
  }

  //发送消息
  static sendMessage(content,toUser){
    _channel.invokeMethod("sendMessage",{"content":content,"toUser":toUser});
  }

  //获取全部会话
   static Future<List<Conversation>> getAllConversations() async {
    String conJosn =await _channel.invokeMethod("allConversations");
    List conList=  json.decode(conJosn);
  //  print('flutter'+conList.length.toString());
    List<Conversation> conversationList =  TypeConvert.listConvert(conList,Conversation()); //进行类型转换
    for(Conversation con in conversationList){
     Map map =  await HttpUtils.request("account/search/${con.emid}",data: null,method: HttpUtils.GET,mode: HttpUtils.data);
     Account account = Account.fromJson(BaseResult.fromJson(map).data);
     con.nickName = account.nickname;
     con.headportrait = account.headPortrait;
    }
    return conversationList;

  }

   //聊天记录
   static Future<List<Message>> chatRecord(String emid,String lastMessageId) async {
     List<Message> messages = new List();
    if(lastMessageId.isNotEmpty){
      String chatRecord = await _channel.invokeMethod("chatRecord",{"emid":emid,"lastMessageId":lastMessageId});
      List list =  json.decode(chatRecord);

      messages = TypeConvert.listConvert(list,Message());

    }
     return messages;
  }


  //清楚未读消息
  static clearUnread(String emid){
    _channel.invokeMethod("clearUnread",{"emid":emid});
  }


  //是否连接服务器
  static Future<bool> isConnected() async {
    bool b = await _channel.invokeMethod("isConnected");
    return b;
  }


}