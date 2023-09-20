import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/configs/app_alerts.dart';
import 'package:note_app/core/configs/hide_keyboard.dart';
import 'package:note_app/core/configs/validations.dart';
import 'package:note_app/core/helper/format.dart';
import 'package:note_app/data/model/note_model.dart';
import 'package:note_app/page/home_page/bloc/home_bloc.dart';
import 'package:note_app/page/main_page/main_page.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({Key? key}) : super(key: key);

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tạo ghi chú."),
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.edit_outlined,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
        body: GestureDetector(
          onTap: ()=>HideKeyBoard.hideKeyBoard(),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const SizedBox(height: 20),
                Text("1. Tiêu đề.",style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.black),),
                const SizedBox(height: 10),

                customTextFormField(
                    textEditingController: _titleController,
                    validator: Validator.validateTitle,
                    hintText: "Vui lòng nhập tiêu đề"),
                const SizedBox(height: 20),
                Text("2. Nội dung.",style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.black)),
                const SizedBox(height: 10),
                customTextFormField(
                    textEditingController: _contentController,
                    validator:Validator.validateContent,
                    maxLines: 8,
                    hintText: "Vui lòng nhập nội dung")
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          width: double.infinity,
          margin: const EdgeInsets.all(5),
          child: OutlinedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var date = DateTime.now();
                var note = NoteModel(
                    id: null,
                    title: StringFormat.capitalizedString(
                        _titleController.text.trim()),
                    note: StringFormat.capitalizedString(
                        _contentController.text.trim()),
                    date:StringFormat.dateFormatter(date));
                context.read<HomeBloc>().add(AddNote(noteModel: note));
                AppAlerts.displaySnackbar(context, "Tạo ghi chú thành công.");
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) => const MainPage()),
                    (Route route)=>false
                );
              }
            },
            child: Text("Lưu",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: Colors.black)),
          ),
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
