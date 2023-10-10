import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/configs/app_alerts.dart';
import '../../../core/helper/format.dart';

import '../../../core/services.dart';
import '../../../data/model/note_model.dart';
import '../../../respository/res_impl/reminds.dart';
import '../../main_page/main_page.dart';

part 'remind_event.dart';
part 'remind_state.dart';

class RemindBloc extends Bloc<RemindEvent, RemindState> {
  RemindBloc()
      : super(RemindState(
            selectedDate: DateTime.now(), selectedTime: TimeOfDay.now())) {
    on<DateChange>(_onDateChange);
    on<TimeChange>(_onTimeChange);
    on<FetchRemind>(_onFetchReminds);
    on<AddRemind>(_onAddRemind);
    on<UpdateRemind>(_onUpdateRemind);
    on<DeleteRemind>(_onDeleteRemind);
    on<ClickAddRemind>(_onClickAddRemind);
  }
  final remindsResponsitory = RemindsImpl();
  final notifyService = NotificationService();
  _onDateChange(DateChange event, Emitter<RemindState> emitter) async {
    DateTime? dateTime = await showDatePicker(
      context: event.context,
      initialDate: state.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: 'Vui lòng chọn ngày',
      // builder: (context, child) {
      //   return Theme(
      //     data: Theme.of(context).copyWith(
      //       colorScheme: ColorScheme.light(
      //         primary: Colors.amberAccent, // <-- SEE HERE
      //         onPrimary: Colors.redAccent, // <-- SEE HERE
      //         onSurface: Colors.blueAccent, // <-- SEE HERE
      //       ),
      //       textButtonTheme: TextButtonThemeData(
      //         style: TextButton.styleFrom(
      //           primary: Colors.red, // button text color
      //         ),
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
    );

    if (dateTime != null) {
      emitter(RemindState().copyWith(
          selectedDate: dateTime,
          datePickerState: DatePickerState.dateSelected));
    }
  }

  _onTimeChange(TimeChange event, Emitter<RemindState> emitter) async {
    TimeOfDay? time = await showTimePicker(
      context: event.context,
      initialTime: TimeOfDay.now(),
    );
    double doubleYourTime =
        time!.hour.toDouble() + (time.minute.toDouble() / 60);
    double doubleNowTime = TimeOfDay.now().hour.toDouble() +
        (TimeOfDay.now().minute.toDouble() / 60);
    if (doubleNowTime < doubleYourTime) {
      DateTime selectedDateTime = state.selectedDate ?? DateTime.now();
      emitter(RemindState(
          selectedTime: time,
          selectedDate:
              selectedDateTime.copyWith(hour: time.hour, minute: time.minute)));
    } else {
      showSnackBar(event.context,
          "Vui lòng chọn giờ sau thời gian hiện tại để hiển thị thông báo cho nhắc nhở!");
    }
  }

  Future<void> _onFetchReminds(
      FetchRemind event, Emitter<RemindState> emitter) async {
    emitter(RemindState().copyWith(remindGetStatus: RemindGetStatus.initial));
    final listReminds = await getListReminds();
    // listTasks.forEach((element) { print(element.id);});
    // print(listTasks.first.toJson());
    emitter(RemindState().copyWith(
        remindGetStatus: RemindGetStatus.success, listReminds: listReminds));
  }

  Future<void> _onUpdateRemind(
      UpdateRemind event, Emitter<RemindState> emitter) async {
    await remindsResponsitory.updateReminds(event.remindModel);
    final listReminds = await getListReminds();
    emitter(RemindState().copyWith(
        remindStatus: RemindStatus.update,
        remindGetStatus: RemindGetStatus.success,
        listReminds: listReminds));

  }

  Future<void> _onAddRemind(
      AddRemind event, Emitter<RemindState> emitter) async {
    await remindsResponsitory.insertReminds(event.remindModel);
    final listReminds = await getListReminds();
    emitter(RemindState().copyWith(
        remindStatus: RemindStatus.add,
        remindGetStatus: RemindGetStatus.success,
        listReminds: listReminds));
    var remind = listReminds.first;

    DateTime? dateTime =
        DateFormat('dd/MM/yyyy HH:mm').parse(remind.date ?? "");

    await notifyService.scheduleNotifications(
      id: remind.id ?? 0,
      title: remind.title ?? "",
      body: remind.note ?? "",
      scheduledNotificationDateTime: dateTime,
    );
    // _onFetchReminds;
  }

  Future<void> _onDeleteRemind(
      DeleteRemind event, Emitter<RemindState> emitter) async {
    await remindsResponsitory.deleteReminds(event.remindModel);
    final listReminds = await getListReminds();
    emitter(RemindState().copyWith(
        remindStatus: RemindStatus.delete,
        remindGetStatus: RemindGetStatus.success,
        listReminds: listReminds));

    await notifyService.cancelNotifications(event.remindModel.id ?? 0);
    // _onFetchReminds;
  }

  Future<List<NoteModel>> getListReminds() async =>
      remindsResponsitory.loadReminds();

  _onClickAddRemind(ClickAddRemind event, Emitter<RemindState> emitter) async {
    if (event.formKey.currentState!.validate()) {
      var dateSelected = state.selectedDate;
      var timeSelected = state.selectedTime;
      if (dateSelected == null) {
        showSnackBar(event.context,
            "Vui lòng chọn ngày tháng để hiển thị thông báo cho nhắc nhở!");
      } else if (timeSelected == null) {
        showSnackBar(event.context,
            "Vui lòng chọn giờ để hiển thị thông báo cho nhắc nhở!");
      } else {
        createRemind(dateSelected, event.context, event.title, event.note);
      }
    }
  }

  void showSnackBar(BuildContext context, String title) {
    AppAlerts.displaySnackbar(context, title);
  }

  void createRemind(
      DateTime dateSelected, BuildContext context, String title, String note) {
    var noteModel = NoteModel(
        title: StringFormat.capitalizedString(title),
        note: StringFormat.capitalizedString(note),
        date: StringFormat.dateFormatter(dateSelected));
    context.read<RemindBloc>().add(AddRemind(remindModel: noteModel));
    AppAlerts.displaySnackbar(context, "Tạo ghi chú thành công.");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
        (Route route) => false);
  }
}
