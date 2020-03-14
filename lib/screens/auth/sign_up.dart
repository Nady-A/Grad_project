import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'log_in.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../providers/auth_provider.dart';

class SignUp extends StatelessWidget {
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
        child: SignUpBody(),
      ),
    );
  }
}

class SignUpBody extends StatefulWidget {
  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  TextEditingController username = TextEditingController();
  bool _hidePassword = true;
  bool _isSigningUp = false;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    confirmPass.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sign Up',
              style: AppTextStyles.authScreenTitle,
            ),
            _usernameTextfield(username),
            _emailTextField(email),
            _passwordTextField(pass),
            _confirmPasswordTextField(confirmPass),
            _signUpButton(),
            _navToLogIn(),
          ],
        ),
      ),
    );
  }

  Widget _usernameTextfield(TextEditingController username) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: TextField(
        controller: username,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: 'Username',
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

  Widget _confirmPasswordTextField(TextEditingController pass) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: TextField(
        controller: pass,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          hintText: 'Confirm Password',
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

  Widget _signUpButton() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: _isSigningUp
          ? CircularProgressIndicator()
          : SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: AppColors.blue,
                onPressed: () async {
                  setState(() {
                    _isSigningUp = true;
                  });
                  var msg = await Provider.of<Authenticator>(
                    context,
                    listen: false,
                  ).signUp(
                    email.value.text,
                    pass.value.text,
                    confirmPass.value.text,
                    username.value.text,
                  );
                  print(msg.runtimeType);
                  if (msg == null) {
                    msg = 'An error occured';
                  }
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(msg),
                    ),
                  );

                  setState(() {
                    _isSigningUp = false;
                  });
                },
              ),
            ),
    );
  }

  Widget _navToLogIn() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account?',
            style: TextStyle(color: Colors.white),
          ),
          FlatButton(
            child: Text(
              'Log In',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LogIn()));
            },
          ),
        ],
      ),
    );
  }
}
