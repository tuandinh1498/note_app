import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/page/home_page/home_page.dart';
import 'package:note_app/page/remind_list_page/remind_list_page.dart';
import 'package:note_app/page/search_page/search_page.dart';
import 'app_trigger/app_trigger__bloc.dart';



List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    label: 'Ghi chú',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.calendar_today_rounded),
    label: 'Nhắc nhở',
  ),

  BottomNavigationBarItem(
    icon: Icon(Icons.search_outlined),
    label: 'Tìm kiếm',
  ),

];

const List<Widget> listPage = <Widget>[
  HomePage(),

  RemindListPage(),
  SearchPage(),

];
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppTriggerBloc, AppTriggerState>(
      builder: (context, state) {
        return Scaffold(

          body: listPage[state.tabIndex],
          bottomNavigationBar: _bottomNavBar(
              state.tabIndex,
                  (currentIndex) => context
                  .read<AppTriggerBloc>()
                  .add(TabChange(tabIndex: currentIndex)
              )
          ),

        );
      },
    );
  }

  Widget _bottomNavBar(int currentState, Function(int) onTap) {
    return BottomNavigationBar(
        elevation: 5,
        backgroundColor: Colors.white,
        iconSize: 15,
        currentIndex: currentState,
        onTap: onTap,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: bottomNavItems);
  }
}
