import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:it_todo_list_app/classes/User.dart';
import 'package:it_todo_list_app/pages/TaskList.dart';
import 'package:it_todo_list_app/utils/Consts.dart';
import 'package:it_todo_list_app/utils/SessionManager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

SessionManager sessionManager = SessionManager();

class TaskHome extends StatefulWidget {
  @override
  _TaskHomeState createState() => _TaskHomeState();
}

class _TaskHomeState extends State<TaskHome> {
  Future _user;
  Future _taskCounts;


  Future getUser() async {
    User user;
    await sessionManager.getUser(context).then((value)=>{
      user = User.fromMap(value)
    }).catchError((e){
        print(e);
    });
    return user;
  }

  Future getTaskCounts() async {
    var taskCounts;
    await sessionManager.getTaskCounts().then((value) => {
        taskCounts = value
    });
    return taskCounts;
  }

  @override
  void initState() {
    super.initState();
    _user = getUser();
    _taskCounts = getTaskCounts();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_user, _taskCounts]),
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              var user = snapshot.data[0];
              var taskCounts = snapshot.data[1];
              return _mainView(context, user, taskCounts);
            default:
              return _loadingScreen();
          }
        }
    );
  }
}

Widget _mainView(context, user, taskCounts){
  PanelController panelController = PanelController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Consts consts = Consts();
  var totalCompleteTask = (taskCounts["CHB_Complete"] + taskCounts["JFK_Complete"] + taskCounts["MISC_Complete"]).toString();
  var totalIncompleteTask = (taskCounts["CHB_Incomplete"] + taskCounts["JFK_Incomplete"] + taskCounts["MISC_Incomplete"]).toString();



  void resetTaskForm() {
    titleController.clear();
    descriptionController.clear();
  }

  void submitTask() async {
    if (_formKey.currentState.validate()) {
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

  Function allUserCompleteTaskFunction = () {
    return sessionManager.getUserCompletedTasks();
  };

  Function allUserIncompleteTaskFunction = () {
    return sessionManager.getUserIncompleteTasks();
  };

  Function allCompleteTaskFunction = () {
    return sessionManager.getCompletedTasks();
  };

  Function allIncompleteTaskFunction = () {
    return sessionManager.getIncompleteTasks();
  };

  Function CHBCompleteTaskFunction = (){
    return sessionManager.getCHBCompleteTask();
  };

  Function CHBInompleteTaskFunction = (){
    return sessionManager.getCHBInompleteTask();
  };

  return Scaffold(
    extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SlidingUpPanel(
          controller: panelController,
          backdropEnabled: true,
          parallaxEnabled: true,
          backdropTapClosesPanel: true,
          minHeight: 12,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          panel:
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
            Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 60,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15,top: 3),
                        child: RaisedButton(
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Text(
                            "CREATE TASK",
                            style: TextStyle(
                                color: Colors.deepPurple[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: titleController,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                focusColor: Colors.deepPurple[900]
                              )),
                          TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: descriptionController,
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              decoration:
                              InputDecoration(labelText: 'Task Description')
                          ),
                          SizedBox(height: 20),
                          FlatButton(onPressed: (){

                          }, child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                              color: Colors.grey[600],),
                              SizedBox(width: 10),
                              Text(DateFormat.yMMMEd().format(DateTime.now()).toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600]
                                  )
                              )
                            ]

                          )),
                          FlatButton(onPressed: (){

                          }, child: Row(
                              children: [
                                Icon(Icons.person_add_alt,
                                color: Colors.grey[600]),
                                SizedBox(width: 10),
                                Text(" Assign To",
                                style: TextStyle(
                                  color: Colors.grey[600]
                                ),)

                              ]

                          ))

                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                          onPressed: (){
                            submitTask();
                          },
                          child: Text(
                              "+  CREATE TASK",
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          color: Colors.deepPurple[900],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          resetTaskForm();
                        },
                        child: Text("Reset",
                        style: Theme.of(context).textTheme.subtitle1,
                        )
                    )

                  ],
                ))
          ]),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.3, 0.7, 0.9],
                  colors: [
                    Colors.deepPurple[600],
                    Colors.deepPurple[700],
                    Colors.deepPurple[800],
                    Colors.deepPurple[900],
                  ],
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              RichText(
                                  text: TextSpan(
                                      style: Theme.of(context).textTheme.headline2,
                                      children: [
                                        TextSpan(
                                            text: user.rankAbbreviation + " "
                                        ),
                                        TextSpan(
                                            text: user.lName
                                        )
                                      ]
                                  )
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    user.nameAbbreviation,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: consts.colors["mainPurple"]
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTapDown: (TapDownDetails details) async {
                                       await showMenu(
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                            details.globalPosition.dx - 20, details.globalPosition.dy - 10, 0, 0)
                                        ,
                                        items: [
                                          PopupMenuItem(
                                            value: 1,
                                            child: Text(
                                                "Logout",
                                              style: Theme.of(context).textTheme.subtitle1,
                                            ),
                                          ),
                                        ],
                                        elevation: 8.0,
                                      ).then((value){
                                        if(value == 1){
                                          sessionManager.logout(context);
                                        }
                                       });
                                    },
                                  child: IconButton(
                                      icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.white
                                      ),
                                      onPressed: () {}
                                  )
                                )
                              ]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                            child: Text(
                              taskCounts["User_Incomplete"].toString()+" Task Assigned To You",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, left: 20),
                            child: Text(
                              "0 Task Completed This Week",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Locations",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Card(
                                      child: GestureDetector (
                                        onTap: (){
                                          Navigator.of(context).push(
                                          MaterialPageRoute(
                                          builder: (context) => (TaskList(
                                          CHBCompleteTaskFunction,
                                          CHBIncompleteTaskFunction,
                                          "CHB Task"))
                                          )
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 30),
                                          child: Column (
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "CHB",
                                                    style: Theme.of(context).textTheme.headline3
                                                ),
                                                SizedBox(height: 10,),
                                                Text(taskCounts["CHB_Incomplete"].toString()),
                                                Text(
                                                  "Task Incomplete",
                                                  style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                                SizedBox(height: 5,),
                                                Text(taskCounts["CHB_Complete"].toString()),
                                                Text(
                                                  "Task Complete",
                                                  style: Theme.of(context).textTheme.subtitle1,
                                                )
                                              ]
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 30),
                                        child: Column (
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "JFK",
                                                  style: Theme.of(context).textTheme.headline3
                                              ),
                                              SizedBox(height: 10,),
                                              Text(taskCounts["JFK_Incomplete"].toString()),
                                              Text(
                                                "Task Incomplete",
                                                style: Theme.of(context).textTheme.subtitle1,
                                              ),
                                              SizedBox(height: 5,),
                                              Text(taskCounts["JFK_Complete"].toString()),
                                              Text(
                                                "Task Complete",
                                                style: Theme.of(context).textTheme.subtitle1,)
                                            ]
                                        ),
                                      ),
                                    ),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 30),
                                        child: Column (
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "MISC",
                                                  style: Theme.of(context).textTheme.headline3
                                              ),
                                              SizedBox(height: 10,),
                                              Text(taskCounts["MISC_Incomplete"].toString()),
                                              Text(
                                                "Task Incomplete",
                                                style: Theme.of(context).textTheme.subtitle1,
                                              ),
                                              SizedBox(height: 5,),
                                              Text(taskCounts["MISC_Complete"].toString()),
                                              Text(
                                                "Task Complete",
                                                style: Theme.of(context).textTheme.subtitle1,
                                              )
                                            ]
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]
                      ),
                    ),


                    Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0),
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Task List",
                              style: TextStyle(
                                  color: Colors.deepPurple[900],
                                  fontSize: 18
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => (TaskList(
                                            allUserCompleteTaskFunction,
                                            allUserIncompleteTaskFunction,
                                            "My Task"))));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    child: RaisedButton(
                                      onPressed: (){
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => (TaskList(
                                                    allUserCompleteTaskFunction,
                                                    allUserIncompleteTaskFunction,
                                                    "My Task"))));
                                      },
                                      color: consts.colors["mainPurple"],
                                      child: Icon(
                                        Icons.list_alt,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "My Task",
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                        Text(
                                          taskCounts["User_Incomplete"].toString() + " Task Incomplete",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        Text(
                                          taskCounts["User_Complete"].toString() + " Total Task Complete",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => (TaskList(
                                        allCompleteTaskFunction,
                                        allIncompleteTaskFunction,
                                        "All Task"))));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    child: RaisedButton(
                                      onPressed: (){
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => (TaskList(
                                                allCompleteTaskFunction,
                                                allIncompleteTaskFunction,
                                                "All Task"))));
                                      },
                                      color: consts.colors["mainPurple"],
                                      child: Icon(
                                        Icons.library_books_sharp,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "All Task",
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                        Text(
                                          totalIncompleteTask + " Task Incomplete",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        Text(
                                          totalCompleteTask + " Total Task Complete",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: consts.colors['mainPurple'],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          onPressed: () {
            panelController.open();
          },
        ),
      ));
}

Widget _loadingScreen() {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    body: Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
