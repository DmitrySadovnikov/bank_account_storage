import 'package:flutter/material.dart';

import 'package:bank_account_storage/screens/account/edit_screen.dart';
import 'package:bank_account_storage/models/account.dart';
import 'package:bank_account_storage/database.dart';

class AccountListScreen extends StatefulWidget {
  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Bank Account Storage"),
          automaticallyImplyLeading: false),
      body: FutureBuilder<List<Account>>(
        future: DBProvider.db.getAccountList(),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Account account = snapshot.data[index];
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountEditScreen(
                                title: "Edit Account", account: account)))
                  },
                  child: Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      DBProvider.db.deleteAccount(account.id);
                    },
                    child: Card(
                        color:
                            Color(int.parse("FF" + account.color, radix: 16)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(64.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(account.title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 36,
                                        color: Colors.white)),
                                Text("*" +
                                    account.value
                                        .substring(account.value.length - 4))
                              ],
                            ))),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AccountEditScreen(
                      title: "Add Account", account: new Account())));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
