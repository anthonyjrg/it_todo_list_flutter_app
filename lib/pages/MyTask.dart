import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:it_todo_list_app/utils/SessionManager.dart';

SessionManager sessionManager = SessionManager();

class MyTasks extends StatefulWidget {
  @override
  _MyTasksState createState() => _MyTasksState();
}


class _MyTasksState extends State<MyTasks> {
   List tasks = [];
   List completedTaskList = [];
   //checkboxCompletedTaskList is a store for which checkbox have been clicked
   List checkboxCompletedTaskList = [];
   void getTasks() async {
     await sessionManager.getUserIncompleteTasks().then((value) => setState(
             () {
               tasks = value;
              }
        )
     );
   }

   void getCompletedTasks() async {
     await sessionManager.getUserCompletedTasks().then((value) => setState(
             () {
               completedTaskList = value;
         }
     )
     );
   }
  


  @override
  void initState() {
    super.initState();
    getTasks();
    getCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[500], //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.notes_rounded,
              color: Colors.grey[500],
            ),
            Text(
              " My Tasks",
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(

            children: [
              Flexible(
                flex: 6,
                child:  ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: (checkboxCompletedTaskList.contains(index)),
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
                                            setState(() {
                                              if(checkboxCompletedTaskList.contains(index))
                                                checkboxCompletedTaskList.remove(index);
                                              else {
                                                checkboxCompletedTaskList.add(index);
                                                Map taskStatus = {
                                                  'id' : tasks[index]['id'],
                                                  'completed_date': new DateTime.now().toString(),
                                                  'resolution': resolutionController.text
                                                };
                                                sessionManager.updateTaskStatus(taskStatus).then((value){
                                                  print(value.body);
                                                  if(value.body == 1){
                                                    setState(() {
                                                      tasks.remove(index);
                                                    });
                                                  }
                                                });
                                              }
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text("Completed"),
                                        )
                                    ],
                                    );
                                }
                            );

                            print(value);
                            print(tasks[index]);
                          },
                        ),
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        title: Text(
                          '${tasks[index]['title']}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5,),
                            Text(
                                  '${tasks[index]['task_description']}',
                                  overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 12
                                  ),
                                ),
                            SizedBox(height: 10,),
                            Text(
                              '${tasks[index]['created_at']}',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 11,
                                color: Colors.grey[700]
                              ),
                            )
                            ]
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: (){

                            },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Divider(
                      color: Colors.grey[400]
                  )
              ),
              Flexible(
                flex: 4,
                child:  ListView.builder(
                  itemCount: completedTaskList.length,
                  itemBuilder: (context, index){
                    return Column(
                      children:[
                        Text(
                            "Completed Task",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500]
                            ),
                        ),
                        Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: (true),
                            onChanged: (bool value){

                              print(value);
                              print(completedTaskList[index]);
                            },
                          ),
                          contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          title: Text(
                            '${completedTaskList[index]['title']}',
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
                                  '${completedTaskList[index]['task_description']}',
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
                                  '${completedTaskList[index]['created_at']}',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 11,
                                      color: Colors.grey[500]
                                  ),
                                )
                              ]
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: (){

                            },
                          ),
                        ),
                      ),
                    ]
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
