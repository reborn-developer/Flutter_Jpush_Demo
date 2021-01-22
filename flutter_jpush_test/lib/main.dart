import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String debugLable = 'unknow';
  final JPush jpush = new JPush();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try{
      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print('>>>>>flutter接收到推送:${message}');

          setState(() {
            debugLable = '接收到推送"${message}';
          });
        }
      );

    } on PlatformException{
      platformVersion = '平台版本获取失败，请检查';
    }

    if(!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('极光推送'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('结果${debugLable}'),
              FlatButton(
                  onPressed: (){
                    var fireDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + 3000);
                    var localNotification = LocalNotification(
                      id: 234,
                      title: '飞鸽传书',
                      buildId: 1,
                      content: '看到了说明已经成功了',
                      fireTime: fireDate,
                      subtitle: '一个测试',
                    );
                    jpush.sendLocalNotification(localNotification).then((res) {

                      setState(() {
                        debugLable = res;
                      });

                    });
                  },
                  child: Text('发送推送信息'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
