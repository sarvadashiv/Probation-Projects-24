import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shivansh_verma2/model/todo_model.dart';
import 'package:shivansh_verma2/services/database_services.dart';

class TaskListWidget extends StatelessWidget {
  final List<ToDo> tasks;
  final DatabaseServices databaseServices;
  final Function(ToDo) onEditTask;
  final Function(String) onDeleteTask;
  final Function(String) onMarkTaskComplete;

  const TaskListWidget({
    Key? key,
    required this.tasks,
    required this.databaseServices,
    required this.onEditTask,
    required this.onDeleteTask,
    required this.onMarkTaskComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks found.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: screenWidth * 0.045,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        ToDo toDo = tasks[index];
        return Container(
          margin: EdgeInsets.all(screenWidth * 0.035),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
          ),
          child: Slidable(
            key: ValueKey(toDo.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.done,
                  label: 'Mark',
                  onPressed: (context) {
                    onMarkTaskComplete(toDo.id);
                  },
                ),
              ],
            ),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                  onPressed: (context) {
                    onEditTask(toDo);
                  },
                ),
                SlidableAction(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: (context) {
                    onDeleteTask(toDo.id);
                  },
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                toDo.title.isEmpty ? 'No Title' : toDo.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              subtitle: Text(
                toDo.description,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}