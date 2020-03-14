import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_up.dart';
import '../../providers/auth_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: w / 12, right: w / 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.lightBlue,
              AppColors.blueWithTransparency,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LogInBody(),
      ),
    );
  }
}

class LogInBody extends StatefulWidget {
  @override
  _LogInBodyState createState() => _LogInBodyState();
}

class _LogInBodyState extends State<LogInBody> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _savePassword = false;
  bool _isLoggingIn = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Log In',
            style: AppTextStyles.authScreenTitle,
          ),
          _emailTextField(email),
          _passwordTextField(pass),
          _saveUserInfo(),
          _loginButton(),
          _navToSignUp()
        ],
      ),
    );
  }

  Widget _emailTextField(TextEditingController email) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: email,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          hintText: 'Email',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordTextField(TextEditingController pass) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: TextField(
        controller: pass,
        obscureText: _hidePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: _hidePassword
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
          ),
          hintText: 'Password',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveUserInfo() {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            hoverColor: Colors.green,
            activeColor: Colors.white,
            checkColor: Colors.grey,
            value: _savePassword,
            onChanged: (val) {
              setState(() {
                _savePassword = val;
              });
            },
          ),
          Text(
            'Remember password',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: _isLoggingIn
          ? CircularProgressIndicator()
          : SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: AppColors.blue,
                onPressed: () async {
                  setState(() {
                    _isLoggingIn = true;
                  });

                  var msg = await Provider.of<Authenticator>(
                    context,
                    listen: false,
                  ).logIn(email.value.text, pass.value.text, _savePassword);
                  if (msg == null) {
                    msg = 'An error occured';
                  }
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(msg),
                    ),
                  );

                  setState(() {
                    _isLoggingIn = false;
                  });
                },
              ),
            ),
    );
  }

  Widget _navToSignUp() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'or',
            style: TextStyle(color: Colors.white),
          ),
          FlatButton(
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
          ),
        ],
      ),
    );
  }
}
