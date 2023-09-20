class NoteModel{
  final int? id;
  final String? title;
  final String? note;
  final String? date;
  NoteModel({this.id, this.title, this.note, this.date});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json["id"],
      title: json["title"],
      note: json["note"],
      date: json["date"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "note": this.note,
      "date": this.date,
    };
  }

}