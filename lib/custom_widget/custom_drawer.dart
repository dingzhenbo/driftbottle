import 'package:cached_network_image/cached_network_image.dart';
import 'package:drift_bottle/custom_widget/global_data_provider.dart';
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
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName:Text(GlobalDataProvider.account.nickname,style: TextStyle(fontWeight: FontWeight.w300),),
              accountEmail: Text(GlobalDataProvider.account.email,style: TextStyle(fontWeight: FontWeight.w300),),
              currentAccountPicture: CircleAvatar(
                backgroundImage:CachedNetworkImageProvider("http://b-ssl.duitang.com/uploads/item/201811/30/20181130175306_pxrzb.jpg",errorListener: (){}),
              ),

            decoration: BoxDecoration(
              color:Theme.of(context).accentColor.withOpacity(0.8),
             /* image:DecorationImage(
                image:NetworkImage("http://pic.616pic.com/bg_w1180/00/24/69/fuRbiNwMtL.jpg"),
                fit:BoxFit.cover,
               // colorFilter:ColorFilter.mode(Colors.cyan.withOpacity(0.5), BlendMode.screen)
              )*/
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("夜间模式"),
            leading: Icon(Icons.brightness_2,size: 25),
            onTap: (){},
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("附近的人"),
            leading: Icon(Icons.add_location,size: 25),
            onTap: (){},
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("设置"),
            leading: Icon(Icons.settings,size: 25),
            onTap: (){},
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
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
