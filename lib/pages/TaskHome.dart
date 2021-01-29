import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:it_todo_list_app/utils/SessionManager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

SessionManager sessionManager = SessionManager();


class TaskHome extends StatefulWidget {
  @override
  _TaskHomeState createState() => _TaskHomeState();
}

class _TaskHomeState extends State<TaskHome> {
  Map user = {};
  PanelController panelController = PanelController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void resetTaskForm(){
    titleController.clear();
    descriptionController.clear();
  }

  void submitTask() async {
    if (_formKey.currentState.validate()){

      Map taskMap = {
        "title": titleController.text,
        "description": descriptionController.text
      };

      var result = await sessionManager.saveTask(taskMap);
      print(result.body);

      panelController.close();
      resetTaskForm();
    }
  }



  void getUser() async {
    await sessionManager.getUser().then((value) => setState(
            () {
          user = value;
          print(value);
        }
      )
    );
  }

  _TaskHomeState() {}


  @override
  void initState() {
    super.initState();
    getUser();
  }

  String getRankInitials(String rank){
    List<String> rankWords = rank.split(' ');
    String capitals = rankWords.first.substring(0, 1).toUpperCase() + "/" + rankWords.last.substring(0, 1).toUpperCase();
    return capitals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListView(
                      shrinkWrap: true,
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: Column(
                            children: [
                              SizedBox(height: 20.0),
                              Icon(
                                Icons.fact_check,
                                size: 30,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 20.0),
                              Text("IT TODO List")
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                        ),
                        ListTile(
                          title: Text('Edit Profile'),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                          },
                        ),
                  ],
                ),
                Expanded(child: Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: (){
                        sessionManager.logout(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          Text(" Logout")
                        ],
                      ),
                    ),
                  )
                )
              ]
          ),
      ),
      appBar: AppBar(
        title: Text(
            "IT TODO",
            style: TextStyle(
              color: Colors.white
            ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
        actions: [
          IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () {
      print("Creating new task");
      panelController.open();
    })
        ],
      ),
      body:
      SlidingUpPanel (
        controller: panelController,
        backdropEnabled: true,
        parallaxEnabled: true,
        backdropTapClosesPanel: true,
        minHeight: 10,
        borderRadius: BorderRadius.all(Radius.circular(20)),

        panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                            "New Task",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14
                            ),
                        ),
                        SizedBox(height: 10),
                        TextFormField (
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                          )
                        ),
                        TextFormField (
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: descriptionController,
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: 5,
                            decoration: InputDecoration(
                                labelText: 'Task Description'
                            )
                        ),
                        SizedBox(height: 20),
                        ButtonBar(
                          children: [
                            RaisedButton(
                                onPressed: (){
                                  submitTask();
                            },
                              child: Text("Save")
                            ),
                            FlatButton(
                                onPressed: (){
                                  resetTaskForm();
                                },
                                child: Text("Clear")
                            )
                          ],
                        )
                      ],
                    ),
                  )
              )
            ]
        ),
        body:  Container(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey[400],
                      child: Text(
                        user['fName'].substring(0, 1) + user['lName'].substring(0, 1),
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Open Sans'
                                ),
                                children: [
                                  TextSpan(text: getRankInitials(user['rank'])+" "),
                                  TextSpan(text: user['lName'])
                                ]
                            )
                        ),
                        Text(
                          user['email'],
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700]
                          ),
                        )
                      ],
                    )

                  ],
                ),
                Row (
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 0, 20),
                      child: Row(
                        children: [
                          Row(
                                children: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, 'myTask');
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.notes_rounded),
                                          Text(
                                            " My Tasks",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600]
                                            ),
                                          )
                                        ],
                                      )
                                  )
                                ],
                              )
                        ],
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                Row(
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'allTask');
                        },
                        child: Row(
                          children: [
                            Icon(
                                Icons.notes,
                              color: Colors.grey[600],
                            ),
                            Text(
                              " All Tasks",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600]
                              ),
                            )
                          ],
                        )
                    )
                  ],
                )

              ],
            )

        ),
      ),
    );
  }
}
