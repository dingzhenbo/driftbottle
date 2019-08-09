import 'package:cached_network_image/cached_network_image.dart';
import 'package:drift_bottle/custom_widget/global_data_provider.dart';
import 'package:drift_bottle/custom_widget/global_data_provider.dart' as prefix0;
import 'package:drift_bottle/dto/account.dart';
import 'package:drift_bottle/dto/base_reslut.dart';
import 'package:drift_bottle/ui/page/home_page.dart';
import 'package:drift_bottle/ui/page/register_page.dart';
import 'package:drift_bottle/utils/channel_utils.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autovalidate = false;
  String _loginName, _password;
  bool _isObscure = true;
  Color _eyeColor;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(height: 80.0),
                buildPortrait(),
                SizedBox(height: 50.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                SizedBox(height: 20.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildOtherLoginText(),
                buildOtherMethod(context),
                buildRegisterText(context),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  //TODO 跳转到注册页面
                    builder: (BuildContext context) => RegisterPage()));
                /*  Navigator.pop(context);*/
              },
            ),
          ],
        ),
      ),
    );
  }

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
                        ));
                      });
                },
              ))
          .toList(),
    );
  }

  Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他账号登录',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text('Login', style: Theme.of(context).primaryTextTheme.headline,),
          color: Theme.of(context).accentColor,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //TODO 执行登录方法
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("正在登录....")));
              String result= await ChannelUtils.login(_loginName,_password);
              if(result=="登录成功"){
                ///初始化全局数据
                String emId = await ChannelUtils.getCurrentUser();  //获取当前登录环信id
               // GlobalDataProvider.id =  await HttpUtils.request("account/get/id/${GlobalDataProvider.emId}",data: null,method: HttpUtils.GET,mode: HttpUtils.data);
                Map map =   await HttpUtils.request("account/search/$emId",data: null,method: HttpUtils.GET,mode: HttpUtils.data);
                GlobalDataProvider.account =  Account.fromJson(BaseResult.fromJson(map).data);
                print("==========================>头像url"+GlobalDataProvider.account.headPortrait);
                GlobalDataProvider.token = await ChannelUtils.getToken(); //获取token

                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>HomePage()),(Route<dynamic> route)=>false);
              }else{
                _loginAlertDialog(result);
              }

            }
            setState(() {
              _autovalidate = true;
            });
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  //提示框
  _loginAlertDialog(content){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('提示'),
            content: Text(content),
            actions: <Widget>[
              CupertinoButton(
                  onPressed: () {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  Navigator.of(context).pop();
                  },
                  child: Text('确认')),
            ],
          );
        });
  }


  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            '忘记密码？',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      autovalidate: _autovalidate,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Emall Address and phone',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入账号';
        }
      },
      onSaved: (String value) => _loginName = value,
      autovalidate: _autovalidate,
    );
  }


  //头像
  Center buildPortrait() {
    return Center(
      child: ClipOval(
        child: CachedNetworkImage(imageUrl: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559220170429&di=eb6a71ec44ffadac3dfe5ff8a965220b&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201810%2F01%2F20181001105435_abwjp.jpg",
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
