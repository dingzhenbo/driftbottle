import 'dart:convert';

import 'package:drift_bottle/custom_widget/common_widget.dart';
import 'package:drift_bottle/dto/base_reslut.dart';
import 'package:drift_bottle/ui/page/contacts_details_page.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// 联系人页面
/// 2019-03-17
class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CommonWidget.accountListItem(_onTopSearch,title: "搜索用户", image: NetworkImage("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561611212189&di=eb0f17cad351034abe463744039d7197&imgtype=0&src=http%3A%2F%2Fbpic.588ku.com%2Felement_origin_min_pic%2F00%2F86%2F45%2F2156eb636c4b82e.jpg"),)
      ],
    );
  }

  //添加新朋友回调
  void _onTopSearch(){
    showSearch(context: context, delegate: SearchBar());
  }
   //
/*
  static Material accountListItem(void _onTop(),{title,ImageProvider image}){
    return Material(
      child: InkWell(
        onTap:_onTop,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                SizedBox(width: 15,),
                CommonWidget.rrectPortrait(image),// <-- 自定义头像小部件
                SizedBox(width: 20,),
                Text(title,style: TextStyle(fontSize:16),),
              ],
            ),
            SizedBox(height:10.0),
            Divider(color: Colors.black, height:0.0, indent: 60.0),


          ],
        ),
      ),
    );
  }
*/
}



//搜索
class SearchBar extends SearchDelegate<String> {

  // 点击清楚的方法
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        // 点击把文本空的内容清空
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  // 点击箭头返回
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        // 使用动画效果返回
        icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,
      ),
      // 点击的时候关闭页面（上下文）
      onPressed: () {
        close(context, null);
      },
    );
  }

  // 点击搜索出现结果
  @override
  Widget buildResults(BuildContext context) {
    if(query.isNotEmpty){
      return ContactsDetailsPage(id: query);
    }
   return Text("");
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    // 模拟的假数据
/*    const searchList = [
      "lao-老王",
      "lao-老张",
      "xiao-小王",
      "xiao-小张"
    ];

    const recentSuggest = [
      "马云-1",
      "马化腾-2"
    ];

    // 定义变量 并进行判断
    final suggestionList = query.isEmpty
        ? recentSuggest
        :searchList.where((input) => input.startsWith(query)).toList();*/
    return Container();/*ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context,index){
          return  ListTile(
              title: RichText(
                  text: TextSpan(
                    // 获取搜索框内输入的字符串，设置它的颜色并让让加粗
                      text: suggestionList[index].substring(0, query.length),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          //获取剩下的字符串，并让它变成灰色
                            text: suggestionList[index].substring(query.length),
                            style: TextStyle(color: Colors.grey))
                      ]
                  )
              )
          );
        }
    );*/
  }

}




