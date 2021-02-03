import 'package:flutter/material.dart';
import 'package:it_todo_list_app/pages/Login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it_todo_list_app/pages/TaskDetail.dart';
import 'package:it_todo_list_app/pages/Home.dart';

String initRoute;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // Create storage
  final storage = FlutterSecureStorage();

  String token = await storage.read(key: "token");
  print(token);

  if(token == null){
    initRoute = 'login';
  } else {
    initRoute = 'taskHome';
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context)  {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Open Sans',
        textTheme: TextTheme(
          headline2: TextStyle(
            fontSize: 16,
            color: Colors.grey[600]
          ),
          subtitle2: TextStyle(
            fontSize: 10,
            color: Colors.grey[400]
          )
        ),
        colorScheme: Theme.of(context).colorScheme.copyWith (
              primary: Color(0x014421),
              secondary: Colors.grey[700]
        )
      ),
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
        initialRoute: initRoute,
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          'login': (context) => Login(),
          'taskHome': (context) => TaskHome()
        }
    );
  }
}

