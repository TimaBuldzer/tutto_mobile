import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tutto/api_constants.dart';
import 'package:tutto/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'components/body.dart';
import 'components/login_input_field.dart';

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
            LoginInputField(
              controller: phoneController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Введите свой номер';
                } else if (value.length < 9) {
                  return 'Номер телефона должен состоять из 9 цифр';
                }
                return null;
              },
              maxLength: 12,
              prefix: '+',
              hintText: 'Номер телефона',
              readOnly: true,
            ),
            SizedBox(height: 30),
            LoginInputField(
              controller: codeController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Введите код полученный из смс';
                } else if (value.length < 5) {
                  return 'Код должен состоять из 5 цифр';
                }
                return null;
              },
              maxLength: 5,
              prefix: '',
              hintText: 'Код из сообщения',
              readOnly: false,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              margin: EdgeInsets.only(top: 15.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    signIn(phoneController.text, codeController.text);
                  }
                },
                color: Colors.black,
                child: Text(
                  "Войти",
                  style: TextStyle(
                      color: Colors.white,
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
