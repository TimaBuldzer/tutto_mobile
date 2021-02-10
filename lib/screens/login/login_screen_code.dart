import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutto/api_constants.dart';
import 'package:tutto/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tutto/screens/login/components/raised_gradient_button.dart';
import 'package:tutto/screens/login/components/tutto_gradient.dart';

import 'components/body.dart';

class LoginCodeScreen extends StatefulWidget {
  final String phone;

  const LoginCodeScreen({Key key, this.phone}) : super(key: key);

  @override
  _LoginCodeScreenState createState() => _LoginCodeScreenState();
}

class _LoginCodeScreenState extends State<LoginCodeScreen> {
  bool isLoading = false;
  TextEditingController phoneController;
  final TextEditingController codeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.phone);
  }

  final _formKey = GlobalKey<FormState>();

  signIn(String phone, String code) async {
    Map data = {'phone': phone, 'code': code};
    var jsonResponse = null;
    var response = await http.post(kLoginCodeSend, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          isLoading = false;
        });
        print(jsonResponse);
        String token = 'Token ' + jsonResponse['token'];
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'token', value: token);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
  }

  Form textSection() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              readOnly: true,
              controller: phoneController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.phone, color: Colors.black),
                prefix: Text('+'),
                hintText: "Номер телефона",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: codeController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              validator: (value) {
                if (value.isEmpty) {
                  return 'Введите код полученный из смс';
                } else if (value.length < 5) {
                  return 'Код должен состоять из 5 цифр';
                }
                return null;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              maxLength: 5,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                icon: Icon(Icons.perm_phone_msg, color: Colors.black),
                hintText: 'Код из сообщения',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              margin: EdgeInsets.only(top: 15.0),
              child: RaisedGradientButton(
                onPressed: () {
                  print(_formKey.currentState.validate());
                  if (_formKey.currentState.validate()) {
                    signIn(phoneController.text, codeController.text);
                  }
                },
                gradient: buildLinearGradient(),
                child: Text(
                  "Войти",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(
      form: textSection,
      isLoading: isLoading,
    ));
  }
}
