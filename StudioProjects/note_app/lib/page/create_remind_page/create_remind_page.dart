import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/page/create_remind_page/remind_bloc/remind_bloc.dart';
import '../../core/configs/hide_keyboard.dart';
import '../../core/configs/validations.dart';
import '../../core/helper/format.dart';


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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 8),
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
            context.read<RemindBloc>().add(ClickAddRemind(
                context: context,
                formKey: _formKey,
                title: _titleController.text.trim(),
                note: _contentController.text.trim()));


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
