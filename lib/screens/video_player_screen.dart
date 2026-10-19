import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> video;

  const VideoPlayerScreen({
    required this.video,
    super.key,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _showControls = true;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video['url']);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      _controller.addListener(_updatePosition);
    });
  }

  void _updatePosition() {
    setState(() {
      _currentPosition = _controller.value.position;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updatePosition);
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video Player
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),

                  // Center Play/Pause Button
                  if (!_controller.value.isPlaying)
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

                  // Top Controls
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                widget.video['title'] ?? 'الفيديو',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.share_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: () {
                                  // Share functionality
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Controls
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Progress Bar
                                SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 4,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6,
                                    ),
                                  ),
                                  child: Slider(
                                    min: 0,
                                    max: _controller.value.duration.inSeconds
                                        .toDouble(),
                                    value:
                                        _currentPosition.inSeconds.toDouble(),
                                    activeColor: AppTheme.primaryBrown,
                                    inactiveColor:
                                        Colors.white.withOpacity(0.3),
                                    onChanged: (value) {
                                      _controller
                                          .seekTo(
                                        Duration(seconds: value.toInt()),
                                      )
                                          .then((_) {
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Time Display and Controls
                                Row(
                                  children: [
                                    // Current Time
                                    Text(
                                      _formatDuration(_currentPosition),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      ' / ',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Total Duration
                                    Text(
                                      _formatDuration(
                                          _controller.value.duration),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    // Play/Pause Button
                                    IconButton(
                                      icon: Icon(
                                        _controller.value.isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: AppTheme.primaryBrown,
                                        size: 28,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _controller.value.isPlaying
                                              ? _controller.pause()
                                              : _controller.play();
                                        });
                                      },
                                    ),
                                    // Speed Button
                                    PopupMenuButton<double>(
                                      child: Center(
                                        child: Text(
                                          '${_controller.value.playbackSpeed}x',
                                          style: const TextStyle(
                                            color: AppTheme.primaryBrown,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 0.5,
                                          child: Text('0.5x'),
                                        ),
                                        const PopupMenuItem(
                                          value: 1.0,
                                          child: Text('1.0x'),
                                        ),
                                        const PopupMenuItem(
                                          value: 1.5,
                                          child: Text('1.5x'),
                                        ),
                                        const PopupMenuItem(
                                          value: 2.0,
                                          child: Text('2.0x'),
                                        ),
                                      ],
                                      onSelected: (speed) {
                                        _controller.setPlaybackSpeed(speed);
                                      },
                                    ),
                                    // Fullscreen Button
                                    IconButton(
                                      icon: const Icon(
                                        Icons.fullscreen_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        // Fullscreen functionality
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'خطأ في تحميل الفيديو',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text(
                      'العودة',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryBrown,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'جاري تحميل الفيديو...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
