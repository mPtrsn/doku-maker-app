import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DokuImagePicker extends StatefulWidget {
  final Function(File image) onSelected;
  final bool showPreview;
  const DokuImagePicker(
      {Key key, @required this.onSelected, this.showPreview: true})
      : super(key: key);

  @override
  _DokuImagePickerState createState() => _DokuImagePickerState();
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
          if (widget.showPreview)
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
                        "Add Picture",
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
                //icon: Icon(Icons.add),
                onSelected: (source) => _takePicture(source),
                itemBuilder: (ctx) => [
                      PopupMenuItem<ImageSource>(
                        child: Row(
                          children: [
                            Icon(Icons.camera_alt),
                            Text('Take a Picture'),
                          ],
                        ),
                        value: ImageSource.camera,
                      ),
                      PopupMenuItem<ImageSource>(
                        child: Row(
                          children: [
                            Icon(Icons.image),
                            Text('Select a Picture'),
                          ],
                        ),
                        value: ImageSource.gallery,
                      ),
                    ]),
          ),
        ],
      ),
    );
  }
}
