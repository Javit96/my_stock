import 'package:flutter/material.dart';
import 'package:my_stock/UI/LoginPage/SingUp.dart';
import 'package:my_stock/bloc/blocks/user_bloc_provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback login;
  final bool newUser;

  const LoginPage({Key key, this.login, this.newUser}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordcheckController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700], Colors.blue],
          ),
        ),
        child: widget.newUser ? getSignupPage() : getSigninPage(),
      ),
    );
  }

  Widget getSigninPage() {
    TextEditingController usernameText = new TextEditingController();
    TextEditingController passwordText = new TextEditingController();

    return Container(
      margin: EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Welcome!"),
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextFormField(
                    controller: usernameText,
                    autofocus: false,
                    style: TextStyle(fontSize: 22.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Username',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextFormField(
                    controller: passwordText,
                    autofocus: false,
                    obscureText: true,
                    style: TextStyle(fontSize: 22.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    "Sign in",
                  ),
                  onPressed: () {
                    if (usernameText.text != null ||
                        passwordText.text != null) {
                      userBloc
                          .singinUser(usernameText.text, passwordText.text, "")
                          .then((_) {
                        widget.login();
                      });
                    }
                  },
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  "Don't you even have an account yet?!",
                  textAlign: TextAlign.center,
                ),
                FlatButton(
                  child: Text("create one"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getSignupPage() {
    return Material(
      child: Container(
        height: 250,
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(hintText: "Username"),
            ),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(hintText: "First name"),
            ),
            TextField(
              controller: lastnameController,
              decoration: InputDecoration(hintText: "Last name"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(hintText: "Phone"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: "Password"),
              obscureText: true,
            ),
            TextField(
              controller: passwordcheckController,
              decoration: InputDecoration(hintText: "Confirm Password"),
              obscureText: true,
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.symmetric()),
                FlatButton(
                  color: Colors.red,
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => getSigninPage()),
                    );
                  },
                ),
                FlatButton(
                  color: Colors.green,
                  child: Text("Send"),
                  onPressed: () {
                    if (usernameController.text != null ||
                        passwordController.text != null ||
                        passwordController == passwordcheckController ||
                        emailController.text != null ||
                        firstNameController.text != null ||
                        lastnameController.text != null) {
                      userBloc
                          .registerUser(
                              usernameController.text,
                              firstNameController.text ?? "",
                              lastnameController.text ?? "",
                              emailController.text,
                              passwordController.text,
                              phoneController.text)
                          .then((_) {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => getSigninPage()),
                        );
                      });
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
