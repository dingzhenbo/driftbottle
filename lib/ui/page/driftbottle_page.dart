import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriftBottlePage extends StatefulWidget {
  @override
  _DriftBottlePageState createState() => _DriftBottlePageState();
}

class _DriftBottlePageState extends State<DriftBottlePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.zero,
              width: 412,
              child: Image(
                image: NetworkImage('https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559220170429&di=eb6a71ec44ffadac3dfe5ff8a965220b&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201810%2F01%2F20181001105435_abwjp.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
