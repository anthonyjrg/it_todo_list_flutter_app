import 'package:flutter/material.dart';
import 'package:it_todo_list_app/classes/Task.dart';

class TaskDetail extends StatefulWidget {

  final task;
  const TaskDetail(this.task);

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Task taskInstance;
  _TaskDetailState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskInstance = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.deepPurple[900], //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            Text(
              "Task Details",
              style: TextStyle(
                  color: Colors.deepPurple[500],
                  fontWeight: FontWeight.bold
              ),
            ),

      ),
      body: Container(
        child: Flex(
          direction: Axis.vertical,
          children:[
            Expanded(
              child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: SingleChildScrollView(
                child:
                  Form(child: Column(
                    children: [
                      TextFormField(
                        initialValue: taskInstance.title,
                        decoration: InputDecoration(
                            labelText: "Task Title"
                        ),
                      ),
                      TextFormField(
                        initialValue: taskInstance.task_description,
                        decoration: InputDecoration(
                            labelText: "Task Description"
                        ),
                        minLines: 2,
                        maxLines: 3,
                      ),
                      TextFormField(
                        initialValue: taskInstance.resolution_description,
                        decoration: InputDecoration(
                            labelText: "Task Resolution"
                        ),
                        minLines: 2,
                        maxLines: 3,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: DropdownButton(
                          isExpanded: true,
                          hint: Text("Location"),
                          value: taskInstance.location,
                          items: [
                            DropdownMenuItem(
                              child: Text("CHB"),
                              value: "CHB",
                            ),
                            DropdownMenuItem(
                              child: Text("JFK"),
                              value: "JFK",
                            ),
                            DropdownMenuItem(
                                child: Text("MISC"),
                                value: "MISC"
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              taskInstance.location = value;
                            });
                          }),
                    ),
                      FlatButton(
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded),
                            SizedBox(width: 10,),
                            Text(
                              "Completion Date: " + taskInstance.completed_date.toString(),
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                              ]
                        ),
                        onPressed: () async{
                          DateTime date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(Duration(days: 7)),
                              lastDate: DateTime.now().add(Duration(days: 1)))
                              .then((value) => null);
                        },
                      ),
                      FlatButton(
                        child: Row(
                            children: [
                              Icon(Icons.calendar_today_rounded),
                              SizedBox(width: 10,),
                              Text("Due Date: " + taskInstance.due_date.toString(),
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ]
                        ),
                        onPressed: () async{
                          DateTime date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(Duration(days: 7)),
                              lastDate: DateTime.now().add(Duration(days: 1)))
                              .then((value) => null);
                        },
                      ),
                      FlatButton(
                          onPressed: (){},
                          child: Row(
                            children: [
                              Icon(Icons.person_add_alt_1),
                              SizedBox(width: 10,),
                              Text(" Assign To",
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ],
                          )
                      )
                    ],
                  ))
                ,
              ),
          ),
            ),
            RaisedButton(
              elevation: 2,
                color: Colors.deepPurple[500],
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Icon(Icons.add, color: Colors.white,),
                Text("  SAVE TASK", style: TextStyle(
                  color: Colors.white
                ),),
                SizedBox(height: 40),
              ],
            ),
                onPressed: (){})
          ]
        )
      ),
    );
  }
}
