import 'package:drift_bottle/ui/page/login_page.dart';
import 'package:drift_bottle/utils/channel_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559220170429&di=eb6a71ec44ffadac3dfe5ff8a965220b&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201810%2F01%2F20181001105435_abwjp.jpg'),
              ),
              accountName:
                  Text("D", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(
                "D@qq.com",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            decoration: BoxDecoration(
              color:Colors.cyan,
              image:DecorationImage(
                image:NetworkImage("https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=221593033,8564015&fm=26&gp=0.jpg"),
                fit:BoxFit.cover,
                colorFilter:ColorFilter.mode(Colors.cyan.withOpacity(0.5), BlendMode.screen)
              )
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text("夜间模式"),
            leading: Icon(Icons.brightness_2,size: 25),
            onTap: (){},
          ),
          ListTile(
            title: Text("附近的人"),
            leading: Icon(Icons.add_location,size: 25),
            onTap: (){},
          ),
          ListTile(
            title: Text("设置"),
            leading: Icon(Icons.settings,size: 25),
            onTap: (){},
          ),
          ListTile(
            title: Text("注销"),
            leading: Icon(Icons.block,size: 25),
            onTap: (){
              ChannelUtils.loginOut();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>LoginPage()),(Route<dynamic> route)=>false);
            },
          )
        ],
      ),
    );
  }
}
