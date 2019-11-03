import 'package:flutter/material.dart';
import './screens/auth/authenticate.dart';
import './screens/auth/signin.dart';
import './screens/auth/signup.dart';
import './screens/create-article.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Authenticate(),
        '/signin': (context) => SigninScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => CreateArticleScreen(),
        '/new-article': (context) => CreateArticleScreen()
      }
    );
  }
}