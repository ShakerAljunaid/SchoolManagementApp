import 'package:ajialalsafaschool/views/login/Screens/Login/login_screen.dart';
import 'package:ajialalsafaschool/views/login/Screens/Signup/signup_screen.dart';
import 'package:ajialalsafaschool/views/login/components/rounded_button.dart';

import 'package:ajialalsafaschool/views/login/constants.dart';
import 'package:flutter/material.dart';

import 'background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "   مرحباً بكم في",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            Image.asset(
              "assets/images/schoollogo.gif",
              fit: BoxFit.contain,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "تسجيل الدخول",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "إنشاء حساب ",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
