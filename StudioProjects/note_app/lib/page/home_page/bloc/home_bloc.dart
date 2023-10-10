import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/helper/sql_helper.dart';
import '../../../data/model/note_model.dart';
import '../../../respository/res_impl/task.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<FetchEvent>(_onFetchNote);
    on<AddNote>(_onAddTask);
    on<UpdateNote>(_onUpdateTask);
    on<DeleteNote>(_onDeleteTask);
  }

  final taskResponsitory = TaskImpl();

  Future<void> _onFetchNote(
      FetchEvent event,
      Emitter<HomeState> emitter
      ) async{

    emitter(const HomeState().copyWith(homeStatus: HomeStatus.initial));
    final listTasks = await loadTasks();
    // listTasks.forEach((element) { print(element.id);});
    // print(listTasks.first.toJson());
    emitter(const HomeState().copyWith(homeStatus: HomeStatus.success,listNote: listTasks));
  }

  Future<List<NoteModel>> loadTasks() => taskResponsitory.loadTasks();

  Future<void> _onUpdateTask (
      UpdateNote event,
      Emitter<HomeState> emitter
      )async{
    await taskResponsitory.updateTask(event.noteModel);
    final listTasks = await loadTasks();
    emitter(const HomeState().copyWith(noteStatus: NoteStatus.update,homeStatus: HomeStatus.success,listNote: listTasks));
  }

  Future<void> _onAddTask (
      AddNote event,
      Emitter<HomeState> emitter
      )async{
    await taskResponsitory.insertTask(event.noteModel);
    final listTasks = await loadTasks();
    emitter(const HomeState().copyWith(noteStatus: NoteStatus.add,homeStatus: HomeStatus.success,listNote: listTasks));
  }

  Future<void> _onDeleteTask (
      DeleteNote event,
      Emitter<HomeState> emitter
      )async{
    await taskResponsitory.deleteTask(event.noteModel);
    final listTasks = await loadTasks();
    emitter(const HomeState().copyWith(noteStatus: NoteStatus.delete,homeStatus: HomeStatus.success,listNote: listTasks));
    _onFetchNote;
  }
}
