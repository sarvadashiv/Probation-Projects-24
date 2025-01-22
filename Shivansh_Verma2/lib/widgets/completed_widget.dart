import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shivansh_verma2/model/todo_model.dart';
import 'package:shivansh_verma2/services/database_services.dart';

class CompletedWidget extends StatefulWidget {
  const CompletedWidget({Key? key, required this.selectedDate}) : super(key: key);
  final DateTime selectedDate;

  @override
  State<CompletedWidget> createState() => _CompletedWidgetState();
}

class _CompletedWidgetState extends State<CompletedWidget> {
  final DatabaseServices _databaseServices = DatabaseServices();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<List<ToDo>>(
      stream: _databaseServices.getCompletedTodosForDate(widget.selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Hurry Up! Complete a task.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenWidth * 0.045,
              ),
            ),
          );
        }

        List<ToDo> todos = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            ToDo toDo = todos[index];
            return Container(
              margin: EdgeInsets.all(screenWidth * 0.025),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              child: Slidable(
                key: ValueKey(toDo.id),
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Unmark',
                      onPressed: (context) {
                        _databaseServices.updateTodoStatus(toDo.id, false);
                      },
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: (context) async {
                        _showDeleteConfirmation(context, toDo.id);
                      },
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    toDo.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  subtitle: Text(
                    toDo.description,
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ),
            );
          },
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
                      style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.045),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.045),
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