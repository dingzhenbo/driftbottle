
import 'dart:convert';

import 'package:drift_bottle/custom_widget/common_widget.dart';
import 'package:drift_bottle/dto/account.dart';
import 'package:drift_bottle/dto/base_reslut.dart';
import 'package:drift_bottle/utils/channel_utils.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
import 'package:drift_bottle/utils/type_convert.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MaterialButton(
          child: Text("点我"),
          color:Colors.pink,
          onPressed: test4,
        ),
      ),
     /* body: */ /*FutureBuilder(
        future: test3(),
        builder: (BuildContext context,AsyncSnapshot<BaseResult> asyncSnapshot){
          if(asyncSnapshot.hasData){
            if(asyncSnapshot.data.result=="ok"){
              List<Account> accountList =TypeConvert.listConvert( asyncSnapshot.data.data,Account());

              return ListView.builder(
                itemCount: accountList.length,
                itemBuilder: (context,index){
                  return CommonWidget.accountListItem((){},title: accountList[index].emId,image: NetworkImage(accountList[index].headPortrait));
                },
              );
            }
            return Text(asyncSnapshot.data.data.toString());
          }else{
            return Text("加载中。。。");
          }
        },
      )*/
    );
  }

   text() async {
    print('发送请求。');

      Map map = await HttpUtils.request("account/test/d",method: HttpUtils.GET);
      BaseResult baseResult =  BaseResult.fromJson(map);
      print(baseResult.result);
      print(baseResult.data);
      print(baseResult.error);
      print(baseResult.success);

  }

  
   Future<BaseResult> test3() async {
   Map map = await  HttpUtils.request("account/attention/list/7",data: null,method: HttpUtils.GET,mode: HttpUtils.data);
   BaseResult baseResult =  BaseResult.fromJson(map);
   print("=============================>"+baseResult.result);
   return baseResult;
  }


  Future<BaseResult> test2() async {
    await Future.delayed(Duration(seconds: 3), () {
      print("延时三秒后请求数据");
    });

    Map map = await HttpUtils.request("account/search/1646775487",data: null,method: HttpUtils.GET,mode: HttpUtils.data);
    BaseResult baseResult =  BaseResult.fromJson(map);
   /* print(baseResult.result);
    Account account =  Account.fromJson(baseResult.data);
    print(account.id.toString());*/
    return baseResult;
  }

  test4() async {
    print('执行测试');
    List list =  await  ChannelUtils.getAllConversations();
    print("输出结果："+list.toString());
  }
}
