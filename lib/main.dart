import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  // 最初に表示するWidget
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

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
          title: Text('2023年',style: TextStyle(fontSize: 30)),
        ),

        body: Center(
          child: Column(
            children:<Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text('設定額：',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 150,
                            child: TextField(),
                          ),
                          Text('円',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text('今月：',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 150,
                            child: TextField(),
                          ),
                          Text('円',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(250.0),
                child: ElevatedButton(
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
        )
    );
  }
}

// 入力・編集画面用Widget
class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String? isSelectedItem = 'お菓子';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: ListTile(
                    title: Text('日付：'),
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: TextField(),
                ),
                Text('日'),
              ],
            ),
          ),

          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: ListTile(
                    title: Text('項目：'),
                  ),
                ),

                DropdownButton(
                  items: const [

                    DropdownMenuItem(
                      child: Text('お菓子'),
                      value: 'お菓子',
                    ),
                    DropdownMenuItem(
                      child: Text('ジュース'),
                      value: 'ジュース',
                    ),
                    DropdownMenuItem(
                      child: Text('お弁当'),
                      value: 'お弁当',
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      isSelectedItem = value;
                    });
                  },
                  value: isSelectedItem,
                ),
              ],
            ),
          ),

          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: ListTile(
                    title: Text('メモ：'),
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: TextField(),
                ),
              ],
            ),
          ),

          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: ListTile(
                    title: Text('支出：'),
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: TextField(),
                ),
                Text('円'),
              ],
            ),
          ),

          Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    // "pop"で前の画面に戻る
                    Navigator.of(context).pop();
                  },
                  child: Text('戻る'),
                ),
                TextButton(
                  onPressed: () {
                    // "pop"で前の画面に戻る
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ]
          ),
        ] ,
      ),
    );
  }
}

// グラフ表示画面用Widget
class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('2023年',style: TextStyle(fontSize: 30)),
      ),
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