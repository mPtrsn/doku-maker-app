import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DokuImagePicker extends StatefulWidget {
  const DokuImagePicker({Key key, @required this.onSelected}) : super(key: key);

  @override
  _DokuImagePickerState createState() => _DokuImagePickerState();

  final Function onSelected;
}

class _DokuImagePickerState extends State<DokuImagePicker> {
  File _newImage;
  final _picker = ImagePicker();

  Future<void> _takePicture(ImageSource source) async {
    PickedFile _imageFile = await _picker.getImage(
      source: source,
      maxWidth: 600,
    );
    setState(() {
      _newImage = File(_imageFile.path);
    });
    widget.onSelected(_newImage);
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _newImage != null
              ? Container(
                  child: Image.file(
                    _newImage,
                    width: device.width * 0.35,
                    height: device.width * 0.35,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: device.width * 0.35,
                  height: device.width * 0.35,
                  color: Colors.green,
                ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () => _takePicture(ImageSource.gallery),
                  child: Text(
                    'Select a Picture',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                RaisedButton(
                  onPressed: () => _takePicture(ImageSource.camera),
                  child: Text(
                    'Take a Picture',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
