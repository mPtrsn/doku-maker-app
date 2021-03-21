import 'package:flutter/material.dart';

class ProjectEntry {
  final String id;
  final String title;
  List<String> tags;
  final DateTime creationDate;
  final String author;

  ProjectEntry(
    this.id,
    this.title,
    this.tags,
    this.creationDate,
    this.author,
  );

  Widget get displayWidget {
    return null;
  }

  get text => null;

  Widget bottomSheet(String projectId) {
    return null;
  }

  Map<String, dynamic> toJson() => null;
}
