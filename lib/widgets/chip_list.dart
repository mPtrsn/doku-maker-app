import 'package:doku_maker/widgets/new_chip_modal.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class EditableChipList extends StatefulWidget {
  final String title;
  final Function(List<String> newChips) onDone;
  final List<String> chips;
  final List<String> inputs;

  const EditableChipList({this.chips, this.onDone, this.title, this.inputs});

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

  Future<bool> addChipModal() async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => NewChipModal(
          title: widget.title,
          onSave: (String newValue) {
            setState(() {
              newChips.add(newValue);
            });
          }),
    );
  }

  void _toggleEdit() {
    if (widget.inputs == null) {
      setState(() {
        isEditMode = !isEditMode;
      });
      if (!isEditMode) {
        widget.onDone(newChips);
      }
    } else {
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
    }
  }

  List<Widget> get chipList {
    List res = newChips
        .map(
          (e) => isEditMode
              ? Chip(
                  label: Text(e),
                  deleteIcon: Icon(Icons.delete),
                  onDeleted: () {
                    setState(() {
                      newChips.remove(e);
                    });
                  },
                )
              : Chip(label: Text(e)),
        )
        .toList();
    if (isEditMode) {
      res.add(Chip(
        label: Text("Add"),
        backgroundColor: Theme.of(context).accentColor,
        deleteIcon: Icon(Icons.add),
        onDeleted: () {
          return addChipModal();
        },
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
        IconButton(
          icon: Icon(isEditMode ? Icons.save : Icons.edit),
          onPressed: _toggleEdit,
        )
      ],
    );
  }
}
