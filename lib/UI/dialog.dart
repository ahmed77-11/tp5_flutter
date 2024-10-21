import 'package:flutter/material.dart';
import 'package:tp4/models/scol_list.dart';
import 'package:tp4/util/dbuse.dart';

class ScolListDialog {
  final txtNonClass = TextEditingController();
  final txtNbreEtud = TextEditingController();
  Widget builedDialog(BuildContext context, ScolList list, bool isNew) {
    dbuse helper = dbuse();
    if (!isNew) {
      txtNonClass.text = list.nomClass;
      txtNbreEtud.text = list.nbreEtud.toString();
    }
    return AlertDialog(
      title: Text((isNew) ? 'class list' : 'Edit class list'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtNonClass,
              decoration: const InputDecoration(hintText: 'class list name'),
            ),
            TextField(
              controller: txtNbreEtud,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'class list number of student'),
            ),
            ElevatedButton(
              child: const Text("save class list "),
              onPressed: () {
                list.nomClass = txtNonClass.text;
                list.nbreEtud = int.parse(txtNbreEtud.text);
                helper.insertClass(list);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
