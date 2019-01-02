import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blueGrey,
          fontFamily: 'Inconsolata'),
      home: MyHomePage(title: 'RAXAR'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class NoteType {
  String name;
  List<Field> fields;

  NoteType(this.name, this.fields);
}



class Field {
  String _type;
  String _s;
  double _n;
  bool _b;

  Field.number(this._n){
   _type = 'num';
  }

  Field.string(this._s){
    _type = 'str';
  }

  Field.boolean(this._b){
    _type = 'bool';
  }

  @override
  String toString() {
    if (_type == 'num'){
      return _n.toString();
    } else if (_type == 'str'){
      return _s;
    } else if (_type == 'bool'){
      return _b.toString();
    } else {
      return 'Found a bad field';
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/types.dat');
  }

  Future<File> writeTypes(List<NoteType> types) async {
    final file = await _localFile;

    //Write the file
    return file.writeAsString(types.toString());
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'create new',
              ),
            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: _openNewItemDialog,
            )
          ],
        ),
      ),
    );
  }

  void _openNewItemDialog() {
    print("Pressed Plus");
    _newNoteDialog();
  }

  Future<void> _newNoteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('add a new note'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    decoration: new InputDecoration(hintText: 'title'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child:  DropdownButton(
                      items: null,
                      onChanged: null,
                      hint: Text('type'),
                  ),
                ),
                RaisedButton(
                  child: Text('create new type'),
                  onPressed: _openNewTypeDialog,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('create'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openNewTypeDialog() {}
}
