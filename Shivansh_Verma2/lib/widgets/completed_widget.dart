import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shivansh_verma2/model/todo_model.dart';
import 'package:shivansh_verma2/services/database_services.dart';

class CompletedWidget extends StatefulWidget {
  const CompletedWidget({super.key});

  @override
  State<CompletedWidget> createState() => _CompletedWidgetState();
}

class _CompletedWidgetState extends State<CompletedWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  final DatabaseServices _databaseServices = DatabaseServices();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ToDo>>(
        stream: _databaseServices.completedtodos,
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<ToDo> todos= snapshot.data!;
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: todos.length,
                itemBuilder: (context,index){
                  ToDo toDo= todos[index];
                  final DateTime dt= toDo.timeStamp.toDate();
                  return Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Slidable(
                      key: ValueKey(toDo.id),
                      startActionPane: ActionPane(
                          motion: DrawerMotion(),
                          children: [
                          SlidableAction(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'UnMark',
                          onPressed: (context){
                            _databaseServices.updateTodoStatus(toDo.id, false);
                          })]),
                      endActionPane: ActionPane(motion: DrawerMotion(),
                          children: [
                            SlidableAction(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (context) async {
                                  await _databaseServices.deleteTodoStatus(toDo.id);
                                })
                          ]),
                      child: ListTile(
                        title: Text(
                          toDo.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough
                          ),
                        ),
                        subtitle: Text(
                          toDo.description,
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough
                          ),
                        ),
                        trailing: Text(
                          '${dt.day}/${dt.month}/${dt.year}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  );
                });}
          else{
            return Center(
                child: CircularProgressIndicator(color: Colors.deepPurple)
            );
          }
        }
    );
  }
}