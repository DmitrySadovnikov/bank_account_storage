import 'package:flutter/material.dart';

import 'package:bank_account_storage/routes.dart';
import 'package:bank_account_storage/screens/account/list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Account Storage',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: AccountListScreen(),
      routes: {
        Routes.accountList: (context) => AccountListScreen(),
      },
    );
  }
}
