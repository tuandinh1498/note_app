part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {
  const SearchEvent();
}

class SearchNote extends SearchEvent{
  final String searchValue;
  const SearchNote({required this.searchValue});
}

class InitialNote extends SearchEvent{}
class DisposeNote extends SearchEvent{}
