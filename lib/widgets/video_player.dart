import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
    if (!kIsWeb) {
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
            ? BetterPlayerDataSource.network(
                widget.videoUrl,
                notificationConfiguration:
                    BetterPlayerNotificationConfiguration(
                  showNotification: false,
                ),
              )
            : BetterPlayerDataSource.file(
                widget.videoFile.uri.toFilePath(),
                notificationConfiguration:
                    BetterPlayerNotificationConfiguration(
                  showNotification: false,
                ),
              ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Container(child: Text("No Video Player in Web"))
        : Container(
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
