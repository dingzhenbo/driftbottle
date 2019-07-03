
import 'package:drift_bottle/ui/page/chat_page.dart';
import 'package:drift_bottle/ui/page/home_page.dart';
import 'package:drift_bottle/ui/page/login_page.dart';
import 'package:drift_bottle/utils/channel_utils.dart';
import 'package:drift_bottle/utils/dio_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_widget/global_data_provider.dart';
void main() async{

  AutoLogin.autoLogin= await ChannelUtils.autoLogin();
  runApp(App());
}


class AutoLogin{
  static String autoLogin;
  static Widget home(){
    if(autoLogin=="ok"){
      globalDataInit(); //
      return HomePage();
    }else{
      return LoginPage();
    }
  }

  ///初始化全局数据
  static globalDataInit() async {
    GlobalDataProvider.emId= await ChannelUtils.getCurrentUser();
    GlobalDataProvider.id =  await HttpUtils.request("account/get/id/${GlobalDataProvider.emId}",data: null,method: HttpUtils.GET,mode: HttpUtils.data);
    GlobalDataProvider.token = await ChannelUtils.getToken();
  }
}


class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.cyan),
      debugShowCheckedModeBanner: false,
      home:MyHome()
    );


  }


}


class MyHome extends StatefulWidget {

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin{


  AnimationController _controller;//AnimationController是Animation的一个子类，它可以控制Animation，可以控制动画的时间，类型，过渡3曲线
  Animation _animation;



  @override
   initState(){
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    //上面两行代码表示初始化一个Animation控制器， vsync垂直同步，动画执行时间3000毫秒,然后我们设置一个Animation动画，使用上面设置的控制器

    //监听动画运行状态，当状态为completed时，动画执行结束，跳转首页
    _animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context){
              return AutoLogin.home();
            }),
                (route) => route == null
        );
      }
    });
    _controller.forward(); // 播放动画
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();//释放动画
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(//透明度动画组件
      opacity: _animation, //动画
      child: Image.network(
        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1260314136,334816822&fm=26&gp=0.jpg',
        fit: BoxFit.cover, //图片铺满
        scale: 2.0, //进行缩放
      ),

    );
  }
}







