import 'package:doku_maker/provider/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteProjectDialog extends StatefulWidget {
  final String id;
  final String projectName;

  const DeleteProjectDialog({this.id, this.projectName});

  @override
  _DeleteProjectDialogState createState() => _DeleteProjectDialogState();
}

class _DeleteProjectDialogState extends State<DeleteProjectDialog> {
  final _form = GlobalKey<FormState>();

  Future _saveForm() async {
    if (_form.currentState.validate()) {
      Navigator.of(context).pushReplacementNamed("/");
      await Provider.of<ProjectsProvider>(context, listen: false)
          .deleteProject(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete this project?'),
      ),
      body: Container(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _form,
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text:
                      "Enter the project title and confirm to delete the project.\n\nThe project title is: ",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  children: [
                    TextSpan(
                        text: '${widget.projectName}',
                        style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Project Title'),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  return widget.projectName == value
                      ? null
                      : 'Enter the Project Title';
                },
                onSaved: (newValue) {},
              ),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text("Confirm"),
                style: TextButton.styleFrom(
                    primary: Theme.of(context).accentColor),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
