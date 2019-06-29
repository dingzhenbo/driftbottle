import 'package:flutter/material.dart';

class CommonWidget {
  //自定义圆角头像小部件 (用于用户列表项)
  static Widget rrectPortrait(ImageProvider image) {
    return Container(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Image(
          image: image,
          //fit: BoxFit.fill,
        ),
      ),
    );
  }

  //自定义圆角头像小部件 (用于用户信息展示)
  static Widget OvalPortrait(ImageProvider image) {
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
  //自定义标签
  static Widget tab(content,Color color) {
    return Container(
      padding: EdgeInsets.only(top: 3,bottom: 3,left: 6,right: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black54),
      child: Center(child: Text(content, style: TextStyle(color:color,fontSize: 12))),
    );
  }

  //自定义用户列表项
  static Material accountListItem(void _onTop(), {title, ImageProvider image}) {
    return Material(
      child: InkWell(
        onTap: _onTop,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                rrectPortrait(image), // <-- 自定义头像小部件
                SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Divider(color: Colors.black, height: 0.0, indent: 60.0),
          ],
        ),
      ),
    );
  }
}
