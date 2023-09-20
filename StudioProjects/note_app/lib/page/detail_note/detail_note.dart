import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/configs/validations.dart';
import 'package:note_app/data/model/note_model.dart';
import 'package:note_app/page/main_page/app_trigger/app_trigger__bloc.dart';

import '../../core/configs/app_alerts.dart';
import '../../core/configs/hide_keyboard.dart';
import '../../core/helper/format.dart';
import '../home_page/bloc/home_bloc.dart';
import '../main_page/main_page.dart';

class DetailNote extends StatelessWidget {
  final NoteModel noteModel;
  const DetailNote({Key? key,required this.noteModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết ghi chú"),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);

          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [

          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => FullScreenDialog(noteModel: noteModel),
                  fullscreenDialog: true,
                ),

              );
            },
              icon:const Icon(Icons.edit,color: Colors.black,)
          )
        ],

      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
        children: [
           Center(child: Text(noteModel.title?? "",style: Theme.of(context).textTheme.displayLarge)),
          const SizedBox(height: 10,),
          Text("Ngày tạo: ${noteModel.date?? ""}"),
          const SizedBox(height: 20,),
          Text(noteModel.note?? "",style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 18,color: Colors.black)),
        ],
      ),
    );
  }
}

class FullScreenDialog extends StatefulWidget {
  final NoteModel noteModel;
  const FullScreenDialog({super.key,required this.noteModel});

  @override
  State<FullScreenDialog> createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _titleController.text=widget.noteModel.title??"";
    _contentController.text=widget.noteModel.note ??"";
    super.initState();
  }
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
        title: Text('Chỉnh sửa'),
      ),
      body: GestureDetector(
        onTap: ()=>HideKeyBoard.hideKeyBoard(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [

              Text("1. Tiêu đề.",style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.black),),
              const SizedBox(height: 10),
              customTextFormField(
                  textEditingController: _titleController,
                  validator: Validator.validateTitle
              ),

              const SizedBox(height: 20),
              Text("2. Nội dung.",style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.black)),


              const SizedBox(height: 10),
              customTextFormField(
                  textEditingController: _contentController,
                validator: Validator.validateContent,
                  maxLines: 8,
                  )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        margin: const EdgeInsets.all(5),
        child: OutlinedButton(onPressed: () {
          if (_formKey.currentState!.validate()) {
            var date = DateTime.now();
            var note = NoteModel(
                id: widget.noteModel.id,
                title: StringFormat.capitalizedString(
                    _titleController.text.trim()),
                note: StringFormat.capitalizedString(
                    _contentController.text.trim()),
                date: StringFormat.dateFormatter(date)

            );
            context.read<HomeBloc>().add(UpdateNote(noteModel: note));
         AppAlerts.displaySnackbar(context, "Sửa đổi ghi chú thành công.");
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_) => const MainPage()), (
                Route route) => false);
            context.read<AppTriggerBloc>().add(TabChange(tabIndex: 0));
          }
        }
          , child: Text("Lưu",style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black)),

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
      keyboardType: TextInputType.text,
      validator: validator,
      decoration: InputDecoration(
          hintText: hintText,

          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                  color: Colors.blueAccent, width: 1.0))),
    );
  }
}
