import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:umeng/umeng.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '暂无数据';
  String _platformVersion = 'Unknown';

  void _onData(Object event) {
    print('返回的内容: $event');
  }

  void _onError(Object error) {
    print('返回的错误');
  }

  void _onDone() {
    print('完成');
  }

  @override
  void initState() {
    super.initState();
    log("启动中....");
    Umeng.addPushCustomMessageCallback(_onData);

//    initPlatformState();
    // 5ee8cba0dbc2ec081340b58a
    // 5ee8cee4dbc2ec081340b594
    // e04c4181f34de9eb3a60e815c233d41f
//    Umeng.uMengInit("5ee8cba0dbc2ec081340b58a",
//            pushSecret: "e04c4181f34de9eb3a60e815c233d41f", logEnabled: true)
//        .then((value) {
//      if (value == null) {
//        log("初始化返回信息为空");
//        return;
//      }
//      value.forEach((key, value) {
//        log(key.toString() + " v:" + value.toString());
//      });
//    }).catchError((err) {
//      log("错误" + err.toString());
//    });

    /// 监听原生消息
//    Umeng.receiveMessage((message) {
//      log("日志消息" + message);
//      setState(() {
//        _result = message.toString();
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('测试友盟统计 '),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Text(_platformVersion),
            FlatButton(
              onPressed: () {
                Umeng.pageStart("LoginPageStart");
              },
              child: Text("统计页面进入"),
            ),
            FlatButton(
              onPressed: () {
                Umeng.pageEnd("LoginPageEnd");
              },
              child: Text("统计页面结束"),
            ),
            FlatButton(
              onPressed: () {
                Umeng.event("login", label: "登录");
              },
              child: Text("统计按钮点击事件"),
            ),
            FlatButton(
              onPressed: () {
                var flag = 100 / 0;
              },
              child: Text("测试异常"),
            ),
            FlatButton(
              onPressed: () {
//                Umeng.uMengError("有错误了");
              },
              child: Text("测试异常上报"),
            ),
            FlatButton(
              onPressed: () async {
//                _eventChannel
//                    .receiveBroadcastStream()
//                    .listen(_onEvent, onError: _onError, onDone: _onDone);
//                var result = await Umeng.pushInit("5ee8cba0dbc2ec081340b58a",
//                    "e04c4181f34de9eb3a60e815c233d41f");
//                setState(() {
//                  _result = result['result'].toString();
//                });
              },
              child: Text('注册通知'),
            ),
            FlatButton(
              onPressed: () async {
                var result = await Umeng.setAlias('17700000000', "uid");
                setState(() {
                  _result = result.runtimeType.toString();
                });
              },
              child: Text('设置别名'),
            ),
            Divider(),
            Expanded(
              child: Text(_result),
            ),
          ],
        )),
      ),
    );
  }
}
