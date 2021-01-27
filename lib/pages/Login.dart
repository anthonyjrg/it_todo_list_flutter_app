import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Create storage
  final storage = FlutterSecureStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void clearFields(){
    setState(() {
      this.emailController.clear();
      this.passwordController.clear();
    });
  }

  void login() async {
    var response = await http.post(
      'http://10.0.2.2:8000/api/sanctum/token',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'password': passwordController.text,
        'device_name': "mobile"
      }),
    );

    Map jsonResponse = jsonDecode(response.body);
    if(jsonResponse.containsKey("token")){
           await storage.write(key: "token", value: jsonResponse["token"]);

           String value = await storage.read(key: "token");
           if(value != null){
             Navigator.pushReplacementNamed(context, 'taskHome');
           }
    } else{
      print(jsonResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Center (
          child: Container(
            child: Padding (
              padding: EdgeInsets.all(20),
              child: Column (
                children: [
                  SizedBox(height: 100.0),
                  Icon(
                    Icons.fact_check,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                      "RBDF IT Todo",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 50.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Email',
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Password',
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                  ),
                  SizedBox(height: 10),
                  ButtonBar(
                    children: [
                      RaisedButton(
                        onPressed: (){
                        login();
                      },
                        color: Colors.grey[700],
                        child: Text(
                            "Login",
                            style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      FlatButton(
                            onPressed: (){
                            clearFields();
                      },
                          child: Text('Reset')
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
