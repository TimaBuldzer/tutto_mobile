import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutto/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:tutto/screens/login/login_screen_code.dart';

import 'components/body.dart';
import 'components/login_input_field.dart';

class LoginPhoneScreen extends StatefulWidget {
  @override
  _LoginPhoneScreenState createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  bool isLoading = false;
  final TextEditingController phoneController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  signIn(String phone) async {
    Map data = {'phone': phone};
    var jsonResponse = null;
    var response = await http.post(kLoginPhoneSend, body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => LoginCodeScreen(
                phone: phone,
              ),
            ),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Form form() {
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
              maxLength: 9,
              prefix: '+998 ',
              hintText: 'Номер телефона',
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
                    setState(() {
                      isLoading = true;
                    });
                    signIn('998${phoneController.text}');
                  }
                },
                child: Text(
                  "Отправить код",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                color: Colors.black,
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
        form: form,
        isLoading: isLoading,
      ),
    );
  }
}
