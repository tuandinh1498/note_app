import 'package:note_app/core/helper/sql_helper.dart';
import 'package:note_app/data/model/note_model.dart';

import '../res/remind_res.dart';

class RemindsImpl implements RemindsRepository {
  final dbHelper=DbHelper();
  @override
  Future deleteReminds(NoteModel task) {
    return dbHelper.deleteRemind(task);
  }

  @override
  Future insertReminds(NoteModel task) {
    return dbHelper.addRemind(task);
  }

  @override
  Future<List<NoteModel>> loadReminds() {
    return dbHelper.getAllReminds();
  }

  @override
  Future updateReminds(NoteModel task) {
    return dbHelper.updateRemind(task);
  }

}