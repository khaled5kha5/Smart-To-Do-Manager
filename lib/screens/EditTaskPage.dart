import 'package:flutter/material.dart';
import 'package:task_1/database/db_helper.dart';
import 'package:task_1/models/task.dart';

class EditTaskPage extends StatefulWidget{
  final Task task;

   EditTaskPage({super.key, required this.task});

  @override
  State<StatefulWidget> createState() {
    return _editTaskPage_work();
  }
  
}
class _editTaskPage_work extends State<EditTaskPage>{
  
  late TextEditingController titleController;
  late TextEditingController descController;

  late String selectedPriority;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.task.title);
    descController =
        TextEditingController(text: widget.task.description);

    selectedPriority = widget.task.priority;
    selectedDate = DateTime.parse(widget.task.dueDate);
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> saveTask() async {
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
    widget.task.title = titleController.text;
    widget.task.description = descController.text;
    widget.task.priority = selectedPriority;
    widget.task.dueDate =
        (selectedDate != null ? selectedDate.toString().split(' ')[0] : DateTime.now().toString().split(' ')[0]);

    await SQLDatabase.instance.updateTask(widget.task.toMap());
    Navigator.pop(context, true); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')
      ,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            // Title TextField
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),


            // Description TextField
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),


            // Priority Dropdown
            DropdownButtonFormField<String>(
              value: selectedPriority,
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
                setState(() => selectedPriority = value!);
              },
            ),
            const SizedBox(height: 10),


            // Due Date Picker
            ListTile(
              title: Text(
                selectedDate == null
                    ? 'Select Due Date'
                    : 'Due Date: ${selectedDate!.toString().split(' ')[0]}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: pickDate,
            ),
            const SizedBox(height: 20),


            // Save Button
            ElevatedButton(
              onPressed: saveTask,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}