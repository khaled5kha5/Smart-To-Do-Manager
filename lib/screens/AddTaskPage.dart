import 'package:flutter/material.dart';
import 'package:task_1/database/db_helper.dart';
import 'package:task_1/models/task.dart';



class AddTaskPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _addTaskPage_work();
  }

}

class _addTaskPage_work extends State<AddTaskPage>{

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String priority = 'Low';
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')
      , backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: ['Low', 'Medium', 'High']
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(p),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => priority = value!);
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              child: Text(
                selectedDate == null
                    ? 'Select Due Date'
                    : selectedDate!.toString().split(' ')[0],
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (titleController.text.trim().isEmpty) {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: const Text('Title required'),
                    content: const Text('Title cannot be empty.'),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        child: const Text('OK')
                      )
                    ],
                  ),
                );
                return;
                }   
                  

                Task newTask = Task(
                  title: titleController.text,
                  description: descController.text,
                  priority: priority,
                  dueDate: selectedDate == null ? DateTime.now().toString().split(' ')[0] : selectedDate!.toString().split(' ')[0],
                  isCompleted: false,
                );

                await SQLDatabase.instance.insertTask(newTask.toMap());


                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
    
  }


}