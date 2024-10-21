// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tp4/UI/list_student_dialog.dart';
import 'package:tp4/models/list_etudiants.dart';
import 'package:tp4/models/scol_list.dart';
import 'package:tp4/util/dbuse.dart';

class StudentsScreen extends StatefulWidget {
  final ScolList scolList;

  const StudentsScreen(this.scolList, {super.key});

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late dbuse helper;
  List<ListEtudiants>? students;

  @override
  Widget build(BuildContext context) {
    helper = dbuse();
    ListStudentDialog dialog = ListStudentDialog();
    showData(widget.scolList.codClass);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.scolList.nomClass),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white, // Access scolList through widget
        ),
        body: ListView.builder(
          itemCount: (students != null) ? students!.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(students![index].nom),
              onDismissed: (direction) {
                String strName = students![index].nom;
                helper.deleteStudent(students![index]);
                setState(() {
                  students!.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$strName deleted"),
                  ),
                );
              },
              child: ListTile(
                title: Text(students![index].nom),
                subtitle: Text(
                    'Prenom ${students![index].prenom}- date nais:${students?[index].datNais}'),
                onTap: () {},
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog.buildAlert(
                        context,
                        students![index],
                        false,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => dialog.buildAlert(
                  context,
                  ListEtudiants(
                    0,
                    widget.scolList.codClass,
                    '',
                    '',
                    '',
                  ),
                  true),
            );
          },
          backgroundColor: Colors.pink,
          child: const Icon(Icons.add),
        ));
  }

  Future showData(int idList) async {
    await helper.openDb();
    students = await helper.getEtudinats(idList);
    setState(() {
      students = students;
    });
  }
}
