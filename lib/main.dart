import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/config.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:gap/gap.dart';

final configurations = Configurations();

Future<void> main() async {
  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: configurations.project,
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
                // StreamBuilder
                // 非同期処理の結果を元にWidgetを作れる
                child: StreamBuilder<QuerySnapshot>(
                  // 入力日時でソート
                  stream: FirebaseFirestore.instance
                      .collection('input')
                      .orderBy('date')
                      .snapshots(),
                  builder: (context, snapshot) {

                    Map<String, dynamic> map = {'date': Timestamp.now()};
                    DateTime now = map['date'].toDate();

                    // データが取得できた場合
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> documents = snapshot.data!.docs;
                      // 取得した入力情報を元にリスト表示
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index){
                          var doc = snapshot.data!.docs[index];
                          var data = doc.data() as Map;
                          if(data['name1'] != null && data['name2'] == null && data['name3'] == null && data['name4'] == null && data['name5'] == null){
                            return Card(
                              child: Column(
                                children: [
                                  Text(now.day.toString().toString()),
                                  Text(data['category1'].toString()),
                                  Text(data['name1'].toString()),
                                  Text(data['value1'].toString()),
                                ],
                              ),
                            );
                          }else if(data['name1'] != null && data['name2'] != null && data['name3'] == null && data['name4'] == null && data['name5'] == null){
                            return Card(
                              child: Column(
                                children: [
                                  Text(now.day.toString().toString()),
                                  Text(data['category1'].toString()),
                                  Text(data['name1'].toString()),
                                  Text(data['value1'].toString()),
                                  Text(data['category2'].toString()),
                                  Text(data['name2'].toString()),
                                  Text(data['value2'].toString()),
                                ],
                              ),
                            );
                          }else if(data['name1'] != null && data['name2'] != null && data['name3'] != null && data['name4'] == null && data['name5'] == null){
                            return Card(
                              child: Column(
                                children: [
                                  Text(now.day.toString().toString()),
                                  Text(data['category1'].toString()),
                                  Text(data['name1'].toString()),
                                  Text(data['value1'].toString()),
                                  Text(data['category2'].toString()),
                                  Text(data['name2'].toString()),
                                  Text(data['value2'].toString()),
                                  Text(data['category3'].toString()),
                                  Text(data['name3'].toString()),
                                  Text(data['value3'].toString()),
                                ],
                              ),
                            );
                          }else if(data['name1'] != null && data['name2'] != null && data['name3'] != null && data['name4'] != null && data['name5'] == null){
                            return Card(
                              child: Column(
                                children: [
                                  Text(now.day.toString().toString()),
                                  Text(data['category1'].toString()),
                                  Text(data['name1'].toString()),
                                  Text(data['value1'].toString()),
                                  Text(data['category2'].toString()),
                                  Text(data['name2'].toString()),
                                  Text(data['value2'].toString()),
                                  Text(data['category3'].toString()),
                                  Text(data['name3'].toString()),
                                  Text(data['value3'].toString()),
                                  Text(data['category4'].toString()),
                                  Text(data['name4'].toString()),
                                  Text(data['value4'].toString()),
                                ],
                              ),
                            );
                          }else{
                            return Card(
                              child: Column(
                                children: [
                                  Text(now.day.toString().toString()),
                                  Text(data['category1'].toString()),
                                  Text(data['name1'].toString()),
                                  Text(data['value1'].toString()),
                                  Text(data['category2'].toString()),
                                  Text(data['name2'].toString()),
                                  Text(data['value2'].toString()),
                                  Text(data['category3'].toString()),
                                  Text(data['name3'].toString()),
                                  Text(data['value3'].toString()),
                                  Text(data['category4'].toString()),
                                  Text(data['name4'].toString()),
                                  Text(data['value4'].toString()),
                                  Text(data['category5'].toString()),
                                  Text(data['name5'].toString()),
                                  Text(data['value5'].toString()),
                                ],
                              ),
                            );
                          }
                        }
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
  DateTime now = DateTime.now();

  String? isSelectedItem1 = 'お菓子';
  String? isSelectedItem2 = 'お菓子';
  String? isSelectedItem3 = 'お菓子';
  String? isSelectedItem4 = 'お菓子';
  String? isSelectedItem5 = 'お菓子';

  String name1 = '';
  String name2 = '';
  String name3 = '';
  String name4 = '';
  String name5 = '';

  String amount1 = '';
  String amount2 = '';
  String amount3 = '';
  String amount4 = '';
  String amount5 = '';

  List<String> isselectedList = [];
  List<String> nameList = [];
  List<String> amountList = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('入力画面',style: TextStyle(fontSize: 20)),
      ),

      body: ListView(
        children:<Widget> [
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
                  child: ListTile(
                    title: Text(now.day.toString()),
                  ),
                ),
                Text('日'),
              ],
            ),
          ),
          const Gap(30),
          //①
          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: ListTile(
                    title: Text('項目①：'),
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
                      isSelectedItem1 = value;
                    });
                  },
                  value: isSelectedItem1,
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
                    title: Text('商品名①：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        name1 = value;
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
                    title: Text('支出①：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        amount1 = value;
                      });
                    },
                  ),
                ),
                Text('円'),
              ],
            ),
          ),
          const Gap(30),
          //②
          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: ListTile(
                    title: Text('項目②：'),
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
                      isSelectedItem2 = value;
                    });
                  },
                  value: isSelectedItem2,
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
                    title: Text('商品名②：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        name2 = value;
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
                    title: Text('支出②：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        amount2 = value;
                      });
                    },
                  ),
                ),
                Text('円'),
              ],
            ),
          ),
          const Gap(30),
          //③
          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: ListTile(
                    title: Text('項目③：'),
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
                      isSelectedItem3 = value;
                    });
                  },
                  value: isSelectedItem3,
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
                    title: Text('商品名③：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        name3 = value;
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
                    title: Text('支出③：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        amount3 = value;
                      });
                    },
                  ),
                ),
                Text('円'),
              ],
            ),
          ),
          const Gap(30),
          //④
          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: ListTile(
                    title: Text('項目④：'),
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
                      isSelectedItem4 = value;
                    });
                  },
                  value: isSelectedItem4,
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
                    title: Text('商品名④：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        name4 = value;
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
                    title: Text('支出④：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        amount4 = value;
                      });
                    },
                  ),
                ),
                Text('円'),
              ],
            ),
          ),
          const Gap(30),
          //⑤
          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: ListTile(
                    title: Text('項目⑤：'),
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
                      isSelectedItem5 = value;
                    });
                  },
                  value: isSelectedItem5,
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
                    title: Text('商品名⑤：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        name5 = value;
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
                    title: Text('支出⑤：'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        amount5 = value;
                      });
                    },
                  ),
                ),
                Text('円'),
              ],
            ),
          ),
          const Gap(20),
        ],
      ),


      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'ocr',
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return OCRPage();
                }),
              );
            },
            child: const Icon(Icons.add_a_photo_outlined),
          ),

          const Gap(10),

          FloatingActionButton.extended(
            heroTag: 'ok',
            label: Text('入力'),
            onPressed: () async {
              if(name1.isNotEmpty && name2.isEmpty && name3.isEmpty && name4.isEmpty && name5.isEmpty){
                await FirebaseFirestore.instance
                    .collection('input') // コレクションID指定
                    .doc() // ドキュメントID自動生成
                    .set({
                  'date': now,
                  'category1': isSelectedItem1,
                  'name1': name1,
                  'value1': amount1,
                });
                Navigator.of(context).pop(); // "pop"で前の画面に戻る
              } else if (name1.isNotEmpty && name2.isNotEmpty && name3.isEmpty && name4.isEmpty && name5.isEmpty){
                await FirebaseFirestore.instance
                    .collection('input') // コレクションID指定
                    .doc() // ドキュメントID自動生成
                    .set({
                  'date': now,
                  'category1': isSelectedItem1,
                  'name1': name1,
                  'value1': amount1,

                  'category2': isSelectedItem2,
                  'name2': name2,
                  'value2': amount2
                });
                Navigator.of(context).pop(); // "pop"で前の画面に戻る
              } else if (name1.isNotEmpty && name2.isNotEmpty && name3.isNotEmpty && name4.isEmpty && name5.isEmpty){
                await FirebaseFirestore.instance
                    .collection('input') // コレクションID指定
                    .doc() // ドキュメントID自動生成
                    .set({
                  'date': now,
                  'category1': isSelectedItem1,
                  'name1': name1,
                  'value1': amount1,

                  'category2': isSelectedItem2,
                  'name2': name2,
                  'value2': amount2,

                  'category3': isSelectedItem3,
                  'name3': name3,
                  'value3': amount3
                });
                Navigator.of(context).pop(); // "pop"で前の画面に戻る
              } else if (name1.isNotEmpty && name2.isNotEmpty && name3.isNotEmpty && name4.isNotEmpty && name5.isEmpty){
                await FirebaseFirestore.instance
                    .collection('input') // コレクションID指定
                    .doc() // ドキュメントID自動生成
                    .set({
                  'date': now,
                  'category1': isSelectedItem1,
                  'name1': name1,
                  'value1': amount1,

                  'category2': isSelectedItem2,
                  'name2': name2,
                  'value2': amount2,

                  'category3': isSelectedItem3,
                  'name3': name3,
                  'value3': amount3,

                  'category4': isSelectedItem4,
                  'name4': name4,
                  'value4': amount4
                });
                Navigator.of(context).pop(); // "pop"で前の画面に戻る
              } else if (name1.isNotEmpty && name2.isNotEmpty && name3.isNotEmpty && name4.isNotEmpty && name5.isNotEmpty){
                await FirebaseFirestore.instance
                    .collection('input') // コレクションID指定
                    .doc() // ドキュメントID自動生成
                    .set({
                  'date': now,
                  'category1': isSelectedItem1,
                  'name1': name1,
                  'value1': amount1,

                  'category2': isSelectedItem2,
                  'name2': name2,
                  'value2': amount2,

                  'category3': isSelectedItem3,
                  'name3': name3,
                  'value3': amount3,

                  'category4': isSelectedItem4,
                  'name4': name4,
                  'value4': amount4,

                  'category5': isSelectedItem5,
                  'name5': name5,
                  'value5': amount5,
                });
                Navigator.of(context).pop(); // "pop"で前の画面に戻る
              } else {
                return null;
              }

            },
          ),
        ],
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
        title: Text('グラフ表示画面',style: TextStyle(fontSize: 20)),
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


