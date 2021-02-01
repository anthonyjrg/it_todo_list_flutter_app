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
    taskInstance = Task.fromMap(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[500], //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.wysiwyg_outlined,
              color: Colors.grey[500],
            ),
            Text(
              " Task Details",
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Flex(
          direction: Axis.vertical,
          children:[
            Expanded(
              child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                            Text("Completion Date: " + taskInstance.completed_date.toString())
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
                              Text("Due Date: " + taskInstance.due_date.toString())
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
                              Text(" Assign To")
                            ],
                          )
                      )
                    ],
                  ))
                ,
              ),
          ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  Text("Save Task")
                ],
              ),
                  onPressed: (){}),
            )
          ]
        )
      ),
    );
  }
}
