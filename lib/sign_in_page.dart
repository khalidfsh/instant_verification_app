import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'instant_auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: 150,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 3, color: Colors.blue.shade900),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Welcome To InstantAuthApp',
              style: TextStyle(fontSize: 22, color: Colors.black87),
            ),
            SizedBox(height: 50),
            buildSignInButton(
              icon: Icons.phone_android,
              text: 'Sign in with Phone',
              onPressed: Provider.of<InstantAuth>(context).signInWithPhone,
            ),
            SizedBox(height: 10),
            buildSignInButton(
              icon: Icons.mail,
              text: 'Sign in with Email ',
              onPressed: Provider.of<InstantAuth>(context).signInWithEmail,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '''**From AccountKit Doc** 'To be instantly verified, you should be using Android device and make sure you have: 
-  The Facebook app for Android version 99 or later installed device.
-  A Facebook account that includes the phone number or email they enter in Account Kit.
-  Be logged in to that account.'

**From AccountKit FAQ** To prevent spam calls, Account Kit limits the number of calls to a specific phone number within a period of time. If you're a developer testing your app, you can avoid this restriction by using your own phone number for testing and taking the following actions:

Make sure that you are listed as the administrator, developer, or tester for your app in the Roles section of the App Dashboard.
To test instant verification, you also need the following:

Make sure that the phone number you are using for testing is the verified number in your personal Facebook profile.''',
                style: TextStyle(color: Colors.black38, fontSize: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton({IconData icon, String text, Function onPressed}) {
    return OutlineButton(
      splashColor: Colors.blue,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      highlightElevation: 0,
      highlightedBorderColor: Colors.white,
      borderSide: BorderSide(color: Colors.blue.shade900),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 24,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade900,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
