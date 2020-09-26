import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:bank_account_storage/database.dart';
import 'package:bank_account_storage/models/account.dart';
import 'package:bank_account_storage/routes.dart';

class AccountEditScreen extends StatefulWidget {
  AccountEditScreen({Key key, this.title, this.account}) : super(key: key);

  final String title;
  final Account account;

  @override
  _AccountEditScreenState createState() =>
      _AccountEditScreenState(account: account);
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  _AccountEditScreenState({Key key, this.account}) : super();

  final _formKey = GlobalKey<FormState>();
  Account account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: account.title,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                  ),
                  validator: (v) {
                    if (v.isEmpty) {
                      return 'Please enter some text';
                    } else if (v.length > 10) {
                      return 'Length must be less or equal to 10';
                    }
                    return null;
                  },
                  onSaved: (String v) {
                    account.title = v;
                  },
                ),
                TextFormField(
                  initialValue: account.value,
                  decoration: const InputDecoration(
                    labelText: 'Value *',
                  ),
                  validator: (v) {
                    if (v.isEmpty) {
                      return 'Please enter some text';
                    } else if (v.length < 4) {
                      return 'Length must be greater than 4';
                    }
                    return null;
                  },
                  onSaved: (String v) {
                    account.value = v;
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  elevation: 3.0,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Select a color'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: getColor(),
                              onColorChanged: changeColor,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Select a color'),
                  color: getColor(),
                  textColor: useWhiteForeground(getColor())
                      ? const Color(0xffffffff)
                      : const Color(0xff000000),
                )
              ],
            ),
          ))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          _submitForm();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Color getColor() {
    if (account.color == null) {
      const List<Color> list = [
        Colors.red,
        Colors.pink,
        Colors.purple,
        Colors.deepPurple,
        Colors.indigo,
        Colors.blue,
        Colors.lightBlue,
        Colors.cyan,
        Colors.teal,
        Colors.green,
        Colors.lightGreen,
        Colors.lime,
        Colors.yellow,
        Colors.amber,
        Colors.orange,
        Colors.deepOrange,
        Colors.brown,
        Colors.grey,
        Colors.blueGrey,
        Colors.black,
      ];
      return list[Random().nextInt(list.length)];
    } else {
      return Color(int.parse("FF" + account.color, radix: 16));
    }
  }

  void changeColor(Color color) =>
      setState(() => account.color = color.value.toRadixString(16));

  Future<void> _submitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var result;
      if (account.id != null) {
        result = await DBProvider.db.updateAccount(account);
      } else {
        result = await DBProvider.db.newAccount(account);
      }
      if (result != null) {
        Navigator.pushReplacementNamed(context, Routes.accountList);
      }
    }
  }
}
