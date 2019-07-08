import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift_bottle/dto/base_reslut.dart';
import 'package:drift_bottle/dto/base_reslut.dart' as prefix0;
import 'package:drift_bottle/main.dart';
import 'package:drift_bottle/ui/page/login_page.dart';
import 'package:drift_bottle/utils/channel_utils.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:drift_bottle/dto/base_reslut.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List _loginMethod = [
    {
      "title": "facebook",
      "icon": Icons.book,
    },
    {
      "title": "google",
      "icon": Icons.book,
    },
    {
      "title": "twitter",
      "icon": Icons.book,
    },
  ];
  Color _color = Colors.grey;
  String _account, _password;
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  final _scaffoldkey= GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
      //  backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("注册") ,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.grey.withOpacity(0.15),
          child: ListView(
            children: <Widget>[
              Container(
                height: 350,
                padding: EdgeInsets.only(top: 20),
                margin: EdgeInsets.only(top: 30, left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Column(
                  children: <Widget>[
                    registerPhoneTestField(),
                    SizedBox(height: 35),
                    registerPasswrodTestField(),
                    SizedBox(height: 35),
                    Stack(
                      children: <Widget>[
                        registerValidateTestField(),
                        Positioned(
                          right:45,
                          top: 5,

                          child: MaterialButton(
                            child: Text('获取验证码'),
                            color: Theme.of(context).accentColor,
                            onPressed: (){},
                          ),
                        )
                      ],
                    )

                  ],
                ),
              ),
              SizedBox(height: 50),
              registerButton(),
              SizedBox(height: 40),
              Center(
                child: Text('其他方式登录'),
              ),
              Divider(color: Colors.black, height: 2.0, indent: 2.0),
              SizedBox(height: 20),
              Container(
                child: buildOtherMethod(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  _RegisterDialog(content){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text('提示'),
            content:Text(content) ,
            actions: <Widget>[
              CupertinoButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text('确定'),
              )
            ],
          );
        }
    );
  }

  //注册按钮
  Align registerButton(){
    return  Align(
      child: SizedBox(
        height: 45.0,
        width: 270,
        child: RaisedButton(
          color: Theme.of(context).accentColor,
          child: Text("注册"),
          onPressed:registerOnPressed,
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }
  //手机号输入框
  TextFormField registerPhoneTestField() {
    return TextFormField(
      onSaved: (String value) => _account = value,
      validator: (String value) {
        if (value.isEmpty) {
          return "手机号不能为空。";
        }
      },
      autovalidate: _autovalidate,
      decoration: InputDecoration(
          labelText: "请输入常用手机号",
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {},
          ),
          border: OutlineInputBorder()),
    );
  }
  //验证码输入框
  TextFormField registerValidateTestField() {
    return TextFormField(
      autovalidate: _autovalidate,
      validator: (String value) {
        if (value.isEmpty) {
          return "验证码不能为空。";
        }
      },
      decoration: InputDecoration(
        labelText: "验证码",
        suffixIcon: IconButton(
          icon: Icon(Icons.send, color: _color),
          onPressed: () {
            setState(() {
              _color = Colors.black;
            });
            //点击获取验证吗
          },
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
  //密码输入框
  TextFormField registerPasswrodTestField() {
    return TextFormField(
      autovalidate: _autovalidate,
      validator: (String value) {
        if (value.isEmpty) {
          return "密码不能位空。";
        }
      },
      onSaved: (String value) => _password = value,
      obscureText: true,
      decoration: InputDecoration(
          labelText: "密码：6-16位字符（数字,字母，区分大小写）", border: OutlineInputBorder()),
    );
  }
  //其他方式登录
  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(
                builder: (context) {
                  return IconButton(
                      icon: Icon(item['icon'],
                          color: Theme.of(context).iconTheme.color),
                      onPressed: () {
                        //TODO : 第三方登录方法
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("${item['title']}登录"),
                          action: new SnackBarAction(
                            label: "取消",
                            onPressed: () {},
                          ),
                        ));
                      });
                },
              ))
          .toList(),
    );
  }




  //点击注册
  Future registerOnPressed() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String result = await ChannelUtils.register(_account,_password); //环信注册返回注册结果
      if(result=="ok"){
       Map map =  await HttpUtils.request("account/reg",data: {"emId":_account,"password":_password},method: HttpUtils.POST ,mode: HttpUtils.queryParameters);
       BaseResult baseResult =  BaseResult.fromJson(map);
       if(baseResult.result=="ok"){
         _RegisterDialog("注册成功啦。");
       }
      }else{
        _RegisterDialog("注册失败啦，账户已经存在。");
      }

    }
    setState(() {
      _autovalidate = true;
    });
  }
}
