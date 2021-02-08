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
      Navigator.of(context).pushReplacementNamed("/");
      await Provider.of<ProjectsProvider>(context, listen: false)
          .deleteProject(widget.id);
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
