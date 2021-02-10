import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tutto/screens/login/login_screen_phone.dart';

class HomeScreen extends StatelessWidget {
  checkLoginStatus(BuildContext context) async {
    final storage = new FlutterSecureStorage();
    if (await storage.read(key: 'token') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => LoginPhoneScreen()),
          (Route<dynamic> route) => false);
    }
  }
  @override
  Widget build(BuildContext context) {
    checkLoginStatus(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
    );
  }
}
