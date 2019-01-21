import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static List<int> usedIds = [];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'raxar',
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
      home: MyHomePage(
        title: 'raxar',
        usedIds: usedIds,
      ),
    );
  }
}

class IdGenerator {
  static final _idGenerator = new IdGenerator._internal();
  static const int _max_int = 2147483647;
  static var rng = new Random();

  factory IdGenerator() {
    return _idGenerator;
  }

  IdGenerator._internal();

  /*TODO: Should check if the random value is not in the pool of already used
  * values, and if so, finds a new value.*/
  int generateId() {
    return rng.nextInt(_max_int);
  }
}

class NoteType {
  int _id;
  String name;
  List<NoteField> fields;

  get id => _id;

  NoteType(this.name, {this.fields}) {
    _id = IdGenerator().generateId();
  }
}

class NoteField {
  int _id, _parentId;
  TextInputType type;
  String value;

  get id => _id;

  get parentId => _parentId;

  NoteField(this.type, this.value, this._parentId) {
    _id = IdGenerator().generateId();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.usedIds}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final List<int> usedIds;

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
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AddNoteDialog());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog();

  @override
  State createState() => new AddNoteDialogState();
}

class AddNoteDialogState extends State<AddNoteDialog> {
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

class TypeEditPage extends StatefulWidget {
  @override
  _TypeEditPageState createState() => _TypeEditPageState();
}

class _TypeEditPageState extends State<TypeEditPage> {
  bool isTypeDefaultType = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('type creation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('use as default note style?'),
                ),
                Checkbox(
                  value: isTypeDefaultType,
                  onChanged: (bool val) {
                    setState(() {
                      isTypeDefaultType = val;
                    });
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(hintText: 'give it a name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FlatButton(
                onPressed: () {
                  _navigateAndReceiveFieldType(context);
                },
                child: Text('+   add a field')),
          )
        ],
      ),
    );
  }

  _navigateAndReceiveFieldType(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) => AddFieldDialog());

    print(result);
  }
}

class AddFieldDialog extends StatefulWidget {
  @override
  _AddFieldDialogState createState() => _AddFieldDialogState();
}

class _AddFieldDialogState extends State<AddFieldDialog> {
  TextInputType _textInputType;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('this is where you choose the details for new fields'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16),
          child: DropdownButton<TextInputType>(
            hint: Text('choose a field type'),
            value: _textInputType,
            //TODO: add option to add another note type as a kind of field
            items: TextInputType.values.map((TextInputType value) {

              //converts value to JSON to get name field, then clips off
              //'TextInputField.' from each entry.
              var name = value.toJson()['name'].substring(14);

              return new DropdownMenuItem<TextInputType>(
                value: value,
                child: Text(name),
              );
            }).toList(),
            onChanged: (TextInputType value) {
              setState(() {
                _textInputType = value;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: FlatButton(
              onPressed: () {
                Navigator.pop(context, _textInputType);
              },
              child: Text('make it happen')),
        )
      ],
    );
  }
}
