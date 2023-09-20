part of 'home_bloc.dart';

enum HomeStatus{initial,success,failure}
enum NoteStatus{initial,add,delete,update}
class HomeState  extends Equatable{
  final HomeStatus homeStatus;
  final NoteStatus noteStatus;
  final List<NoteModel> listNote;
  const HomeState({
    this.noteStatus=NoteStatus.initial,
    this.homeStatus=HomeStatus.success,
    this.listNote=const <NoteModel>[]
});


  HomeState copyWith({

    final HomeStatus? homeStatus,
    final NoteStatus? noteStatus,
    final List<NoteModel>? listNote,

  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      noteStatus: noteStatus ?? this.noteStatus,
      listNote: listNote ?? this.listNote,

    );
  }

  @override
  List<Object?> get props => [homeStatus,noteStatus,listNote];
}


