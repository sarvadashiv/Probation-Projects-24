import 'package:flutter/material.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shivansh_verma2/model/todo_model.dart';
import 'package:shivansh_verma2/services/database_services.dart';
import 'package:shivansh_verma2/widgets/task_list_widget.dart';

class PendingWidget extends StatefulWidget {
  const PendingWidget({Key? key, required this.selectedDate}) : super(key: key);
  final DateTime selectedDate;

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget> {
  final DatabaseServices _databaseServices = DatabaseServices();

  @override
  void initState() {
    super.initState();
    _databaseServices.getTodosForDate(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<List<ToDo>>(
      stream: _databaseServices.getTodosForDate(widget.selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Add a task, Keep Grinding.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenWidth * 0.045,
              ),
            ),
          );
        }
        return TaskListWidget(
          tasks: snapshot.data!,
          databaseServices: _databaseServices,
          onEditTask: (task) => _showTaskDialog(context, todo: task),
          onDeleteTask: (taskId) => _showDeleteConfirmation(context, taskId),
          onMarkTaskComplete: (taskId) =>
              _databaseServices.updateTodoStatus(taskId, true),
        );
      },
    );
  }

  void _showTaskDialog(BuildContext context, {ToDo? todo}) {
    final TextEditingController _titleController =
        TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController =
        TextEditingController(text: todo?.description);

    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 61, 61, 61),
          title: Text(
            'Edit Task',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: screenWidth * 0.045,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(color: Colors.white10),
                      labelText: "No Title",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(color: Colors.white10),
                      labelText: "No Description",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                    ),
                    minLines: 1,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.red, fontSize: screenWidth * 0.045),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await _databaseServices.updateTodo(
                  todo!.id,
                  _titleController.text,
                  _descriptionController.text,
                );
                Navigator.pop(context);
              },
              child: Text(
                'Update',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String todoId) {
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: const Color.fromARGB(255, 104, 104, 104),
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete this task?',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenWidth * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async {
                      await _databaseServices.deleteTodo(todoId);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          color: Colors.red, fontSize: screenWidth * 0.045),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white, fontSize: screenWidth * 0.045),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
