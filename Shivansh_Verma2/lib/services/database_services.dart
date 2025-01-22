import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shivansh_verma2/model/todo_model.dart';

class DatabaseServices{
  final CollectionReference todoCollection = FirebaseFirestore.instance.collection("todos");
  User? user= FirebaseAuth.instance.currentUser;
  Future<DocumentReference> addToDoTask(
      String title,String description, DateTime selectedDate) async {
    return await todoCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': Timestamp.fromDate(selectedDate)
    });
  }
  Future<void> updateTodo(String id,String title, String description) async{
    final updatetodoCollection= FirebaseFirestore.instance.collection('todos').doc(id);
    return await updatetodoCollection.update({
      'title': title,
      'description': description,
    });
  }
  Future<void> updateTodoStatus(String id, bool completed)async{
    return await todoCollection.doc(id).update({'completed': completed});
  }
  Future<void> deleteTodo(String id)async{
    return await todoCollection.doc(id).delete();
  }
  Stream<List<ToDo>> getTodosForDate(DateTime selectedDate) {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .where('createdAt', isGreaterThanOrEqualTo: selectedDate)
        .where('createdAt', isLessThan: selectedDate.add(Duration(days: 1)))
        .snapshots()
        .map(_todoListFromSnapshot);
  }
  Stream<List<ToDo>> getCompletedTodosForDate(DateTime selectedDate) {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .where('createdAt', isGreaterThanOrEqualTo: selectedDate)
        .where('createdAt', isLessThan: selectedDate.add(Duration(days: 1)))
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  Stream<List<ToDo>> getTodosForMonth(DateTime selectedMonth) {
  final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
  final endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1).subtract(Duration(seconds: 1));

  return todoCollection
      .where('uid', isEqualTo: user!.uid)
      .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
      .where('createdAt', isLessThanOrEqualTo: endOfMonth)
      .snapshots()
      .map(_todoListFromSnapshot);
}


  List<ToDo> _todoListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return ToDo(
        id: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        completed: doc['completed'] ?? false,
        createdAt: (doc['createdAt'] as Timestamp).toDate());
    }).toList();
    }
}