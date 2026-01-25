import 'package:flutter/material.dart';
import 'package:task_1/database/db_helper.dart';
import 'package:task_1/models/task.dart';
import 'package:task_1/screens/AddTaskPage.dart';
import 'package:task_1/screens/EditTaskPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      
      home: MyHomePage() ,
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _MyHomePage_work();
  }
}

class _MyHomePage_work extends State<MyHomePage>{
   List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await SQLDatabase.instance.getTasks();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("K5 Tasks"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
 
          return Card(
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) async {
                  task.isCompleted = value!;
                  await SQLDatabase.instance.updateTask(task.toMap());
                  loadTasks();
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: task.description.isNotEmpty
                  ? Text(
                      'Description: ${task.description}\nPriority: ${task.priority}\nDue: ${task.dueDate}',
                    )
                  : Text(
                      'Priority: ${task.priority}\nDue: ${task.dueDate}',
                    ),
              trailing: Row( 
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                        final result = await Navigator.push(
                         context,
                        MaterialPageRoute(
                          builder: (_) => EditTaskPage(task: task),
                        ),
                      );
                      if(result == true){
                        loadTasks();
                    }
                    },
                  ),

                  IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () async {
                    await SQLDatabase.instance.deleteTask(task.id!);
                    loadTasks();
                    },
                  ),
                ]

              )
              
               
              
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final result = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskPage(),
              
            ),
          );
          result.then((value) {
            if (value == true) {
              loadTasks();
            }
          });
        },
        icon: Icon(Icons.add), 
        label: Text("Add Task"),
      ),
    );
  }

  
}



