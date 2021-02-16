import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../config.dart';

class VideoPlayerDialog extends StatefulWidget {
  static final String routeName = '/video-player';

  final String videoUrl;
  final File videoFile;

  VideoPlayerDialog({Key key, this.videoUrl, this.videoFile}) : super(key: key);

  factory VideoPlayerDialog.file(File videoFile) {
    return VideoPlayerDialog(videoFile: videoFile);
  }

  factory VideoPlayerDialog.network(String videoUrl) {
    return VideoPlayerDialog(videoUrl: videoUrl);
  }

  @override
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    if (widget.videoUrl != null && widget.videoUrl.isNotEmpty) {
      _controller = VideoPlayerController.network(
        Config.couchdbURL + widget.videoUrl,
      );
    } else if (widget.videoFile != null) {
      _controller = VideoPlayerController.file(widget.videoFile);
    } else {
      print("ERROR in video source");
    }

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(false);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  void togglePlay() {
    setState(() {
      // If the video is playing, pause it.
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        // If the video is paused, play it.
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop()),
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            (_controller.value.isPlaying)
                ? ElevatedButton.icon(
                    onPressed: togglePlay,
                    icon: Icon(Icons.pause),
                    label: Text('Pause'),
                  )
                : ElevatedButton.icon(
                    onPressed: togglePlay,
                    icon: Icon(Icons.play_arrow),
                    label: Text('Play'),
                  ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
