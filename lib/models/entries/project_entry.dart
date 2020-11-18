import 'package:flutter/material.dart';

class ProjectEntry {
  final String id;
  final String title;
  final List<String> tags;
  final DateTime creationDate;

  const ProjectEntry(
    this.id,
    this.title,
    this.tags,
    this.creationDate,
  );

  Widget get displayWidget {
    return null;
  }

  Widget bottomSheet(String projectId) {
    return null;
  }

  Map<String, dynamic> toJson() => null;
}
