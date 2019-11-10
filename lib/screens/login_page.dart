import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mechaniks_mechanic/data/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/country_code_selector.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext context) {
          return SignInSection();
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SignInSection extends StatefulWidget {
  SignInSection();
  @override
  State<StatefulWidget> createState() => SignInSectionState();
}

class SignInSectionState extends State<SignInSection> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20),
        child: _toggle(userRepository),
      ),
      body: buildLogin(userRepository.status),
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _toggle(UserRepository userRepository) {
    Status status = userRepository.status;
    if (status == Status.Authenticating) {
      return Container(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      child: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            userRepository.signIn(
                emailController.text, passwordController.text);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Icon(Icons.navigate_next),
        ),
      ),
    );
  }

  Widget buildLogin(Status status) {
    String message = Provider.of<UserRepository>(context).message;
    return status == Status.Authenticating
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 20),
                      child: Container(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 20, 20, 30),
                  child: Text(
                    'Enter your email and password to continue. ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: buildInput(status),
                ),
              ],
            ),
          );
  }

  Widget buildInput(Status status) {
    return Theme(
      data: ThemeData(primaryColor: Colors.blue),
      child: Column(
        children: <Widget>[
          SizedBox(height: 5),
          StringInputField(
            label: "Email",
            controller: emailController,
          ),
          SizedBox(height: 5),
          StringInputField(
            label: "Password",
            controller: passwordController,
          ),
        ],
      ),
    );
  }
}

class StringInputField extends StatelessWidget {
  final Function validator;
  final String label;
  final TextEditingController controller;
  StringInputField(
      {@required this.label, this.validator, @required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 14,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        alignLabelWithHint: true,
      ),
      validator: validator == null
          ? (value) {
              if (value.isEmpty) {
                return 'Enter valid $label';
              }
              return null;
            }
          : validator,
    );
  }
}
