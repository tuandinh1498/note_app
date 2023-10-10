import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/configs/app_alerts.dart';
import 'package:note_app/data/model/note_model.dart';
import 'package:note_app/page/detail_note/detail_note.dart';
import 'bloc/search_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(InitialNote());
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();

  }

  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _timeC = TextEditingController();

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now();
  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2100);
  final _dateC = TextEditingController();
  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: initial,
      lastDate: last,
    );

    if (date != null&&date.isAfter(DateTime.now())) {
      setState(() {
        _dateC.text = date.toLocal().toString().split(" ")[0];
        print(selected.toString());
        selected=date;
        print(selected.toString());
      });

    }else{
      AppAlerts.displaySnackbar(context, "Vui long chhon lai");
    }
  }



  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Tìm kiếm ghi chú"),
            actions: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon:Icon(Icons.arrow_back))
            ],
          ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [

              TextFormField(
                controller: _searchController,
                onChanged: (String value){
                  if(value.trim().isEmpty){
                    context.read<SearchBloc>().add(DisposeNote());
                    // context.read<SearchBloc>().add(SearchNote(searchValue:""));
                  }else{
                    context.read<SearchBloc>().add(SearchNote(searchValue:value.toLowerCase()));
                  }

                },
                onEditingComplete: (){
                  // context.read<SearchBloc>().add(SearchNote(searchValue:_searchController.text.toLowerCase()));
                },
                onFieldSubmitted: (search) {

                },
                decoration: InputDecoration(
                    hintText: "Tìm kiếm ghi chú theo tiêu đề",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide:
                        BorderSide(color: Colors.blueAccent, width: 1.0))),
              ),



              BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    switch (state.statusSearch) {
                      case SearchStatus.failure:
                        return const SizedBox(
                            height: 300,
                            child: Center(child: Text('Không tìm thấy ghi chú')));
                      case SearchStatus.success:
                        if(state.listSearchNote.isEmpty){
                          return const SizedBox(
                              height: 300,
                              child: Center(child: Text('Không tìm thấy ghi chú')));
                        }else{
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return NoteListItem(note: state.listSearchNote[index]);
                            },
                            itemCount: state.listSearchNote.length,
                          );
                        }

                      case SearchStatus.initial:
                        return  const SizedBox(
                          height: 300,
                            child: Center(child: Text('Hãy nhập từ khoá để tìm kiếm ghi chú')));
                    }
                  }
              )
            ],
          ),
        )
      ),
    );
  }
}




class NoteListItem extends StatelessWidget {
  const NoteListItem({required this.note, super.key});

  final NoteModel note;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailNote(noteModel: note)));
      },
      child: AbsorbPointer(
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Material(
            child: ListTile(
              // leading: Text('${note.id}', style: textTheme.bodySmall),
              title: Text(note.title ?? "",style:Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 18,color: Colors.black),),
              isThreeLine: true,
              subtitle: Text("${note.note}",style:Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 14)),
              trailing: Text("${note.date}",style:Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 12)),
              dense: true,
            ),
          ),
        ),
      )
    );
  }
}
