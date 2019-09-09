import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_account_kit/flutter_account_kit.dart';
import 'package:instant_verification_app/home_page.dart';
import 'package:instant_verification_app/sign_in_page.dart';


class InstantAuthApp extends StatefulWidget {
  const InstantAuthApp({Key key, this.home}) : super(key: key);

  final Widget home;
  @override
  _InstantAuthAppState createState() => _InstantAuthAppState();
}

class _InstantAuthAppState extends State<InstantAuthApp> {
  InstantAuth instantAuth;

  @override
  void initState() {
    super.initState();
    instantAuth = InstantAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instant Auth',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: ChangeNotifierProvider<InstantAuth>.value(
        value: instantAuth,
        child: AnimatedSwitcher(
          duration: Duration(seconds: 5),
          child: Container(
            key: ValueKey<int>(instantAuth.state.hashCode),
            child: InstantAuhtPage(),
          ),
        ),
      ),
    );
  }
}

class InstantAuhtPage extends StatelessWidget {
  const InstantAuhtPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildHomePage(context),
    );
  }

  buildHomePage(BuildContext context) {
    switch (Provider.of<InstantAuth>(context).state) {
      case AuthState.Loading:
        return bulidProgressIndicatorPage();
      case AuthState.NotSignedIn:
        return SignInPage();
      case AuthState.SignedIn:
        return HomePage();
      case AuthState.HasError:
        return bulidErrorWidgetPage(context);
      default:
    }
  }

  bulidProgressIndicatorPage() {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 148.0,
          width: 148.0,
          child: CircularProgressIndicator(
            value: null,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    );
  }

  bulidErrorWidgetPage(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.blue,
              size: 148,
            ),
            SizedBox(height: 30),
            Text(
              Provider.of<InstantAuth>(context).error.toString(),
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

enum AuthType { Email, Phone }
enum AuthState { NotSignedIn, SignedIn, Loading, HasError }

class InstantAuth with ChangeNotifier {
  var _accountKit = FlutterAccountKit();
  Account _account;
  AccessToken _accessToken;
  AuthState _state;
  Error _error;
  Account get account => _account;
  AccessToken get accessToken => _accessToken;
  AuthState get state => _state;
  Error get error => _error;

  InstantAuth() {
    _state = AuthState.Loading;
    _initAccountKit().then((v) {
      updateAuthState();
    });
  }

  _initAccountKit() async {
    print('AccountKit: Initialising...');
    //final theme = AccountKitTheme();
    final config = Config(
      readPhoneStateEnabled: true,
      facebookNotificationsEnabled: true,
      responseType: ResponseType.token,
      titleType: TitleType.appName,
      receiveSMS: true,
      //theme: Theme,
      initialAuthState: '99',
      initialPhoneNumber: PhoneNumber(countryCode: '966'),
    );
    try {
      await _accountKit.configure(config);
      print('Account Kit: Initialised ✓');
    } catch (e) {
      print('AccountKit: Error while initialising:${e.toString()}');
      _error = e;
      _state = AuthState.HasError;
    }
    notifyListeners();
  }

  _authNewAccount(AuthType type) async {
    LoginResult result;
    _state = AuthState.Loading;
    notifyListeners();

    try {
      result = (type == AuthType.Phone)
          ? await _accountKit.logInWithPhone()
          : await _accountKit.logInWithEmail();

      switch (result.status) {
        case LoginStatus.loggedIn:
          _state = AuthState.SignedIn;
          await updateAuthState();
          break;
        case LoginStatus.cancelledByUser:
          _state = AuthState.NotSignedIn;
          break;
        case LoginStatus.error:
          _state = AuthState.HasError;
          print(
              'AccountKit: Error while Login account: ${result.errorMessage} ');
          break;
      }
    } catch (e) {
      print('AccountKit: Error while Login account:${e.toString()}');

      _state = AuthState.HasError;
      _error = e;
    }
    notifyListeners();
  }

  updateAuthState() async {
    try {
      if (await _accountKit.isLoggedIn) {
        print('AccountKit: isLoggedIn: true');
        _account = await _accountKit.currentAccount;
        print('AccountKit: AccountId:${account.accountId} ');
        print('AccountKit: PhoneNumber:${account.phoneNumber} ');
        print('AccountKit: Email:${account.email} ');
        _accessToken = await _accountKit.currentAccessToken;
        print('AccountKit: AccessToken:${accessToken.token} ');
        _state = AuthState.SignedIn;
      } else {
        print('AccountKit: isLoggedIn: false');

        _state = AuthState.NotSignedIn;
      }
    } catch (e) {
      print('AccountKit: Error while updating account state:${e.toString()}');
      _state = AuthState.HasError;
      _error = e;
    }
    notifyListeners();
  }

  Future<void> signInWithPhone() async {
    return this._authNewAccount(AuthType.Phone);
  }

  Future<void> signInWithEmail() async {
    return this._authNewAccount(AuthType.Email);
  }

  logOut() async {
    _state = AuthState.Loading;
    notifyListeners();
    try {
      await _accountKit.logOut();
      _state = AuthState.NotSignedIn;
    } catch (e) {
      print('AccountKit: Error while Logging out:${e.toString()}');
      _state = AuthState.HasError;
      _error = e;
    }
    notifyListeners();
  }
}
