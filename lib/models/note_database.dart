import 'package:isar/isar.dart';
import 'package:notes_app/models/note.dart';
import 'package:path_provider/path_provider.dart';


class NoteDatabase {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  final List<Note> currentNotes = [];

  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser;
    await isar.writeTxn(() => isar.notes.put(newNote));
    fetchNotes();

    Future<void> fetchNotes() async {
      List<Note> fetchedNotes = await isar.notes.where().findAll();
      currentNotes.clear();
      currentNotes.addAll(fetchedNotes);
    }
  }
}