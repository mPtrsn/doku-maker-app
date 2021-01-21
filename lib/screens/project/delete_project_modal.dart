import 'package:doku_maker/provider/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteProjectModal extends StatefulWidget {
  final String id;
  final String projectName;

  const DeleteProjectModal({this.id, this.projectName});

  @override
  _DeleteProjectModalState createState() => _DeleteProjectModalState();
}

class _DeleteProjectModalState extends State<DeleteProjectModal> {
  final _form = GlobalKey<FormState>();

  Future _saveForm() async {
    if (_form.currentState.validate()) {
      await Provider.of<ProjectsProvider>(context, listen: false)
          .deleteProject(widget.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _form,
            child: Column(children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Project Name'),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  return widget.projectName == value
                      ? null
                      : 'Enter the Project Name';
                },
                onSaved: (newValue) {},
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
