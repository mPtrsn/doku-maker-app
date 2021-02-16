import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  final File videoFile;
  final bool isNetwork;

  const VideoPlayer({Key key, this.videoUrl, this.videoFile, this.isNetwork})
      : super(key: key);

  factory VideoPlayer.network(String videoUrl) {
    return VideoPlayer(
      videoUrl: videoUrl,
      isNetwork: true,
    );
  }
  factory VideoPlayer.file(File videoFile) {
    return VideoPlayer(
      videoFile: videoFile,
      isNetwork: false,
    );
  }

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  BetterPlayerController _betterPlayerController;
  @override
  void initState() {
    super.initState();
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 9 / 16,
        allowedScreenSleep: false,
        fullScreenAspectRatio: 9 / 16,
        autoDetectFullscreenDeviceOrientation: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableOverflowMenu: false,
          enableSkips: false,
        ),
      ),
      betterPlayerDataSource: widget.isNetwork
          ? BetterPlayerDataSource.network(Config.couchdbURL + widget.videoUrl)
          : BetterPlayerDataSource.file(widget.videoFile.uri.toFilePath()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: BetterPlayer(
            controller: _betterPlayerController,
          ),
        ),
      ),
    );
  }
}
