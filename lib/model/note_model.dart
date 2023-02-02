
class NoteModel {
  int id;
  String title;
  String body;
  int creation_date;

  NoteModel(
      {required this.id, required this.body, required this.title, required this.creation_date});

  factory NoteModel.fromMap(Map<String, Object?> data) {
    return NoteModel(
        id: data['id'] as int,
        body: data['body'] as String,
        title: data['title'] as String,
        creation_date: data['creation_date'] as int);
  }

  Map<String, dynamic> toMap() {
    return ({"id": id, "title": title, "body": body, "creation_date": creation_date.toString()});
  }
}
