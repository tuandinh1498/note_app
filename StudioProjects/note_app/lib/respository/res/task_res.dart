import 'package:note_app/data/model/note_model.dart';


abstract class TaskRepository {
  Future<List<NoteModel>> loadTasks();

  Future insertTask(NoteModel task);

  Future updateTask(NoteModel task);

  Future deleteTask(NoteModel task);
}