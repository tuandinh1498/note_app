import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/page/create_remind_page/remind_bloc/remind_bloc.dart';

import '../../core/configs/app_alerts.dart';
import '../../core/configs/hide_keyboard.dart';
import '../../core/configs/validations.dart';
import '../../core/helper/format.dart';
import '../../data/model/note_model.dart';
import '../main_page/main_page.dart';

class RemindPage extends StatefulWidget {
  const RemindPage({Key? key}) : super(key: key);

  @override
  State<RemindPage> createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo nhắc nhở."),
        actions: [
// IconButton(
//   onPressed: () {
//     Navigator.pop(context);
//   },
//   icon: const Icon(
//     Icons.edit_outlined,
//     color: Colors.black,
//   ),
// ),
        ],
      ),
      body: GestureDetector(
        onTap: () => HideKeyBoard.hideKeyBoard(),
        child: Form(
            key: _formKey,
            child: BlocBuilder<RemindBloc, RemindState>(
              builder: (context, state) {
                return ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "1. Tiêu đề.",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    customTextFormField(
                        textEditingController: _titleController,
                        validator: Validator.validateTitle,
                        hintText: "Vui lòng nhập tiêu đề"),
                    const SizedBox(height: 20),
                    Text("2. Nội dung.",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: Colors.black)),
                    const SizedBox(height: 10),
                    customTextFormField(
                        textEditingController: _contentController,
                        validator: Validator.validateContent,
                        maxLines: 8,
                        hintText: "Vui lòng nhập nội dung"),
                    const SizedBox(height: 20),
                    Text(
                        "3.Chọn ngày để tạo thời gian thông báo nhắc nhở (Chọn giờ sau thời gian hiện tại để hiển thị thông báo cho nhắc nhở.)",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: Colors.black)),
                    const SizedBox(height: 10),
                    state.selectedDate == null
                        ? const Text("Vui lòng chọn ngày")
                        : Text(
                            'Ngày được chọn là: ${StringFormat.dateFormatter(state.selectedDate ?? DateTime.now())}',
                            style: Theme.of(context).textTheme.displayMedium),
                    OutlinedButton(
                      onPressed: () => context
                          .read<RemindBloc>()
                          .add(DateChange(context: context)),
                      child: Text('Chọn ngày',
                          style: Theme.of(context).textTheme.displayMedium),
                    ),
                    SizedBox(height: 20),
                    state.selectedTime == null
                        ? const Text("Vui lòng chọn giờ ")
                        : Text(
                            'Giờ được chọn là: ${StringFormat.formatTimeOfDay(state.selectedTime ?? TimeOfDay.now())}',
                            style: Theme.of(context).textTheme.displayMedium),
                    OutlinedButton(
                      onPressed: () => context
                          .read<RemindBloc>()
                          .add(TimeChange(context: context)),
                      child: Text('Chọn giờ',
                          style: Theme.of(context).textTheme.displayMedium),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              },
            )),
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        margin: const EdgeInsets.all(5),
        child: OutlinedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              var dateSelected = context.read<RemindBloc>().state.selectedDate;
              var timeSelected = context.read<RemindBloc>().state.selectedTime;
              if (dateSelected == null) {
                AppAlerts.displaySnackbar(context,
                    "Vui lòng chọn ngày tháng để hiển thị thông báo cho nhắc nhở!");
              } else if (timeSelected == null) {
                AppAlerts.displaySnackbar(context,
                    "Vui lòng chọn giờ để hiển thị thông báo cho nhắc nhở!");
              } else {
                createRemind(dateSelected, context);
              }
            }
          },
          child: Text("Lưu",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.black)),
        ),
      ),
    );
  }

  void createRemind(DateTime dateSelected, BuildContext context) {
    var note = NoteModel(
        title: StringFormat.capitalizedString(
            _titleController.text.trim()),
        note: StringFormat.capitalizedString(
            _contentController.text.trim()),
        date: StringFormat.dateFormatter(dateSelected!));
    context.read<RemindBloc>().add(AddRemind(remindModel: note));
    AppAlerts.displaySnackbar(context, "Tạo ghi chú thành công.");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
        (Route route) => false);
  }

  Widget customTextFormField(
      {String? hintText,
      int? maxLines,
      String? Function(String?)? validator,
      required TextEditingController textEditingController}) {
    return TextFormField(
      controller: textEditingController,
      maxLines: maxLines,
      validator: validator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide:
                  const BorderSide(color: Colors.blueAccent, width: 1.0))),
    );
  }
}
