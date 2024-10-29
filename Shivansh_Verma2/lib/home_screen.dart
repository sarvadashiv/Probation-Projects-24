import 'package:flutter/material.dart';
import 'package:shivansh_verma2/login_screen.dart';
import 'package:shivansh_verma2/model/todo_model.dart';
import 'package:shivansh_verma2/services/auth_services.dart';
import 'package:shivansh_verma2/services/database_services.dart';
import 'package:shivansh_verma2/widgets/pending_widget.dart';
import 'package:shivansh_verma2/widgets/completed_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _buttonIndex=0;
  final _widgets=[
    PendingWidget(),
    CompletedWidget()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        title: Text('ToDo'),
        actions: [
          IconButton(onPressed: ()async{
            await AuthService().signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: (){
                    setState(() {
                      _buttonIndex=0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex ==0 ? Colors.orange[300] : Colors.white30,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text('Pending',
                      style: TextStyle(
                        fontSize: _buttonIndex == 0? 16:14,
                        fontWeight: FontWeight.w500,
                        color:
                          _buttonIndex == 0 ? Colors.black : Colors.black
                      ),),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: (){
                    setState(() {
                      _buttonIndex=1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                        color: _buttonIndex == 1 ? Colors.orange[300]: Colors.white30,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text('Completed',
                        style: TextStyle(
                            fontSize: _buttonIndex == 1? 16:14,
                            fontWeight: FontWeight.w500,
                            color:
                            _buttonIndex == 1 ? Colors.black : Colors.black
                        ),),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            _widgets[_buttonIndex]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white38,
          child: Icon(Icons.add,color: Colors.orange),
          onPressed: (){
        _showTaskDialog(context);
      }),
    );
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
}