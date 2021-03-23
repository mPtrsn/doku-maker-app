import 'package:flutter/material.dart';

class EditAbleText extends StatefulWidget {
  final Function(String text) onChange;
  final Function onSave;
  final String text;
  final TextStyle style;

  const EditAbleText(
    this.text, {
    Key key,
    @required this.onChange,
    this.onSave,
    this.style,
  }) : super(key: key);
  @override
  _EditAbleTextState createState() => _EditAbleTextState();
}

class _EditAbleTextState extends State<EditAbleText> {
  bool _isEdit = false;

  void enableEdit() {
    setState(() {
      _isEdit = true;
    });
  }

  void _onSave() {
    widget.onSave();
    setState(() {
      _isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isEdit
          ? Row(
              children: [
                Container(
                  width: 300,
                  child: Form(
                    child: TextFormField(
                      initialValue: widget.text,
                      onChanged: widget.onChange,
                      autofocus: true,
                      onEditingComplete: () => _onSave(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: _onSave,
                )
              ],
            )
          : Row(
              children: [
                widget.style == null
                    ? Expanded(
                        child: Text(
                          widget.text,
                        ),
                      )
                    : Expanded(
                        child: Text(
                          widget.text,
                          style: widget.style,
                        ),
                      ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: enableEdit,
                )
              ],
            ),
    );
  }
}
