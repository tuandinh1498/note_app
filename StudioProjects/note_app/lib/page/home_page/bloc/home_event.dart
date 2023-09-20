part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

class FetchEvent extends HomeEvent{}

class UpdateNote extends HomeEvent{
  final NoteModel noteModel;
  const UpdateNote({required this.noteModel});
}

class AddNote extends HomeEvent{
  final NoteModel noteModel;
  const AddNote({required this.noteModel});
}

class DeleteNote extends HomeEvent{
  final NoteModel noteModel;
  const DeleteNote({required this.noteModel});
}
