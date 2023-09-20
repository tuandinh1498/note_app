import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/configs/enum.dart';
import 'package:note_app/data/model/note_model.dart';
import 'package:note_app/page/create_remind_page/remind_bloc/remind_bloc.dart';
import 'package:note_app/page/home_page/bloc/home_bloc.dart';

class AppAlerts {
  const AppAlerts._();

  static displaySnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 600),
        content: Text(
          message,
        ),
      ),
    );
  }

  static Future<void> showAlertDeleteDialog(
      {required BuildContext context,
      required NoteModel task,
      PageEnum? pageEnum,
      String? titleSnackBar}) async {
    Widget cancelButton = TextButton(
      child: const Text('Thoát'),
      onPressed: () => Navigator.pop(context),
    );
    Widget deleteButton = TextButton(
      onPressed: () {
        deleteNote(context, titleSnackBar, pageEnum, task);
      },
      child: const Text('Xoá'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Bạn chắc chắn muốn xoá ghi chú này chứ ?'),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void deleteNote(BuildContext context, String? titleSnackBar,
      PageEnum? pageEnum, NoteModel task) {
    if (pageEnum == PageEnum.notePage) {
      context.read<HomeBloc>().add(DeleteNote(noteModel: task));
    } else if (pageEnum == PageEnum.remindPage) {
      context.read<RemindBloc>().add(DeleteRemind(remindModel: task));
    }
    displaySnackbar(
      context,
      titleSnackBar ?? "",
    );
    Navigator.pop(context);
  }
}
