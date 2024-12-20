import 'package:doku_maker/screens/dialogs/new_chip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class EditableChipList extends StatefulWidget {
  final String title;
  final Function(List<String> newChips) onDone;
  final List<String> chips;
  final List<String> inputs;
  final bool canEdit;

  const EditableChipList(
      {this.chips, this.onDone, this.title, this.inputs, this.canEdit = true});

  @override
  _EditableChipListState createState() => _EditableChipListState();
}

class _EditableChipListState extends State<EditableChipList> {
  bool isEditMode = false;

  List<String> newChips;

  @override
  void initState() {
    newChips = [];
    isEditMode = false;
    newChips.addAll(widget.chips);
    super.initState();
  }

  Future<bool> addChipDialog() async {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => NewChipDialog(
          title: widget.title,
          onSave: (String newValue) {
            setState(() {
              newChips.add(newValue);
            });
          }),
    ));
    return Future.value(true);
  }

  void _toggleEdit() {
    //widget.inputs == null means this widget is on the settings page
    if (widget.inputs == null) {
      setState(() {
        isEditMode = !isEditMode;
      });
      if (!isEditMode) {
        widget.onDone(newChips);
      }
    } else {
      if (widget.inputs.isNotEmpty) {
        var selectIn =
            widget.inputs.map((e) => MultiSelectItem<String>(e, e)).toList();

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          //backgroundColor: Colors.transparent,
          builder: (ctx) => MultiSelectBottomSheet(
              items: selectIn,
              title: Text("Tags"),
              initialValue: widget.chips,
              onConfirm: (values) {
                setState(() {
                  newChips = values.map((e) => e.toString()).toList();
                });
                widget.onDone(newChips);
              }),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'There are no Custom Tags to add!\nAdd Custom Tags in Project Settings!'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  List<Widget> get chipList {
    List<Widget> res = newChips
        .map(
          (e) => isEditMode
              ? ActionChip(
                  label: Text(e),
                  avatar: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      newChips.remove(e);
                    });
                  },
                )
              : Chip(label: Text(e)),
        )
        .toList();

    if (isEditMode) {
      res.add(ActionChip(
        label: Text("Add"),
        backgroundColor: Theme.of(context).accentColor,
        avatar: Icon(Icons.add),
        onPressed: addChipDialog,
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                Wrap(spacing: 4, children: chipList),
              ],
            ),
          ),
        ),
        if (widget.canEdit || widget.inputs != null)
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: _toggleEdit,
          )
      ],
    );
  }
}
