import 'dart:async';

import 'package:drift_bottle/ui/page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static autoLogin() async {
    String result = await _channel.invokeMethod("autoLogin");
    return result;
  }

  static loginOut() {
     _channel.invokeMethod("loginOut");
  }


}