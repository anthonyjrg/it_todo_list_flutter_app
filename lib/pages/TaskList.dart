import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
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
  List incompleteTaskList = [];
  List completedTaskList = [];
  //checkboxCompletedTaskList is a store for which checkbox have been clicked
  List checkboxCompletedTaskList = [];

  @override
  void initState() {
    super.initState();
    var incompleteTaskFunction = widget.incompleteTaskFunction();
    var completeTaskFunction = widget.completeTaskFunction();

    completeTaskFunction.then(
              (value)=>{
                setState((){completedTaskList=value;})
    });

    incompleteTaskFunction.then(
            (value)=>{
          setState((){incompleteTaskList=value;})
    });

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
              " ${widget.name}",
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding (
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView (
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
                                                  'id' : incompleteTaskList[index]['id'],
                                                  'completed_date': new DateTime.now().toString(),
                                                  'resolution': resolutionController.text
                                                };
                                                sessionManager.updateTaskStatus(taskStatus).then((value){
                                                  print(value.body);
                                                  if(value.body == 1){
                                                    setState(() {
                                                      incompleteTaskList.remove(index);
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
                              print(incompleteTaskList[index]);
                            },
                          ),
                          contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          title: Text(
                            '${incompleteTaskList[index]['title']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),

                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                Text(
                                  '${incompleteTaskList[index]['task_description']}',
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
                                  '${incompleteTaskList[index]['created_at']}',
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
                    itemCount: completedTaskList.length,
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
                ],
              )
          ),
        ),
      ),
    );
  }
}
