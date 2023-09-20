import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/page/home_page/bloc/home_bloc.dart';
import 'package:note_app/page/search_page/bloc/search_bloc.dart';

import '../../page/create_remind_page/remind_bloc/remind_bloc.dart';
import '../../page/main_page/app_trigger/app_trigger__bloc.dart';


class AppBlocProviders {
  static get allBlocProviders => [
        BlocProvider(create: (_) => AppTriggerBloc()),
        BlocProvider(create: (_) => HomeBloc()..add(FetchEvent())),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => RemindBloc()..add(FetchRemind())),
      ];
}
