import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/helper/sql_helper.dart';
import '../../../data/model/note_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchNote>(_onSearchNote);
    on<DisposeNote>(_onDispose);
    on<InitialNote>(_onInitial);
  }
  final dbHelper = DbHelper();

  void _onDispose(
      DisposeNote searchEvent, Emitter<SearchState> emitter
      ){
    emitter(const SearchState().copyWith(
        statusSearch: SearchStatus.success, listSearchNote: []));
  }

  void _onInitial(
      InitialNote searchEvent, Emitter<SearchState> emitter
      ){
    emitter(const SearchState().copyWith(
        statusSearch: SearchStatus.initial, listSearchNote: []));
  }

  Future<void> _onSearchNote(
      SearchNote searchEvent, Emitter<SearchState> emitter) async {
    // emitter(const SearchState().copyWith(statusSearch: SearchStatus.initial));
    List<NoteModel> allListNote =[];
    allListNote= await getAllNote();
    List<NoteModel> searchListNote = [];

    searchListNote.addAll(allListNote
        .where((e) => ((e.title ?? "").trim().toLowerCase())
            .contains(searchEvent.searchValue.toLowerCase()))
        .toList());

    emitter(const SearchState().copyWith(
        statusSearch: SearchStatus.success, listSearchNote: searchListNote));
  }

  Future<List<NoteModel>> getAllNote() async {
    final allListNote = await dbHelper.getAllTasks();
    print(allListNote[0].title);
    return allListNote;
  }
}
