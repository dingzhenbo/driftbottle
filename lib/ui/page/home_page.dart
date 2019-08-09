import 'dart:convert';
import 'dart:math';

import 'package:drift_bottle/custom_widget/common_widget.dart';
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


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // static const EventChannel eventChannel = const EventChannel('eventChannel');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _offstage = true; //控制是否有未读消息提示
  @override
  void initState() {
    // TODO: implement initState
    ChannelUtils.eventChannel.receiveBroadcastStream().listen(onData);
    super.initState();
  }



  @override
  void dispose() {
    //ChannelUtils.eventChannel.receiveBroadcastStream().listen(onData).pause();
    super.dispose();
  } //Stream监听回调
  void onData(event) {
    // _connectionAlertDialog(event);
    switch (event) {
      case "user_removed":
       CommonWidget.connectionAlertDialog(logout,context,"确定","账号被移除！");
        break;
      case "user_login_another_device":
        CommonWidget.connectionAlertDialog(logout,context,"确定","您的账号已在其他设备登录");
        break;
      case "disconnected_to_service":
        CommonWidget.connectionAlertDialog(logout,context,"确定","连接聊天服务器失败");
        break;
      case "no_net":
        //CommonWidget.connectionAlertDialog((){Navigator.of(context).pop();},context,"确定","网络异常请检查你的网络。");
        break;
      default:{
        List messages = json.decode(event);
        if (messages != null) {
          //监听收到消息刷新小部件
          setState(() {});
        }
      }
      break;
    }

  }


  //注销登录
  void logout() {
    //注销登录
    ChannelUtils.loginOut();
    //返回登录界面
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: TabBar(
              indicatorPadding: EdgeInsets.zero,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black54,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                Tab(text: '首页'),
                Tab(text: '关注'),
                Stack(
                  children: <Widget>[
                    Tab(
                      text: "消息",
                    ),
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
            ),
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


}
