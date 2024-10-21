// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp4/UI/dialog.dart';
import 'package:tp4/UI/students_screen.dart';
import 'package:tp4/models/list_etudiants.dart';
import 'package:tp4/models/scol_list.dart';
import 'package:tp4/util/dbuse.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Class List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ShList());
  }
}

class ShList extends StatefulWidget {
  const ShList({super.key});

  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ScolList> scolList = [];
  dbuse helper = dbuse();

  @override
  Widget build(BuildContext context) {
    ScolListDialog dialog = ScolListDialog();

    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes list'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: (scolList != null) ? scolList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(scolList[index].nomClass),
            onDismissed: (direction) {
              String strName = scolList[index].nomClass;
              helper.deleteList(scolList[index]);
              setState(() {
                scolList.removeAt(index);
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$strName deleted")));
            },
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentsScreen(scolList[index]),
                  ),
                );
              },
              title: Text(scolList[index].nomClass),
              leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  child: Text(scolList[index].codClass.toString())),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          dialog.builedDialog(context, scolList[index], false));
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
            builder: (BuildContext context) =>
                dialog.builedDialog(context, ScolList(0, '', 0), true),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Future showData() async {
  //   await helper.openDb();
  //   ScolList list1 = ScolList(11, "DSI31", 30);
  //   int ClassId1 = await helper.insertClass(list1);
  //   ScolList list2 = ScolList(12, "DSI32", 30);
  //   int ClassId2 = await helper.insertClass(list2);

  //   ScolList list3 = ScolList(13, "DSI33", 30);
  //   int ClassId3 = await helper.insertClass(list3);
  //   String dateStart = '22-04-2021';
  //   DateFormat inputFormat = DateFormat('dd-MM-yyyy');
  //   DateTime input = inputFormat.parse(dateStart);
  //   String datee = DateFormat('dd-MM-yy').format(input);
  //   final DateTime now = DateTime.now();
  //   final DateFormat formatter = DateFormat('yyyy-MM-dd');
  //   final String formatted = formatter.format(now);
  //   ListEtudiants etud =
  //       ListEtudiants(1, ClassId1, "Ali", "Ben Mohamed", datee);
  //   int etudId1 = await helper.insertEtudiants(etud);
  //   print('classe Id: ' + ClassId1.toString());
  //   print('etudiant Id: ' + etudId1.toString());
  //   etud = ListEtudiants(2, ClassId2, "Salah", "Ben Salah", datee);
  //   etudId1 = await helper.insertEtudiants(etud);
  //   etud = ListEtudiants(3, ClassId2, "Slim", "Ben Slim", datee);
  //   etudId1 = await helper.insertEtudiants(etud);
  //   etud = ListEtudiants(4, ClassId3, "Foulen", "Ben Foulen", datee);
  //   etudId1 = await helper.insertEtudiants(etud);
  // }
  Future showData() async {
    await helper.openDb();
    scolList = await helper.getClasses();
    setState(() {
      scolList = scolList;
    });
  }
}
