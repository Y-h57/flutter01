import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/config.dart';

final configurations = Configurations();

Future<void> main() async {
  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: configurations.apiKey,
        authDomain: configurations.authDomain,
        projectId: configurations.projectId,
        storageBucket: configurations.storageBucket,
        messagingSenderId: configurations.messagingSenderId,
        appId: configurations.appId
    ),
  );
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
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('設定額：',style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 100,
                          child: TextField(),
                        ),
                        Text('円',style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('今月：',style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 100,
                          child: TextField(),
                        ),
                        Text('円',style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),

              Expanded(
                // FutureBuilder
                // 非同期処理の結果を元にWidgetを作れる
                child: FutureBuilder<QuerySnapshot>(
                  // 入力日時でソート
                  future: FirebaseFirestore.instance
                      .collection('input')
                      .orderBy('date')
                      .get(),
                  builder: (context, snapshot) {
                    // データが取得できた場合
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> documents = snapshot.data!.docs;
                      // 取得した入力情報を元にリスト表示
                      return ListView(
                        children: documents.map((document) {
                          return GestureDetector(
                            child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Text(document['date']),
                                    Text(document['category']),
                                    Text(document['name']),
                                    Text(document['value']),
                                  ],
                                )
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return Center(
                      child: Text('読込中...'),
                    );
                  },
                ),
              ),

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
  String date = '';
  String? isSelectedItem = 'お菓子';
  String name = '';
  String amount = '';

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
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        date = value;
                      });
                    },
                  ),
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
                      child: Text('飲み物'),
                      value: '飲み物',
                    ),
                    DropdownMenuItem(
                      child: Text('健康飲料'),
                      value: '健康飲料',
                    ),
                    DropdownMenuItem(
                      child: Text('酒類'),
                      value: '酒類',
                    ),
                    DropdownMenuItem(
                      child: Text('お弁当・お惣菜'),
                      value: 'お弁当・お惣菜',
                    ),
                    DropdownMenuItem(
                      child: Text('おにぎり'),
                      value: 'おにぎり',
                    ),
                    DropdownMenuItem(
                      child: Text('パン'),
                      value: 'パン',
                    ),
                    DropdownMenuItem(
                      child: Text('スイーツ・アイス'),
                      value: 'スイーツ・アイス',
                    ),
                    DropdownMenuItem(
                      child: Text('ホットスナック'),
                      value: 'ホットスナック',
                    ),
                    DropdownMenuItem(
                      child: Text('日用品'),
                      value: '日用品',
                    ),
                    DropdownMenuItem(
                      child: Text('雑誌類'),
                      value: '雑誌類',
                    ),
                    DropdownMenuItem(
                      child: Text('その他'),
                      value: 'その他',
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
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
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
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        amount = value;
                      });
                    },
                  ),
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
                  onPressed: () async {

                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                        .collection('input') // コレクションID指定
                        .doc() // ドキュメントID自動生成
                        .set({
                      'date': date,
                      'category': isSelectedItem,
                      'name': name,
                      'value': amount
                    });

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