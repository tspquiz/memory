import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// A video player widget to use in a container that may
/// not match the aspect ratio of the video.
///
/// Respects the aspect ratio of the movie but shows it
/// to cover the container, causing parts of the video
/// to be cut off.
///
/// Plays the video once on load. Shows no playback
/// controls.
///
/// If CacheManager is provided above in the widget tree,
/// it will be used to obtain videos. Otherwise they
/// are loaded over the network.
class CardVideoPlayer extends StatefulWidget {
  final String url;
  final void Function()? onLoadError;

  const CardVideoPlayer({required this.url, this.onLoadError, super.key});

  @override
  State<CardVideoPlayer> createState() => _CardVideoPlayerState();
}

class _CardVideoPlayerState extends State<CardVideoPlayer> {
  VideoPlayerController? _controller;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  void initController() async {
    final cache = Provider.of<CacheManager?>(context, listen: false);
    if (cache != null) {
      final videoFile = await cache.getSingleFile(widget.url);
      if (!mounted) return;
      _controller = VideoPlayerController.file(videoFile);
    } else {
      _controller = VideoPlayerController.network(widget.url);
    }
    _controller!.setVolume(0.0);
    _controller!.setLooping(false);
    try {
      await _controller!.initialize();
    } catch (e) {
      // If there is a load error, invoke the optional load error event handler
      if (widget.onLoadError != null) {
        widget.onLoadError!();
      }
    }
    _controller!.play();
    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded) {
      // The LayoutBuilder is used to obtain the constraints.
      return LayoutBuilder(builder: (context, constraints) {
        return SizedBox( // Set outer size of fitted box to fill available space
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: FittedBox( // Cover-fit the video in the outer SizedBox frame.
            fit: BoxFit.cover,
            child: SizedBox( // Make video respect its aspect ratio.
              height: constraints.maxHeight,
              width: constraints.maxHeight * _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
        );
      });
    }
    return const Center(child: CircularProgressIndicator());
  }
}
