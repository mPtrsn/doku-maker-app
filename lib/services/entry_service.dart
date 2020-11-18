import 'package:doku_maker/models/entries/project_entry.dart';
import 'package:doku_maker/screens/modals/new_image_entry_modal.dart';
import 'package:doku_maker/screens/modals/new_text_entry_modal.dart';
import 'package:flutter/material.dart';

Widget getModalForEntry(String type, String projectId, ProjectEntry entry) {
  switch (type) {
    case 'TEXT':
      return NewTextEntryModal(projectId, entry);
    case 'IMAGE':
      return NewImageEntryModal(projectId, entry);
    case 'VIDEO':

    case 'AUDIO':

    case 'SKETCH':

    case 'LINK':

    default:
      return null;
  }
}
