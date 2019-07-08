import 'package:drift_bottle/custom_widget/common_widget.dart';
import 'package:drift_bottle/dto/conversation.dart';
import 'package:drift_bottle/ui/page/chat_page.dart';
import 'package:drift_bottle/utils/channel_utils.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ChannelUtils.getAllConversations(),
      builder: (BuildContext context,AsyncSnapshot<List<Conversation>> asyncSnapshot){
        if(asyncSnapshot.hasData){
          return ListView.builder(
              itemCount: asyncSnapshot.data.length,
              itemBuilder:(context,index){
                return CommonWidget.conversationListItem((){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>ChatScreen(toEmid: asyncSnapshot.data[index].emid,nickName: asyncSnapshot.data[index].nickName,handPortrait: asyncSnapshot.data[index].headportrait,)));
                },nickName: asyncSnapshot.data[index].nickName,image: NetworkImage(asyncSnapshot.data[index].headportrait),lastMessage: asyncSnapshot.data[index].lastMessage,lastMessageTime: asyncSnapshot.data[index].lastMessageTime,unread: asyncSnapshot.data[index].unread);
              }
          );
        }else{
          return Text("");
        }
      },
    );
  }
}
