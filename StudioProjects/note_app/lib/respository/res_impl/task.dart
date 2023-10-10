import 'package:note_app/core/helper/sql_helper.dart';
import 'package:note_app/data/model/note_model.dart';
import 'package:note_app/respository/res/task_res.dart';

class TaskImpl implements TaskRepository{
  final dbHelper=DbHelper();
  @override
  Future deleteTask(NoteModel task) {
   return dbHelper.deleteTask(task);
  }

  @override
  Future insertTask(NoteModel task) {
    return dbHelper.addTask(task);
  }

  @override
  Future<List<NoteModel>> loadTasks() {
    return dbHelper.getAllTasks();
  }

  @override
  Future updateTask(NoteModel task) {
    return dbHelper.updateTask(task);
  }

}