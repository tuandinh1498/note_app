part of 'remind_bloc.dart';

enum DatePickerState {
  initial,
  dateSelected,
}

enum TimePickerState {
  initial,
  timeSelected,
}

enum RemindGetStatus { initial, success, failure }

enum RemindStatus { initial, add, delete, update }

class RemindState extends Equatable {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DatePickerState datePickerState;
  TimePickerState timePickerState;
  RemindGetStatus remindGetStatus;
  final List<NoteModel> listReminds;

  RemindStatus remindStatus;
  RemindState(
      {this.selectedDate,
      this.selectedTime,
      this.timePickerState = TimePickerState.initial,
      this.datePickerState = DatePickerState.initial,
      this.remindGetStatus = RemindGetStatus.initial,
      this.remindStatus = RemindStatus.initial,
      this.listReminds=const <NoteModel>[]});

  RemindState copyWith({
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    DatePickerState? datePickerState,
    TimePickerState? timePickerState,
    RemindGetStatus? remindGetStatus,
    RemindStatus? remindStatus,
    final List<NoteModel>? listReminds,
  }) {
    return RemindState(
      selectedTime: selectedTime ?? this.selectedTime,
        selectedDate: selectedDate ?? this.selectedDate,
        datePickerState: datePickerState ?? this.datePickerState,
      timePickerState: timePickerState ?? this.timePickerState,
      remindGetStatus: remindGetStatus ?? this.remindGetStatus,
      remindStatus: remindStatus ?? this.remindStatus,
      listReminds: listReminds??this.listReminds
    );
  }

  @override
  List<Object> get props => [
        selectedDate ?? DateTime.now(),
        selectedTime ?? TimeOfDay.now(),
        datePickerState,
        timePickerState,
        remindGetStatus,
        remindStatus,
        listReminds
      ];
}
