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

import 'pages/main_page.dart';
import 'services/database.dart';
import 'services/sqlite_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Database>(
      create: (_) => SQLiteDatabase.instance,
      builder: (context, widget) => MaterialApp(
        title: "NotoriousNote",
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: FutureBuilder(
          future: Provider.of<Database>(context, listen: false).init(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MainPage(
                  database: Provider.of<Database>(context, listen: false));
            } else if (snapshot.hasError) {
              return Container(
                child: Column(children: <Widget>[
                  Icon(Icons.error),
                  Text(snapshot.error.toString()),
                ]),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
