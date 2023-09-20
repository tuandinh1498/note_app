import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/helper/sql_helper.dart';
import '../../../data/model/note_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<FetchEvent>(_onFetchNote);
    on<AddNote>(_onAddTask);
    on<UpdateNote>(_onUpdateTask);
    on<DeleteNote>(_onDeleteTask);
  }

  var dbHelper = DbHelper();

  Future<void> _onFetchNote(
      FetchEvent event,
      Emitter<HomeState> emitter
      ) async{

    emitter(const HomeState().copyWith(homeStatus: HomeStatus.initial));
    final listTasks = await dbHelper.getAllTasks();
    // listTasks.forEach((element) { print(element.id);});
    // print(listTasks.first.toJson());
    emitter(const HomeState().copyWith(homeStatus: HomeStatus.success,listNote: listTasks));
  }

  Future<void> _onUpdateTask (
      UpdateNote event,
      Emitter<HomeState> emitter
      )async{
    await dbHelper.updateTask(event.noteModel);
    final listTasks = await dbHelper.getAllTasks();
    emitter(const HomeState().copyWith(noteStatus: NoteStatus.update,homeStatus: HomeStatus.success,listNote: listTasks));
  }

  Future<void> _onAddTask (
      AddNote event,
      Emitter<HomeState> emitter
      )async{
    await dbHelper.addTask(event.noteModel);
    final listTasks = await dbHelper.getAllTasks();
    emitter(const HomeState().copyWith(noteStatus: NoteStatus.add,homeStatus: HomeStatus.success,listNote: listTasks));
  }

  Future<void> _onDeleteTask (
      DeleteNote event,
      Emitter<HomeState> emitter
      )async{
    await dbHelper.deleteTask(event.noteModel);
    final listTasks = await dbHelper.getAllTasks();
    emitter(const HomeState().copyWith(noteStatus: NoteStatus.delete,homeStatus: HomeStatus.success,listNote: listTasks));
    _onFetchNote;
  }
}
