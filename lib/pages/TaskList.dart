import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:it_todo_list_app/classes/Task.dart';
import 'package:it_todo_list_app/pages/TaskDetail.dart';
import 'package:it_todo_list_app/utils/SessionManager.dart';

SessionManager sessionManager = SessionManager();

class TaskList extends StatefulWidget {
  final completeTaskFunction;
  final incompleteTaskFunction;
  final name;

  const TaskList(this.completeTaskFunction, this.incompleteTaskFunction, this.name);

  @override
  _TaskList createState() => _TaskList();
}


class _TaskList extends State<TaskList> {
  List tasks = [];
  List<Task> incompleteTaskList = [];
  List<Task> completedTaskList = [];
  //checkboxCompletedTaskList is a store for which checkbox have been clicked
  List checkboxCompletedTaskList = [];
  Future _completeTaskList;
  Future _incompleteTaskList;

  Future getCompleteTask() async {
    List listOfTask;
    await widget.completeTaskFunction().then(
            (value)=>{
          listOfTask = value
        });
    return listOfTask;
  }

  Future getIncompleteTask() async {
    List listOfTask;
    await widget.incompleteTaskFunction().then(
            (value)=>{
          listOfTask = value
        });
    // print(listOfTask[0]);
    return listOfTask;
  }

  @override
  void initState() {
    super.initState();
    _completeTaskList = getCompleteTask();
    _incompleteTaskList = getIncompleteTask();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_completeTaskList, _incompleteTaskList]),
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              var completeTaskList = snapshot.data[0];
              var incompleteTaskList = snapshot.data[1];
              return _taskListView(context, completeTaskList, incompleteTaskList, widget.name);
            default:
              return _loadingScreen();
          }
        }
    );
  }
}

Widget _taskListView(context, completeTaskList, incompleteTaskList, name){

  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Text(
            " $name",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    ),
    body: Container(
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
      child: SafeArea(
        child: SingleChildScrollView (

            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  )
              ),
              child: Column(

                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: incompleteTaskList.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TaskDetail(incompleteTaskList[index])));
                          },
                          leading: Checkbox(
                            value: (false),
                            onChanged: (bool value){
                              String resolutionText = "";

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    TextEditingController resolutionController = TextEditingController();
                                    return AlertDialog(
                                      title: Text("Task Resolution"),
                                      content: Form(
                                        child: Container(
                                          child: TextFormField(
                                            controller: resolutionController,
                                            decoration: InputDecoration(
                                              labelText: "Resolution Description",
                                            ),
                                            minLines: 2,
                                            maxLines: 3,
                                          ),
                                        ) ,
                                      ),
                                      actions: [
                                        RaisedButton(
                                          onPressed: (){
                                            // setState(() {
                                            //   if(checkboxCompletedTaskList.contains(index))
                                            //     checkboxCompletedTaskList.remove(index);
                                            //   else {
                                            //     checkboxCompletedTaskList.add(index);
                                            //     Map taskStatus = {
                                            //       'id' : incompleteTaskList[index]['id'],
                                            //       'completed_date': new DateTime.now().toString(),
                                            //       'resolution': resolutionController.text
                                            //     };
                                            //     sessionManager.updateTaskStatus(taskStatus).then((value){
                                            //       print(value.body);
                                            //       if(value.body == 1){
                                            //         setState(() {
                                            //           incompleteTaskList.remove(index);
                                            //         });
                                            //       }
                                            //     });
                                            //   }
                                            // });
                                            // Navigator.pop(context);
                                          },
                                          child: Text("Completed"),
                                        )
                                      ],
                                    );
                                  }
                              );

                              print(value);
                              print(incompleteTaskList[index]);
                            },
                          ),
                          contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          title: Text(
                            '${incompleteTaskList[index].title}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),

                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                Text(
                                  '${incompleteTaskList[index].task_description}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 12
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  '${incompleteTaskList[index].created_at}',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 11,
                                      color: Colors.grey[700]
                                  ),
                                ),
                                Text(
                                  '${incompleteTaskList[index].assigned_to}',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 11,
                                      color: Colors.grey[700]
                                  ),
                                )
                              ]
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey[300],
                            ),
                            onPressed: (){

                            },
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text(
                      "Completed Task",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500]
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: completeTaskList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return Column(
                          children:[
                            Card(
                              child: ListTile(
                                leading: Checkbox(
                                  value: (true),
                                  onChanged: (bool value){

                                  },
                                ),
                                contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                title: Text(
                                  '${completeTaskList[index].title}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12
                                  ),
                                ),

                                subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5,),
                                      Text(
                                        '${completeTaskList[index].task_description}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 10,
                                            color: Colors.grey[600]
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        '${completeTaskList[index].created_at}',
                                        style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 11,
                                            color: Colors.grey[500]
                                        ),
                                      )
                                    ]
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.grey[300],
                                  ),
                                  onPressed: (){

                                  },
                                ),
                              ),
                            ),
                          ]
                      );
                    },
                  ),
                ],
              ),
            )
        ),
      ),
    ),
  );
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
