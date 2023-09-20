part of 'app_trigger__bloc.dart';

@immutable
abstract class AppTriggerEvent {}
class TabChange extends AppTriggerEvent {
  final int tabIndex;

  TabChange({required this.tabIndex});
}
