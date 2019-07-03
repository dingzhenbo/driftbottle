import 'dart:io';

import 'package:drift_bottle/custom_widget/common_widget.dart';
import 'package:drift_bottle/custom_widget/global_data_provider.dart';
import 'package:drift_bottle/dto/account.dart';
import 'package:drift_bottle/dto/base_reslut.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 通讯录 => 详细
/// 2019-03-23
class ContactsDetailsPage extends StatefulWidget {
  final String emid;
  ContactsDetailsPage({this.emid});
  @override
  _ContactsDetailsPageState createState() => _ContactsDetailsPageState();

}

class _ContactsDetailsPageState extends State<ContactsDetailsPage> {

  String _attentionText="关注";
  IconData _attentionIcon = Icons.add;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future:getBaseResult(widget.emid),
        builder:(BuildContext context,AsyncSnapshot<BaseResult> snapshot){
          if(snapshot.hasData){
            if(snapshot.data.result=="ok"){
              Account account =  Account.fromJson(snapshot.data.data);  //获取用户信息
              return  Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(account.cardPicture),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black, BlendMode.screen)
                        ),
                       // borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  Positioned(
                    top:35,
                    left: 20,
                    child:Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ///头像
                              CommonWidget.OvalPortrait(NetworkImage(account.headPortrait)),
                            ],
                          ),
                          //昵称
                          SizedBox(height: 10),
                          Text(account.nickname,style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              CommonWidget.tab("♂20",Colors.blue),
                              SizedBox(width: 10),
                              CommonWidget.tab(account.city,Colors.white),
                              SizedBox(width: 10),
                              CommonWidget.tab("摩羯座",Colors.white)

                            ],
                          ),
                          SizedBox(height: 10),
                          //个性签名
                          Text(account.signature),

                        ],
                      ),

                    ) ,
                  ),
                  Positioned(
                    top: 30,
                    right: 30,
                    child: InkWell(
                      onTap: (){},
                      child: Chip(
                        backgroundColor: Colors.black38,
                        label:Container(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.message),
                              SizedBox(width: 8),
                              Text("私信",style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                        padding: EdgeInsets.only(left: 10,right: 10),

                      )
                      ,
                    )
                    ,
                  ),
                  Positioned(
                    top:90,
                    right:28 ,
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          if(_attentionText=="关注"){
                            HttpUtils.request("account/attention/${GlobalDataProvider.id}/${account.id}",data: null,method: HttpUtils.POST,mode: HttpUtils.data);
                            _attentionText="已关注";
                            _attentionIcon=Icons.check;
                          }else{
                            HttpUtils.request("account/attention/cancel/${GlobalDataProvider.id}/${account.id}",data: null,method: HttpUtils.POST,mode: HttpUtils.data);
                            _attentionText="关注";
                            _attentionIcon=Icons.add;
                          }

                        });
                      },
                      child: Chip(
                        backgroundColor: Colors.blue,
                        label:Container(
                          child: Row(
                            children: <Widget>[
                              Icon(_attentionIcon),
                              SizedBox(width: 8),
                              Text(_attentionText,style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                        padding: EdgeInsets.only(left: 10,right: 10),

                      )
                      ,
                    )
                    ,
                  ),
                  Positioned(
                    bottom: 280,
                    child: Container(
                      height: 80,
                      width: 400,
                      decoration: BoxDecoration(
                          color: Colors.black54,
                         // borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(width: 10),
                          Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Text(account.putBottleCount.toString(),style: TextStyle(color: Colors.white),),
                              SizedBox(height: 15),
                              Text("扔瓶子",style: TextStyle(color: Colors.white))

                            ],
                          ),
                          SizedBox(width: 20,),
                          Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Text(account.getBottleCount.toString(),style: TextStyle(color: Colors.white),),
                              SizedBox(height: 15),
                              Text("捡瓶子",style: TextStyle(color: Colors.white))

                            ],
                          ),
                          SizedBox(width: 20,),
                          Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Text(account.attentionCount.toString(),style: TextStyle(color: Colors.white),),
                              SizedBox(height: 15),
                              Text("关注",style: TextStyle(color: Colors.white))

                            ],
                          ),
                          SizedBox(width: 20,),
                          Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Text(account.fansCount.toString(),style: TextStyle(color: Colors.white),),
                              SizedBox(height: 15),
                              Text("粉丝",style: TextStyle(color: Colors.white))

                            ],
                          ),
                          SizedBox(width: 10),



                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 150,
                      right: 30,
                      child: Container(
                        child: MaterialButton(
                            onPressed: (){},
                            color: Colors.yellow,
                            child: Text("举报")
                        ),
                      )
                  )

                ],
              );
            }else{  //用户不存在

              return Text("用户不存在");
            }
          }else{
            return Text("搜索中。。。");
          }
        }
      ),
    );
  }
  //查询用户
  Future<BaseResult> getBaseResult(emid) async {
    /*await Future.delayed(Duration(seconds: 3), () {
      print("延时三秒后请求数据");
    });*/

    Map map = await HttpUtils.request("account/search/$emid",data: null,method: HttpUtils.GET,mode: HttpUtils.data);
    BaseResult baseResult =  BaseResult.fromJson(map);
    return baseResult;
  }

  attentionState(current) async {
    int id = await HttpUtils.request("account/get/id/${widget.emid}");
    bool result =  await HttpUtils.request("account/attention/state/$current/$id");
    if(result){
      setState(() {
        _attentionText="已关注";
      });

    }
  }

  
  @override
  void initState() {
    // TODO: implement initState
    attentionState(GlobalDataProvider.id);
    super.initState();
  }
}

