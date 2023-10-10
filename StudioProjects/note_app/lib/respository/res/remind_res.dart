import '../../data/model/note_model.dart';

abstract class RemindsRepository {
  Future<List<NoteModel>> loadReminds();

  Future insertReminds(NoteModel task);

  Future updateReminds(NoteModel task);

  Future deleteReminds(NoteModel task);
}