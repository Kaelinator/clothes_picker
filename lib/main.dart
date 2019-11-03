import 'package:clothes_picker/screens/add-article.dart';
import 'package:clothes_picker/screens/custom-add-article.dart';
import 'package:clothes_picker/screens/home.dart';
import 'package:clothes_picker/screens/view-articles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/auth/authenticate.dart';
import './screens/auth/signin.dart';
import './screens/auth/signup.dart';
import './screens/create-article.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        print('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          '/': (context) => Authenticate(),
          '/signin': (context) => SigninScreen(),
          '/signup': (context) => SignupScreen(),
          '/create-article': (context) => CreateArticleScreen(),
          '/add-article': (context) => AddArticleScreen(settings.arguments),
          '/view-article': (context) => ViewArticlesScreen(settings.arguments),
          '/add-custom-article': (context) => AddCustomArticleScreen(settings.arguments)
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }
}