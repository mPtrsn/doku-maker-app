import 'package:doku_maker/models/project/project.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/screens/project/new_image_entry_modal.dart';
import 'package:doku_maker/screens/project/new_text_entry_modal.dart';
import 'package:doku_maker/screens/project/new_video_entry_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectDetailEntryButtons extends StatefulWidget {
  final Project project;

  const ProjectDetailEntryButtons({
    Key key,
    @required this.project,
  }) : super(key: key);

  @override
  _ProjectDetailEntryButtonsState createState() =>
      _ProjectDetailEntryButtonsState();
}

class _ProjectDetailEntryButtonsState extends State<ProjectDetailEntryButtons> {
  SearchMode searchMode = SearchMode.None;
  final GlobalKey<FormState> _formKey = GlobalKey();

  String _searchString;

  Widget _buildEntryButton(BuildContext ctx, IconData icon, Function onTab,
      [Color color]) {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: color == null ? Theme.of(ctx).accentColor : color,
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onTab,
      ),
    );
  }

  void searchChanged(String value) {
    setState(() {
      _searchString = value;
    });
    Provider.of<ProjectsProvider>(context, listen: false)
        .setSearchString(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (searchMode == SearchMode.None)
            _buildEntryButton(context, Icons.title, () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => NewTextEntryModal(widget.project.id));
            }),
          if (searchMode == SearchMode.None)
            _buildEntryButton(context, Icons.image, () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => NewImageEntryModal(widget.project.id));
            }),
          if (searchMode == SearchMode.None)
            _buildEntryButton(context, Icons.play_arrow, () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => NewVideoEntryModal(widget.project.id));
            }),
          if (searchMode == SearchMode.Searching)
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Search'),
                  textInputAction: TextInputAction.search,
                  onChanged: searchChanged,
                ),
              ),
            ),
          if (searchMode == SearchMode.Results) Text('Search: $_searchString'),
          _buildEntryButton(context,
              searchMode == SearchMode.Results ? Icons.close : Icons.search,
              () {
            if (searchMode == SearchMode.None) {
              setState(() {
                searchMode = SearchMode.Searching;
              });
            } else if (searchMode == SearchMode.Searching) {
              setState(() {
                searchMode = _searchString.isNotEmpty
                    ? SearchMode.Results
                    : SearchMode.None;
              });
            } else if (searchMode == SearchMode.Results) {
              setState(() {
                searchMode = SearchMode.None;
              });
              searchChanged('');
            }
          }, Theme.of(context).buttonColor),
        ],
      ),
    );
  }
}

enum SearchMode { None, Searching, Results }
