import 'package:flutter/material.dart';

class CommonWidget {
  //自定义圆角头像小部件 (用于用户列表项)
  static Widget rrectPortrait(ImageProvider image) {
    return Container(
      width: 50,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Image(
          image: image,
          //fit: BoxFit.fill,
        ),
      ),
    );
  }

  //自定义圆形头像小部件 (用于用户信息展示)
  static Widget ovalPortrait(ImageProvider image) {
    return Container(
      width: 100,
      height: 100,
      child: ClipOval(
        child: Image(
          image: image,
          //fit: BoxFit.fill,
        ),
      ),
    );
  }

  //自定义圆形头像小部件 (用于用户信息展示)
  static Widget chatOvalPortrait(ImageProvider image) {
    return Container(
      width: 50,
      height: 50,
      child: ClipOval(
        child: Image(
          image: image,
          //fit: BoxFit.fill,
        ),
      ),
    );
  }

  //自定义标签
  static Widget tab(content, Color color) {
    return Container(
      padding: EdgeInsets.only(top: 3, bottom: 3, left: 6, right: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black54),
      child: Center(
          child: Text(content, style: TextStyle(color: color, fontSize: 12))),
    );
  }

  //自定义用户列表项
  static Material accountListItem(void _onTop(), {title, ImageProvider image}) {
    return Material(
      child: InkWell(
        onTap: _onTop,
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(width: 15),
                rrectPortrait(image), // <-- 自定义头像小部件
                SizedBox(width: 20),
                Text(
                  title,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(color: Colors.black54, height: 0.0, indent: 75.0),
          ],
        ),
      ),
    );
  }

  //自定义会话列表项
  static Stack conversationListItem(void _onTop(), {nickName, ImageProvider image, lastMessage, lastMessageTime,int unread}) {
    bool _offstage =true;
    String _unread =unread.toString();
    if(unread>0){
      _offstage = false;
    }
    if(unread>99){
      _unread="99+";
    }
    return Stack(
      children: <Widget>[
        Material(
          child: InkWell(
            onTap: _onTop,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15),
                    rrectPortrait(image), // <-- 自定义头像小部件
                    SizedBox(width: 20),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              nickName, //昵称
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 200),
                            Text(lastMessageTime) //最后一次会话时间
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(lastMessage),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Divider(color: Colors.black54, height: 0.0, indent: 75.0),
              ],
            ),
          ),
        ),
        Positioned(
          child: Offstage(
            offstage:_offstage,
            child: ClipOval(
                child: Container(
                    width: 25,
                    height: 25,
                    color: Colors.red,
                    child: Center(
                      child: Text(_unread,style: TextStyle(color: Colors.white),),
                    )
                )
            ),
          ),
        )

      ],
    );
  }
}
