import 'package:vania/vania.dart';

class ProductNote extends Model {
  String? note_id;
  String? prod_id; // Foreign key
  DateTime? note_date;
  String? note_text;

  ProductNote({
    this.note_id,
    this.prod_id,
    this.note_date,
    this.note_text,
  }) {
    super.table('productnotes');
  }

  // Konversi dari JSON ke objek ProductNote
  factory ProductNote.fromJson(Map<String, dynamic> json) {
    return ProductNote(
      note_id: json['note_id'],
      prod_id: json['prod_id'],
      note_date: DateTime.parse(json['note_date']),
      note_text: json['note_text'],
    );
  }

  // Konversi dari objek ProductNote ke JSON
  Map<String, dynamic> toJson() {
    return {
      'note_id': note_id,
      'prod_id': prod_id,
      'note_date': note_date?.toIso8601String(),
      'note_text': note_text,
    };
  }
}
