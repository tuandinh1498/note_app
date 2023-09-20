part of 'remind_bloc.dart';

@immutable
abstract class RemindEvent {
  const RemindEvent();
}

class DateChange extends RemindEvent{
  final BuildContext context;
  // final DateTime dateTime;
  const DateChange({required this.context
    // ,required this.dateTime
  });
}
class TimeChange extends RemindEvent{
  final BuildContext context;
  const TimeChange({required this.context

  });
}

class FetchRemind extends RemindEvent{}

class UpdateRemind extends RemindEvent{
  final NoteModel remindModel;
  const UpdateRemind({required this.remindModel});
}

class AddRemind extends RemindEvent{
  final NoteModel remindModel;
  const AddRemind({required this.remindModel});
}

class DeleteRemind extends RemindEvent{
  final NoteModel remindModel;
  const DeleteRemind({required this.remindModel});
}
