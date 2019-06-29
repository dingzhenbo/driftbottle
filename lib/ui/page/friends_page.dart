
import 'dart:convert';

import 'package:drift_bottle/dto/account.dart';
import 'package:drift_bottle/dto/base_reslut.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
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
          onPressed: () async {

          },
        ),
      ),
      body: FutureBuilder(
        future:test2(),
        builder: (BuildContext context,AsyncSnapshot<BaseResult> snapshot){
          if(snapshot.hasData){
            return Text(snapshot.data.result.toString());
          }else{
            //等待数据
            return Text("加载中。。。。");
          }
         // print(snapshot);
        },
      ),
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
}
