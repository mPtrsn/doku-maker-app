import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DokuVideoPicker extends StatefulWidget {
  final Function(File image) onSelected;
  final bool showPreview;
  const DokuVideoPicker(
      {Key key, @required this.onSelected, this.showPreview: true})
      : super(key: key);

  @override
  _DokuVideoPickerState createState() => _DokuVideoPickerState();
}

class _DokuVideoPickerState extends State<DokuVideoPicker> {
  File _newVideo;
  final _picker = ImagePicker();

  Future<void> _takeVideo(ImageSource source) async {
    PickedFile _imageFile = await _picker.getVideo(
      source: source,
    );
    setState(() {
      _newVideo = File(_imageFile.path);
    });
    widget.onSelected(_newVideo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: PopupMenuButton(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text(
                      "Add Video",
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              //icon: Icon(Icons.add),
              onSelected: (source) => _takeVideo(source),
              itemBuilder: (ctx) => [
                PopupMenuItem<ImageSource>(
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt),
                      Text('Make a Video'),
                    ],
                  ),
                  value: ImageSource.camera,
                ),
                PopupMenuItem<ImageSource>(
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      Text('Select a Video'),
                    ],
                  ),
                  value: ImageSource.gallery,
                ),
              ],
            ),
          ),
          if (_newVideo != null) Text("Video taken"),
        ],
      ),
    );
  }
}
