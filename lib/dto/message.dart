class Message{

  String contentType;//内容类型
  String content;//消息
  String from; //消息发送者
  //String headPortrait;//消息发送者头像

  Message({this.content,this.contentType,this.from});

factory Message.fromjson(Map<String,dynamic> json){
 return Message(
     content: json["content"],
     contentType: json["contentType"],
     from: json["from"]
 );
}


}