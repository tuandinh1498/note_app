part of 'search_bloc.dart';

enum SearchStatus { initial, success, failure }

class SearchState extends Equatable {
  final List<NoteModel> listSearchNote;
  final SearchStatus statusSearch;

  const SearchState(
      {this.listSearchNote = const <NoteModel>[],
      this.statusSearch = SearchStatus.initial});

  SearchState copyWith({
    final List<NoteModel>? listSearchNote,
    final SearchStatus? statusSearch,
  }) {
    return SearchState(
      listSearchNote: listSearchNote ?? this.listSearchNote,
      statusSearch: statusSearch ?? this.statusSearch,
    );
  }

  @override
  List<Object> get props => [listSearchNote, statusSearch];
}
