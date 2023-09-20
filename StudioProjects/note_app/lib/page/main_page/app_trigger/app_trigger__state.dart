part of 'app_trigger__bloc.dart';

@immutable
abstract class AppTriggerState {
  final int tabIndex;
  const AppTriggerState({required this.tabIndex});
}

class AppTriggerInitial extends AppTriggerState {
  const AppTriggerInitial({required super.tabIndex});
}
