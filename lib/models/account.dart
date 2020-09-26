import 'dart:convert';

class Account {
  Account({this.id, this.title, this.value, this.color});

  int id;
  String title;
  String value;
  String color;

  factory Account.fromMap(Map<String, dynamic> json) => new Account(
      id: json["id"],
      title: json["title"],
      value: json["value"],
      color: json["color"]);

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "value": value, "color": color};
}

Account accountFromJson(String str) {
  final jsonData = json.decode(str);
  return Account.fromMap(jsonData);
}

String accountToJson(Account data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
