import 'package:flutter/material.dart';

void main() {
  // 最初に表示するWidget
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'My Prevent Waste App',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      // 一覧画面を表示
      home: ListPage(),
    );
  }
}

// 一覧画面用Widget
class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('2023年',style: TextStyle(fontSize: 30),textAlign: TextAlign.right),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:<Widget>[
          ElevatedButton(
            onPressed: (){
              // "push"で新規画面に遷移
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  // 入力・編集画面を指定
                  return InputPage();
                }),
              );
            },
            child: Text('入力'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return GraphPage();
                }),
              );
            },
            child: Text('グラフ表示画面'),
          ),
        ],
      ),
    );
  }
}

// 入力・編集画面用Widget
class InputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          // ボタンをクリックした時の処理
          onPressed: () {
            // "pop"で前の画面に戻る
            Navigator.of(context).pop();
          },
          child: Text('戻る'),
        ),
      ),
    );
  }
}

// グラフ表示画面用Widget
class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          // ボタンをクリックした時の処理
          onPressed: () {
            // "pop"で前の画面に戻る
            Navigator.of(context).pop();
          },
          child: Text('一覧画面へ'),
        ),
      ),
    );
  }
}