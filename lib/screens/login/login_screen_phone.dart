import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutto/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:tutto/screens/login/components/raised_gradient_button.dart';
import 'package:tutto/screens/login/components/tutto_gradient.dart';
import 'package:tutto/screens/login/login_screen_code.dart';

import 'components/body.dart';

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
        print(jsonResponse);
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
      print(response.body);
    }
  }

  Form form() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              validator: (value) {
                if (value.isEmpty) {
                  return 'Введите свой номер';
                } else if (value.length < 9) {
                  return 'Номер телефона должен состоять из 9 цифр';
                }
                return null;
              },
              maxLength: 9,
              maxLengthEnforced: true,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefix: Text('+998 '),
                icon: Icon(Icons.phone, color: Colors.black),
                hintText: "Номер телефона",
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
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    signIn('998${phoneController.text}');
                  }
                },
                child: Text(
                  "Отправить код с сообщением на этот номер",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 16),
                ),
                gradient: buildLinearGradient(),
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
