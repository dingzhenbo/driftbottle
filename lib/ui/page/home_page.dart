import 'dart:convert';
import 'dart:math';

import 'package:drift_bottle/custom_widget/custom_drawer.dart';
import 'package:drift_bottle/custom_widget/global_data_provider.dart';
import 'package:drift_bottle/dto/conversation.dart';
import 'package:drift_bottle/ui/page/contacts_page.dart';
import 'package:drift_bottle/ui/page/conversation_page.dart';
import 'package:drift_bottle/ui/page/driftbottle_page.dart';
import 'package:drift_bottle/ui/page/login_page.dart';
import 'package:drift_bottle/ui/page/search_bar.dart';
import 'package:drift_bottle/utils/channel_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 // static const EventChannel eventChannel = const EventChannel('eventChannel');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _offstage = true;  //控制是否有未读消息提示
  @override
  void initState() {
    // TODO: implement initState
    ChannelUtils.eventChannel.receiveBroadcastStream().listen(onData);
    super.initState();

  }

  updateOffstage() async {
    List<Conversation> conversations = await  ChannelUtils.getAllConversations();
    int count =0 ;
    for(Conversation conversation in conversations){
      count = count+conversation.unread;
    }
    if(count>0){
      setState(() {
        _offstage =false;
      });
    }else{
      setState(() {
        _offstage = true;
      });

    }
  }
  //Stream监听回调
  void onData(event) {
   // _connectionAlertDialog(event);
    switch(event){
      case "user_removed":
        _connectionAlertDialog("账号被移除！");
        break;
      case "user_login_another_device":
        _connectionAlertDialog("您的账号已在其他设备登录");
        break;
      case "no_net":
        _connectionAlertDialog("当前网络不可用");
        break;
    }
    List messages =  json.decode(event);
    if(messages!=null){  //监听收到消息刷新小部件
      setState(() {
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title:TabBar(
              indicatorPadding: EdgeInsets.zero,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black54,
              indicatorSize: TabBarIndicatorSize.label,


              tabs: <Widget>[
                Tab(text: '首页'),
                Tab(text: '关注'),
                Stack(
                  children: <Widget>[
                    Tab(text: "消息",),
                    Positioned(
                      top: 2,
                      right: 0,
                      child: Offstage(
                        offstage: _offstage,
                        child: ClipOval(
                          child: Container(
                            height: 8,
                            width: 8,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ) ,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showSearch(context: context, delegate: SearchBar());
                },
              )
            ],

          ),
          body: TabBarView(
            children: <Widget>[
              DriftBottlePage(),
              ContactsPage(),
              ConversationPage()
            ],
          ),
          drawer: CustomDrawer(),
        ));
  }

  //Stream 对话框
   _connectionAlertDialog(content){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('警告'),
            content: Text(content),
            actions: <Widget>[
              CupertinoButton(
                  onPressed: () {
                    //注销登录
                    ChannelUtils.loginOut();
                    //返回登录界面
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text('确认')),
            ],
          );
        });
  }
}
