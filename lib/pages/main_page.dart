// SPDX-License-Identifier: AGPL-3.0-or-later
/*
    Copyright (C) 2021  Equipe EmptyCoffeeCups

    This file is part of NotoriousNote.

    NotoriousNote is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    NotoriousNote is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with NotoriousNote.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../services/database.dart';
import 'note_editor.dart';

class MainPage extends StatefulWidget {
  final Database database;

  const MainPage({Key key, this.database}) : super(key: key);

  static Future<void> show(BuildContext context, {Database database}) async {
    database = (database == null)
        ? Provider.of<Database>(context, listen: false)
        : database;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MainPage(database: database),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContents(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await NoteEditor.show(context);
          setState(() {});
        },
        tooltip: "New note",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return FutureBuilder<List<NoteModel>>(
      future: widget.database.listNotes(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final List<NoteModel> items = snapshot.data;
          if (items.isNotEmpty) {
            return ListView.separated(
                itemBuilder: (context, index) => Card(
                        child: InkWell(
                      splashColor: Colors.grey,
                      onTap: () => print("Note ${items[index].id} selected"),
                      child: Column(
                        children: <Widget>[
                          Text(
                            items[index].title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(items[index].content),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await widget.database
                                        .deleteNote(items[index].id);
                                    setState(() {});
                                  }),
                              IconButton(
                                  icon: Icon(Icons.archive), onPressed: null),
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    await NoteEditor.show(context,
                                        noteModel: items[index]);
                                    setState(() {});
                                  })
                            ],
                          )
                        ],
                      ),
                    )),
                separatorBuilder: (context, index) => Divider(
                      height: 0.5,
                    ),
                itemCount: items.length);
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text("No notes"), Text("Please add a note")],
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
