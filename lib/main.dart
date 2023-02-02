import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/database_provider.dart';
import 'package:flutter_application_1/model/note_model.dart';
import 'package:flutter_application_1/screens/add_note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: "/", routes: {
      "/": (context) => const HomeScreen(),
      "/addNote": (context) => const AddNote(),
    });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = SqliteServiceImp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<NoteModel>>(
        future: repo.fetchAllNotes(),
        builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.requireData.isNotEmpty) {
              /// чисто для примера
              return ListView.builder(
                itemCount: snapshot.requireData.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: Text(snapshot.requireData[index].id.toString()),
                    title: Text(snapshot.requireData[index].title),
                    trailing: Text(DateTime.fromMillisecondsSinceEpoch(
                            snapshot.requireData[index].creation_date)
                        .toString()),
                    subtitle: Wrap(children: [
                      Text(
                        snapshot.requireData[index].body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ]),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Empty'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () async {
          await Navigator.pushNamed(context, '/addNote');

          setState(() {});
        },
      ),
    );
  }
}
