class Conversation{
  String emid; //环信id
  int unread; //未读消息数量
  String lastMessage; //最后一条消息
  String lastMessageTime;//接收最后一条消息时间
  String lastMessageId; //最后一条消息id
  String nickName;//昵称
  String headportrait; //头像

  Conversation({this.emid,this.unread,this.lastMessage,this.lastMessageTime,this.lastMessageId});

  factory Conversation.fromJson(Map<String,dynamic> json){
  return Conversation(
    emid: json["emid"],
    unread: json["unread"],
    lastMessage: json["lastMessage"],
    lastMessageTime: json["lastMessageTime"],
    lastMessageId: json["lastMessageId"]
  );
  }
}