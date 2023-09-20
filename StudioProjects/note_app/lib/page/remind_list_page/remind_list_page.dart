import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/configs/enum.dart';
import 'package:note_app/core/helper/format.dart';
import 'package:note_app/data/model/note_model.dart';
import 'package:note_app/page/home_page/home_page.dart';
import 'package:note_app/page/search_page/search_page.dart';

import '../../core/configs/app_alerts.dart';
import '../../core/const/images_name.dart';
import '../create_remind_page/create_remind_page.dart';
import '../create_remind_page/remind_bloc/remind_bloc.dart';

class RemindListPage extends StatefulWidget {
  const RemindListPage({Key? key}) : super(key: key);

  @override
  State<RemindListPage> createState() => _RemindListPageState();
}

class _RemindListPageState extends State<RemindListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nhắc nhở"),
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            children: [
              BlocBuilder<RemindBloc, RemindState>(
                builder: (context, state) {
                  switch (state.remindGetStatus) {
                    case RemindGetStatus.failure:
                      return const EmptyRemind();
                    case RemindGetStatus.initial:
                      return const Center(child: CircularProgressIndicator());
                    case RemindGetStatus.success:
                      if(state.listReminds.isEmpty){
                        return const EmptyRemind();
                      }else{
                        return ListRemind(listRemind: state.listReminds);
                      }

                  }
                },
              )
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RemindPage()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class EmptyRemind extends StatelessWidget {
  const EmptyRemind({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Image.asset(ImageName.emtyNote)),
        Container(
          padding: const EdgeInsets.all(20),
          child: Text(
              "Danh sách nhắc của bạn trống. Tạo ngay nhắc nhở nào !",
              style: Theme.of(context).textTheme.displayMedium),
        )
      ],
    );
  }
}

class ListRemind extends StatelessWidget {
  final List<NoteModel> listRemind;
  const ListRemind({super.key, required this.listRemind});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listRemind.length,
        itemBuilder: (context, index) {
          var remind = listRemind[index];
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(right: 5, left: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailRemind(RemindModel: Remind,)));
                  },
                  child: AbsorbPointer(child:

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(remind.title ?? "",style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 18)),
                      Divider(),
                      Text(remind.note ?? "",
                          maxLines: 2,
                          style:Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 13,overflow: TextOverflow.ellipsis)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(remind.date??"",style:Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 11)),
                    ],
                  )),
                )),
                SizedBox(width: 10),
                Center(
                  child: IconButton(
                    onPressed: () {

                      AppAlerts.showAlertDeleteDialog(
                          context: context,
                          task: remind,
                          pageEnum: PageEnum.remindPage,
                          titleSnackBar: "Xoá nhắc nhở thành công."
                      );

                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

