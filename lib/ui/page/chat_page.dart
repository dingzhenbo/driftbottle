import 'dart:convert';

import 'package:drift_bottle/custom_widget/common_widget.dart';
import 'package:drift_bottle/custom_widget/global_data_provider.dart';
import 'package:drift_bottle/dto/account.dart';
import 'package:drift_bottle/dto/base_reslut.dart';
import 'package:drift_bottle/dto/message.dart';
import 'package:drift_bottle/utils/channel_utils.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
import 'package:drift_bottle/utils/type_convert.dart';
import 'package:flutter/material.dart';



//单条聊天信息控件
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child:  Row(                                   //聊天记录的头像和文本信息横向排列
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8)
            ),
            margin: EdgeInsets.only(top: 5.0),
            child: Text(text,style: TextStyle(color: Colors.white),),
          ),
          SizedBox(width: 10,),
          Container(
            margin:  EdgeInsets.only(right: 16.0),
            child:CommonWidget.chatOvalPortrait(NetworkImage(GlobalDataProvider.account.headPortrait)),      //显示头像圆圈
          )
        ],
      ),
    );
  }
}


//非自己单条聊天信息控件
class FromChatMessage extends StatelessWidget {
  FromChatMessage({this.text,this.headPortrait});
  final String text;
  final String headPortrait;
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child:  Row(                                   //聊天记录的头像和文本信息横向排列
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin:  EdgeInsets.only(right: 16.0),
            child:CommonWidget.chatOvalPortrait(NetworkImage(headPortrait)),      //显示头像圆圈
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8)
            ),
            margin: EdgeInsets.only(top: 5.0),
            child: Text(text,style: TextStyle(color: Colors.white),),
          ),

        ],
      ),
    );
  }
}

//聊天主页面ChatScreen控件定义为一个有状态控件
// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  final String toEmid;  //对方环信id
  final String nickName; //对方昵称
  final String handPortrait; //对方的头像
  ChatScreen({this.toEmid,this.nickName,this.handPortrait});
  @override
  State createState() => new ChatScreenState();   //ChatScreenState作为控制ChatScreen控件状态的子类
}

//ChatScreenState状态中实现聊天内容的动态更新
class ChatScreenState extends State<ChatScreen>{
  final List<Widget> _messages = <Widget>[];    //存放聊天记录的数组，数组类型为无状态控件ChatMessage
  final TextEditingController _textController = new TextEditingController();    //聊天窗口的文本输入控件

  //定义发送文本事件的处理函数
  void _handleSubmitted(String text) {
    _textController.clear();        //清空输入框
    ChatMessage message = new ChatMessage(    //定义新的消息记录控件对象
      text: text);
    print("发送信息"+widget.toEmid+"内容为"+text);
    ChannelUtils.sendMessage(text,widget.toEmid);
    //状态变更，向聊天记录中插入新记录
    setState(() {
      _messages.add(message);      //插入新的消息记录
    });
  }

  //定义文本输入框控件
  Widget _buildTextComposer() {
    return  Container(
        margin:  EdgeInsets.symmetric(horizontal: 8.0),
        child:  Row(                    //文本输入和发送按钮都在同一行，使用Row控件包裹实现
            children: <Widget>[
              Flexible(
                child:  TextField(
                  controller: _textController,              //载入文本输入控件
                  onSubmitted: _handleSubmitted,
                  decoration:  InputDecoration.collapsed(hintText: "Send a message"),      //输入框中默认提示文字
                ),
              ),
              Container(
                margin:  EdgeInsets.symmetric(horizontal: 4.0),
                child:  IconButton(            //发送按钮
                    icon:  Icon(Icons.send),    //发送按钮图标
                    onPressed: () => _handleSubmitted(_textController.text)),      //触发发送消息事件执行的函数_handleSubmitted
              ),
            ]
        )
    );
  }
  //定义整个聊天窗口的页面元素布局
  Widget build(BuildContext context) {
    return  Scaffold(              //页面脚手架
      appBar:  AppBar(
          centerTitle: true,
          title:  Text(widget.nickName)
      ),      //页面标题
      body:  Column(             //Column使消息记录和消息输入框垂直排列
          children: <Widget>[
            Flexible(                     //子控件可柔性填充，如果下方弹出输入框，使消息记录列表可适当缩小高度
                child:  ListView.builder(
                  //可滚动显示的消息列表
                  padding:  EdgeInsets.all(8.0),
                //  reverse: true,                  //反转排序，列表信息从下至上排列
                  itemBuilder: (context,index) => _messages[index],    //插入聊天信息控件
                  itemCount: _messages.length,
                )
            ),
            Divider(height: 1.0),      //聊天记录和输入框之间的分隔
            Container(
              decoration:  BoxDecoration(
                  color: Theme.of(context).cardColor),
              child: _buildTextComposer(),        //页面下方的文本输入控件
            ),
          ]
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    ChannelUtils.eventChannel.receiveBroadcastStream().listen(onDate);
    initChatRecord();
    ChannelUtils.clearUnread(widget.toEmid);
    super.initState();
  }
  //历史消息记录
  initChatRecord() async {
   List<Message> messages =  await ChannelUtils.chatRecord(widget.toEmid);
   for(Message message in messages){
     print('聊天记录对象============>'+message.from);
     setState(() {
       if(message.from==GlobalDataProvider.account.emId){
         _messages.add(ChatMessage(text:message.content));
       }else{
         _messages.add(FromChatMessage(text: message.content,headPortrait: widget.handPortrait,));
       }
     });

   }
  }

   //消息接收监听
   onDate(event) async {
   List list =  json.decode(event);

   List<Message> messageList = TypeConvert.listConvert(list,Message());
   if(messageList[0].from==widget.toEmid){
     for(Message message in messageList){
      //Map map = await HttpUtils.request("account/search/${message.from}",data: null,method: HttpUtils.GET,mode: HttpUtils.data);
      //BaseResult baseResult =  BaseResult.fromJson(map);
    //  Account account =  Account.fromJson(baseResult.data);
       FromChatMessage fromChatMessage = new FromChatMessage(text: message.content,headPortrait: widget.handPortrait);
       setState(() {
         _messages.add(fromChatMessage);
       });

     }
   }

  }
}