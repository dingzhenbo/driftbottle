import 'dart:convert';

import 'package:drift_bottle/custom_widget/common_widget.dart';
import 'package:drift_bottle/custom_widget/global_data_provider.dart';
import 'package:drift_bottle/dto/account.dart';
import 'package:drift_bottle/dto/base_reslut.dart';
import 'package:drift_bottle/ui/page/contacts_details_page.dart';
import 'package:drift_bottle/ui/page/register_page.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
import 'package:drift_bottle/utils/type_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// 联系人页面
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
    return Container(
      child:FutureBuilder(
        future:attentionList(),
        builder:(BuildContext context,AsyncSnapshot<BaseResult> asyncSnapshot){
          if(asyncSnapshot.hasData){
            if(asyncSnapshot.data.result=="ok"){
              List<Account> accountList = TypeConvert.listConvert(asyncSnapshot.data.data,Account());
              return ListView.builder(
                itemCount:accountList.length,
                itemBuilder:(context,index){
                return CommonWidget.accountListItem((){
                  //TODO 路由用户详情信息界面
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ContactsDetailsPage(emid: accountList[index].emId)));
                },title: accountList[index].nickname,image: NetworkImage(accountList[index].headPortrait));
                },
              );
            }
            }else{
            return Text("加载关注列表");
          }
        },
      )
    );
  }


  ///关注列表
  Future<BaseResult> attentionList() async {
    Map map = await  HttpUtils.request("account/attention/list/${GlobalDataProvider.id}",data: null,method: HttpUtils.GET,mode: HttpUtils.data);
    BaseResult baseResult =  BaseResult.fromJson(map);
    return baseResult;
  }



}







