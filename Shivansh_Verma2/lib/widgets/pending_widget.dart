import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shivansh_verma2/model/todo_model.dart';
import 'package:shivansh_verma2/services/database_services.dart';

class PendingWidget extends StatefulWidget {
  const PendingWidget({super.key});

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget> {
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
        stream: _databaseServices.todos,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Slidable(
                        key: ValueKey(toDo.id),
                        endActionPane: ActionPane(motion: DrawerMotion(),
                            children: [
                              SlidableAction(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.done,
                                  label: 'Mark',
                                  onPressed: (context){
                                    _databaseServices.updateTodoStatus(toDo.id, true);
                                  })
                            ]),
                        startActionPane: ActionPane(
                            motion: DrawerMotion(),
                            children: [
                              SlidableAction(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                  onPressed: (context){
                                    _showTaskDialog(context, todo: toDo);
                                  }),
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
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          subtitle: Text(
                            toDo.description,
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
                child: CircularProgressIndicator(color: Colors.white,)
              );
          }
    }
    );
  }
}
  void _showTaskDialog (BuildContext context, {ToDo ? todo}){
    final TextEditingController _titleController= TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController= TextEditingController(text: todo?.description);
    final DatabaseServices _databaseService = DatabaseServices();
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(todo== null ? 'Add Task':'Edit Task',
          style: TextStyle(
              fontWeight: FontWeight.w500
          ),),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder()
                  ),
                )
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white
              ),
              onPressed: ()async {
                if(todo==null){
                  await _databaseService.addToDoTask(_titleController.text, _descriptionController.text);
                }
                else{
                  await _databaseService.updateTodo(todo.id,_titleController.text, _descriptionController.text);
                }
                Navigator.pop(context);
              }, child: Text(todo==  null ? 'Add':'Update'))
        ],
      );
    });
}
