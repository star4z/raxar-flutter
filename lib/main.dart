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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'create new',
              ),
            ),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(context: context,
                    builder: (BuildContext context) => new MyDialog());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog();

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String _selectedId;

  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text('add new note'),

        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: new InputDecoration(hintText: 'give it a title'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: new DropdownButton<String>(
              hint: const Text('pick a type'),
              value: _selectedId,
              onChanged: (String value) {
                setState(() {
                  _selectedId = value;
                });
              },
              items: <String>['simple note', 'titled note'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: RaisedButton(
              child: Text('create new type'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TypeEditPage()),
                );
              },
            ),
          ),

          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: new Text('create'),
          ),
        ],
    );
  }
}

class TypeEditPage extends StatefulWidget{
  @override
  _TypeEditPageState createState() => _TypeEditPageState();
}

class _TypeEditPageState extends State<TypeEditPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('type creation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

        ],
      ),
    );
  }

}
