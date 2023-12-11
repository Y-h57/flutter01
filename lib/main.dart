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
                // FutureBuilder
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
                      return ListView(
                        children: documents.map((document) {
                          return GestureDetector(
                            child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Text(now.day.toString()),
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
  DateTime now = DateTime.now();

  String? isSelectedItem = 'お菓子';
  String name = '';
  String amount = '';

  int n = 1;
  List<String> isselectedList = [];
  List<String> nameList = [];
  List<String> amountList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('入力画面',style: TextStyle(fontSize: 20)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
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

            ListView.builder(
              shrinkWrap: true, //Column中にListView.builderするのに必要
              physics: NeverScrollableScrollPhysics(), //Column中にListView.builderするのに必要
              itemCount: n,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  children: <Widget>[
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

                  ],
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: Colors.blue,
            onPressed: () {
              n++;
              setState(() {
              });
            },
            child: Icon(Icons.add),
          ),

          const Gap(10),

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
              // 投稿メッセージ用ドキュメント作成
              await FirebaseFirestore.instance
                  .collection('input') // コレクションID指定
                  .doc() // ドキュメントID自動生成
                  .set({
                'date': now,
                'category': isSelectedItem,
                'name': name,
                'value': amount
              });
              // "pop"で前の画面に戻る
              Navigator.of(context).pop();
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
                      }())))),

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

