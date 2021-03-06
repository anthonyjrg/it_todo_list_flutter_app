import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:it_todo_list_app/classes/Task.dart';
import 'package:it_todo_list_app/utils/Consts.dart';


class SessionManager  {
  Map user;
  Consts consts = Consts();


  Future<Map> getUser(context) async {
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");

    var response = await http.post(
      consts.apiEndpoint+'api/user',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },
    );

    Map jsonResponse = jsonDecode(response.body);
    user = jsonResponse;
    if(user.containsKey("message") && user['message'] == 'Unauthenticated.'){
      logout(context);
    }
    print(user);
    return user;
  }

  Future<List> getUserIncompleteTasks () async {
    //get user token
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");

    // get all task
    // @todo implement pagination
    var response = await http.post(
      consts.apiEndpoint+'api/user/tasks/incomplete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },

    );

    var jsonResponse =  jsonDecode(response.body);
    List<Task> taskList = [];
    jsonResponse.forEach((v)=>{
      taskList.add(Task.fromMap(v))
    });
    return taskList;
  }

  Future<List> getUserCompletedTasks () async {

    //get user token
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");

    // get all task
    // @todo implement pagination
    var response = await http.post(
      consts.apiEndpoint+'api/user/tasks/complete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },
    );

    var jsonResponse =  jsonDecode(response.body);
    List<Task> taskList = [];

    jsonResponse.forEach((v) => {
      taskList.add(Task.fromMap(v))
    });
    return taskList;
  }


  Future<List> getIncompleteTasks () async {

    //get user token
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");

    // get all task
    // @todo implement pagination
    var response = await http.post(
      consts.apiEndpoint+'api/task/incomplete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },

    );

    var jsonResponse =  jsonDecode(response.body);
    List<Task> taskList = [];
    jsonResponse.forEach((k,v)=>{
      taskList.add(Task.fromMap(v))
    });
    return taskList;
  }

  Future<List> getCompletedTasks () async {
    //get user token
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");
    // get all task
    // @todo implement pagination
    var response = await http.post(
      consts.apiEndpoint+'api/task/complete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },
    );

    var jsonResponse = jsonDecode(response.body);


    List taskList = [];
    jsonResponse.forEach((k,v)=>{
      taskList.add(Task.fromMap(v))
    });

    return taskList;
  }

  Future<List> getCHBCompletedTasks () async {
    //get user token
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");
    // get all task
    // @todo implement pagination
    var response = await http.post(
      consts.apiEndpoint+'api/task/complete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },
    );

    var jsonResponse = jsonDecode(response.body);


    List taskList = [];
    jsonResponse.forEach((k,v)=>{
      taskList.add(Task.fromMap(v))
    });

    return taskList;
  }

  Future updateTaskStatus(Map updateMap) async {
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");

    var response = await http.post(
        consts.apiEndpoint+'api/task/status/update',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: jsonEncode({
          'id': updateMap['id'],
          'completed_date': updateMap['completed_date'],
          'resolution': updateMap['resolution']
        })
    );

    return response;

  }

  Future getTaskCounts() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");

    // get all task
    // @todo implement pagination
    var response = await http.post(
      consts.apiEndpoint+'api/task/counts',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },
    );

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  saveTask(Map taskMap) async {
    //get user token
    WidgetsFlutterBinding.ensureInitialized();
    // Create storage
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");

    var response = await http.post(
      consts.apiEndpoint+'api/task/create',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },
      body: jsonEncode(<String, String>{
        'title': taskMap['title'],
        'description': taskMap['description']
      })
    );

    return response;
  }

  logout(context) async {
    WidgetsFlutterBinding.ensureInitialized();
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");

    var response = await http.post(
      consts.apiEndpoint+'api/user/logout',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },
    );

    //Logout was success remove local storage keys and redirect to login screen
    storage.delete(key: "token");
    Navigator.pushReplacementNamed(context, 'login');


    print(response.body);
  }
}