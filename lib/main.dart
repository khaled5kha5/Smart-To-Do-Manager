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
      
      
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 48, 54, 79),
          foregroundColor: Color.fromARGB(255, 230, 230, 250),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 48, 54, 79)),
        canvasColor: Color.fromARGB(255, 230, 230, 250),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 48, 54, 79),
            foregroundColor: Color.fromARGB(255, 230, 230, 250),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 48, 54, 79),
          foregroundColor: Color.fromARGB(255, 230, 230, 250),
        )
      ),
      home: MyHomePage(),
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
   List<Task> filteredTasks = [];
   TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await SQLDatabase.instance.getTasks();
    filteredTasks = tasks;
    setState(() {});
  }

  Future<void> filterTasks(String query) async {
    if (query.isEmpty) {
      filteredTasks = tasks;
    } else {
      filteredTasks = tasks
          .where((task) =>
              task.title.toLowerCase().contains(query.toLowerCase()) ||
              task.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("K5 Tasks"),
        centerTitle: true,
      ),
      
      body: Column(
        children: [


          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Tasks',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    filterTasks('');
                  },
                ),
              ),
              onChanged: (value) {
                filterTasks(value);
              },
            ),
          ),


          // Task list
          Expanded(
            child: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];

          return Card(
            color: Color.fromARGB(255, 230, 230, 250),
            child: ListTile(


              // isCompleted Checkbox
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) async {
                  task.isCompleted = value!;
                  await SQLDatabase.instance.updateTask(task.toMap());
                  loadTasks();
                },
              ),


              // Title
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),


              // Description, Priority, Due Date
              subtitle: task.description.isNotEmpty
                  ? Text(
                      'Description: ${task.description}\nPriority: ${task.priority}\nDue: ${task.dueDate}',
                    )
                  : Text(
                      'Priority: ${task.priority}\nDue: ${task.dueDate}',
                    ),


              // Edit and Delete buttons
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
          ),
        ],
      ),
      

      //add task button
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



