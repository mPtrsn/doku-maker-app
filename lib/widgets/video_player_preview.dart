import 'dart:io';

import 'package:doku_maker/config.dart';
import 'package:doku_maker/widgets/video_player_dialog.dart';
import 'package:flutter/material.dart';

class VideoPlayerPreview extends StatelessWidget {
  final String previewImageUrl;
  final String videoUrl;
  final File videoFile;

  const VideoPlayerPreview(
      {Key key, this.previewImageUrl, this.videoUrl, this.videoFile})
      : super(key: key);

  factory VideoPlayerPreview.file(File videoFile) {
    return VideoPlayerPreview(
      videoFile: videoFile,
    );
  }
  factory VideoPlayerPreview.network(String url) {
    return VideoPlayerPreview(
      videoUrl: url,
    );
  }

  _openVideoPlayer(BuildContext context) {
    if (videoFile != null) {
      showDialog(
        context: context,
        builder: (context) => VideoPlayerDialog.file(videoFile),
      );
    } else if (videoUrl != null && videoUrl.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => VideoPlayerDialog.network(videoUrl),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () => _openVideoPlayer(context),
        child: (videoFile == null)
            ? Image.network(
                Config.couchdbURL + Config.defaultImagePath,
                headers: {'Authorization': 'Basic cmVhZGVyOnJlYWRlcg=='},
                fit: BoxFit.contain,
              )
            : Image.file(
                videoFile,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
