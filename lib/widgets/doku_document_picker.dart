import 'dart:io';

import 'package:doku_maker/provider/upload_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../config.dart';
import 'doku_image.dart';

class DocumentPicker extends StatefulWidget {
  final PickerType type;
  final bool showPreview;
  final String currentImagePath;
  final Function(String path) onUploaded;

  const DocumentPicker({
    Key key,
    @required this.type,
    @required this.onUploaded,
    this.showPreview = true,
    this.currentImagePath,
  }) : super(key: key);

  @override
  _DocumentPickerState createState() => _DocumentPickerState();
}

class _DocumentPickerState extends State<DocumentPicker> {
  PickedFile _newFile;
  final _picker = ImagePicker();

  _getFile(ImageSource source) async {
    PickedFile _pickedFile;
    try {
      if (widget.type == PickerType.Image) {
        _pickedFile = await _picker.getImage(
          source: source,
          maxWidth: 600,
        );
      } else {
        _pickedFile = await _picker.getVideo(
          source: source,
        );
      }
    } catch (error) {
      print(error);
    }
    setState(() {
      _newFile = _pickedFile;
    });
    _uploadFile();
  }

  _uploadFile() async {
    String result = '';
    if (widget.type == PickerType.Image) {
      result = await UploadService.uploadImage('title', _newFile.path);
    } else {
      result = await UploadService.uploadVideo('title', _newFile.path);
    }
    widget.onUploaded(result);
  }

  String get buttonText {
    if (_newFile != null) {
      return 'Change';
    } else {
      return widget.type == PickerType.Image ? 'Add Picture' : 'Add Video';
    }
  }

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.showPreview)
            Container(
              width: device.width * 0.35,
              height: device.width * 0.35,
              child: _newFile != null
                  ? Image.file(
                      File(_newFile.path),
                      fit: BoxFit.cover,
                    )
                  : (widget.currentImagePath != null &&
                          widget.currentImagePath.isNotEmpty)
                      ? DokuImage.network(
                          Config.couchdbURL + widget.currentImagePath,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.green,
                        ),
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
                      Text(buttonText, style: TextStyle()),
                    ],
                  ),
                ),
                onSelected: (source) => _getFile(source),
                itemBuilder: (ctx) => [
                      PopupMenuItem<ImageSource>(
                        child: Row(
                          children: [
                            Icon(Icons.camera_alt),
                            Text(widget.type == PickerType.Image
                                ? 'Take a Picture'
                                : 'Take a Video'),
                          ],
                        ),
                        value: ImageSource.camera,
                      ),
                      PopupMenuItem<ImageSource>(
                        child: Row(
                          children: [
                            Icon(Icons.image),
                            Text(widget.type == PickerType.Image
                                ? 'Select a Picture'
                                : 'Select a Video'),
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

enum PickerType { Image, Video }
