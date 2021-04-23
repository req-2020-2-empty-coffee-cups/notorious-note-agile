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

class NoteModel {
  final int id;
  final String title;
  final String content;
  final String creation;
  final int archived;

  NoteModel(
      {this.id,
      @required this.title,
      @required this.content,
      this.creation,
      this.archived})
      : assert(title != null || content != null);

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "title": this.title,
      "content": this.content,
      "creation": this.creation,
      "archived": this.archived
    };
  }

  // Return null on null data, new instance if data is not null
  factory NoteModel.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    final int id = data["id"];
    final String title = data["title"];
    final String content = data["content"];
    final String creation = data["creation"];
    final int archived = data["archived"];

    return NoteModel(
        id: id,
        title: title,
        content: content,
        creation: creation,
        archived: archived);
  }
}
