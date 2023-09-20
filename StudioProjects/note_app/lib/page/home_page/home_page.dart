import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/configs/app_alerts.dart';
import 'package:note_app/core/configs/sizes.dart';
import 'package:note_app/core/helper/format.dart';
import 'package:note_app/page/create_note_page/create_note_page.dart';
import 'package:note_app/page/detail_note/detail_note.dart';
import 'package:note_app/page/search_page/search_page.dart';

import '../../core/configs/enum.dart';
import '../../core/const/images_name.dart';
import '../../data/model/note_model.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ghi chú"),
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            children: [


              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  switch (state.homeStatus) {
                    case HomeStatus.failure:
                      return const EmptyNote();
                    case HomeStatus.initial:
                      return const Center(child: CircularProgressIndicator());
                    case HomeStatus.success:
                      if (state.listNote.isEmpty) {
                        return const EmptyNote();
                      } else {
                        return ListNote(listNote: state.listNote);
                      }
                  }
                },
              )
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateNotePage()));
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

class EmptyNote extends StatelessWidget {
  const EmptyNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Image.asset(ImageName.emtyNote)),
        Container(
          padding: const EdgeInsets.all(20),
          child: Text(
              "Danh sách ghi chú của bạn trống. Tạo ngay ghi chú mới nào !",
              style: Theme.of(context).textTheme.displayMedium),
        )
      ],
    );
  }
}

class ListNote extends StatelessWidget {
  final List<NoteModel> listNote;
  const ListNote({super.key, required this.listNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listNote.length,
        itemBuilder: (context, index) {
          var note = listNote[index];
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
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailNote(
                                  noteModel: note,
                                )));
                  },
                  child: AbsorbPointer(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.title ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontSize: 18)),
                      Divider(),
                      Text(note.note ?? "",
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  fontSize: 13,
                                  overflow: TextOverflow.ellipsis)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(note.date ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(fontSize: 11)),
                    ],
                  )),
                )),
                SizedBox(width: 10),
                Center(
                  child: IconButton(
                    onPressed: () {
                      AppAlerts.showAlertDeleteDialog(
                          context: context,
                          task: note,
                          pageEnum: PageEnum.notePage,
                          titleSnackBar: "Xoá ghi chú thành công."
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