// OCR用Widget
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}
// アプリ画面を描画する前に、Firebaseの初期化処理を実行
class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // MaterialAppの前なので、 textDirection: TextDirection.ltr
          // がないと、文字の方向がわからないというエラーになる
          return Center(
              child: Text(
                '読み込みエラー',
                textDirection: TextDirection.ltr,
              ));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        // 上記と同様。 textDirection: TextDirection.ltr が必要
        return Center(
            child: Text(
              '読み込み中...',
              textDirection: TextDirection.ltr,
            ));
      },
    );
  }
}
//OCR基本画面
class OCRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'レシート読み取りOCR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'レシート読み取りOCR'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // null safety対応のため、Keyに?をつけ、titleは初期値""を設定
  MyHomePage({Key? key, this.title = ""}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  // null safety対応のため、?でnull許容
  File? _image;
  final _picker = ImagePicker();
  // null safety対応のため、?でnull許容
  String? _result;
  @override
  void initState() {
    super.initState();
    _signIn();
  }
  // 匿名でのFirebaseログイン処理
  void _signIn() async {
    await FirebaseAuth.instance.signInAnonymously();
  }
  Future _getImage(FileMode fileMode) async {
    // null safety対応のため、lateで宣言
    late final _pickedFile;
    // image_pickerの機能で、カメラからとギャラリーからの2通りの画像取得（パスの取得）を設定
    if (fileMode == FileMode.CAMERA) {
      _pickedFile = await _picker.pickImage(source: ImageSource.camera);
    } else {
      _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      if (_pickedFile != null) {
        _image = File(_pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('レシート読み取りOCR'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          // 写真のサイズによって画面はみ出しエラーが生じるのを防ぐため、
          // Columnの上にもSingleChildScrollViewをつける
          child: SingleChildScrollView(
            child: Column(children: [
              // 画像を取得できたら表示
              // null safety対応のため_image!とする（_imageはnullにならない）
              if (_image != null) Image.file(_image!, height: 400),
              // 画像を取得できたら解析ボタンを表示
              if (_image != null) _analysisButton(),
              Container(
                  height: 240,
                  // OCR（テキスト検索）の結果をスクロール表示できるようにするため
                  // 結果表示部分をSingleChildScrollViewでラップ
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text((() {
                        // OCR（テキスト認識）の結果（_result）を取得したら表示
                        if (_result != null) {
                          // null safety対応のため_result!とする（_resultはnullにならない）
                          return _result!;
                        } else if (_image != null) {
                          return 'ボタンを押すと解析が始まります';
                        } else {
                          return 'テキスト認識したいコンビニレシートを撮影または読込んでください。';
                        }
                      }()))
                  )
              ),

              if (_image != null) _inputButton(),
              Container(
                alignment: Alignment.bottomCenter,
              ),

            ]),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // カメラ起動ボタン
          FloatingActionButton(
            heroTag: "hero1",
            onPressed: () => _getImage(FileMode.CAMERA),
            tooltip: 'Pick Image from camera',
            child: Icon(Icons.camera_alt),
          ),
          const Gap(10),
          // ギャラリー（ファイル）検索起動ボタン
          FloatingActionButton(
            heroTag: "hero2",
            onPressed: () => _getImage(FileMode.GALLERY),
            tooltip: 'Pick Image from gallery',
            child: Icon(Icons.folder_open),
          ),
        ],
      ),
    );
  }
  // OCR（テキスト認識）開始処理
  Widget _analysisButton() {
    return ElevatedButton(
      child: Text('解析'),
      onPressed: () async {
        // null safety対応のため_image!とする（_imageはnullにならない）
        List<int> _imageBytes = _image!.readAsBytesSync();
        String _base64Image = base64Encode(_imageBytes);
        // Firebase上にデプロイしたFunctionを呼び出す処理
        HttpsCallable _callable =
        FirebaseFunctions.instance.httpsCallable('annotateImage');
        final params = {
          "image": {"content": "$_base64Image"},
          "features": [{"type": "TEXT_DETECTION"}],
          "imageContext": {
            "languageHints": ["ja"]
          }
        };
        final _text = await _callable(params).then((v) {
          return v.data[0]["fullTextAnnotation"]["text"];
        }).catchError((e) {
          print('ERROR: $e');
          return '読み取りエラーです';
        });

        String receipt_name;
        String receipt_value;

        print(_text);
        print('-------------------------');
        print(_text.indexOf('¥'));
        print(_text.indexOf(')'));
        print('-------------------------');
        // セブン、ローソン、ファミマ　レシート分析
        if (_text.contains('セブン-イレブン') == true){
          receipt_name = _text.substring(_text!.indexOf('領収書') + 3,_text!.indexOf('小 計 (税抜 8%)'));
          receipt_value = _text.substring(_text.indexOf('*'),_text.indexOf('¥'));
          setState(() {
            _result = receipt_name + receipt_value;
          });
        } else if (_text.contains('LAWSON') == true){
          receipt_name = _text.substring(_text!.indexOf('【領収証】') + 5,_text!.indexOf('合'));
          receipt_value = _text.substring(_text.indexOf('軽') - 4 ,_text.indexOf('¥'));
          setState(() {
            _result = receipt_name + receipt_value;
          });
        } else if (_text.contains('FamilyMart') == true){
          receipt_name = _text.substring(_text!.indexOf('領収') + 3,_text!.indexOf('合'));
          receipt_value = _text.substring(_text.indexOf('¥'),_text.indexOf(')',110) - 9);
          setState(() {
            _result = receipt_name + receipt_value;
          });
        } else {
          setState(() {
            _result = '読み取りエラーです。';
          });
        }
      },
    );
  }

  Widget _inputButton() {
    return ElevatedButton(
        child: Text('入力'),
        onPressed: (){
        }
    );
  }

}
// カメラ経由かギャラリー（ファイル）経由かを示すフラグ
enum FileMode{
  CAMERA,
  GALLERY,
}
