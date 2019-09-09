import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instant_verification_app/instant_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[50], Colors.blue[100]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildInfoCard('Access Token',
                  Provider.of<InstantAuth>(context).accessToken.token),
              buildInfoCard(
                'Last Refresh',
                Provider.of<InstantAuth>(context)
                    .accessToken
                    .lastRefresh,
              ),
              buildInfoCard('Account ID',
                  Provider.of<InstantAuth>(context).account.accountId),
              buildInfoCard(
                  'Phone Number',
                  Provider.of<InstantAuth>(context)
                      .account
                      .phoneNumber
                      .toString()),
              buildInfoCard(
                  'Email', Provider.of<InstantAuth>(context).account.email),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Sign Out'),
                    textColor: Colors.white70,
                    color: Colors.red,
                    onPressed: Provider.of<InstantAuth>(context).logOut,
                  ),
                  RaisedButton(
                    child: Text('Update'),
                    textColor: Colors.white70,
                    color: Colors.green,
                    onPressed:
                        Provider.of<InstantAuth>(context).updateAuthState,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, dynamic info) {
    if (info == null)
      return Container();
    else
      return Card(
        child: Container(
          height: 120,
          width: 400,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                title + ':',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                info.toString(),
                style: TextStyle(
                  fontSize: info.toString().length > 23 ? 13 : 20,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
