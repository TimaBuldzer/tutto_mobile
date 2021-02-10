import 'package:flutter/material.dart';

import 'tutto_gradient.dart';

class Body extends StatelessWidget {
  final Function form;
  final bool isLoading;

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
      ),
    );
  }

  const Body({Key key, this.form, this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: buildLinearGradient(),
      ),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                headerSection(),
                form(),
              ],
            ),
    );
  }


}
