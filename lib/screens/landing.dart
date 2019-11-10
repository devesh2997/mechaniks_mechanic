import 'package:flutter/material.dart';
import 'package:mechaniks_mechanic/data/user_repository.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: userRepository.signOut,
          child: Text('Logout'),
        ),
      ),
    );
  }
}
