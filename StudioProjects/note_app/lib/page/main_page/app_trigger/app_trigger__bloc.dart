import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_trigger__event.dart';
part 'app_trigger__state.dart';

class AppTriggerBloc extends Bloc<AppTriggerEvent, AppTriggerState> {
  AppTriggerBloc() : super(AppTriggerInitial(tabIndex: 0)) {
   on<TabChange>(_tabChange);
  }
  void _tabChange(TabChange event, Emitter<AppTriggerState> emit){
     emit(AppTriggerInitial(tabIndex: event.tabIndex));
  }
}
