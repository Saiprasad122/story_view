import 'package:brtech_assignment/data.dart';
import 'package:brtech_assignment/model/story_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'animatedBar.dart';
import 'data.dart';

class StoryScreen extends StatefulWidget {
  StoryScreen({Key? key, required List<Story> stories}) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  VideoPlayerController? _videoPlayerController;
  int _currentIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _pageController = PageController();

    // _videoPlayerController = VideoPlayerController.network(
    //     'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4')
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
    final Story story = stories.first;
    _loadStory(story: story, animateToPage: false);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if (_currentIndex + 1 < stories.length) {
            _currentIndex += 1;
            _loadStory(story: stories[_currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            _currentIndex = 0;
            _loadStory(story: stories[_currentIndex]);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final story = stories[_currentIndex];
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        child: Stack(
          children: [
            PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: stories.length,
              itemBuilder: (context, i) {
                final Story story = stories[i];
                switch (story.mediaType) {
                  case MediaType.image:
                    return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Image.asset(
                          stories[i].url,
                          fit: BoxFit.cover,
                        ));
                  case MediaType.video:
                    if (_videoPlayerController != null &&
                        _videoPlayerController!.value.isInitialized) {
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoPlayerController!.value.size.width,
                          height: _videoPlayerController!.value.size.height,
                          child: VideoPlayer(_videoPlayerController!),
                        ),
                      );
                    } else {
                      Center(
                        child: Text('Something wrong'),
                      );
                    }
                }
                return const SizedBox.shrink();
              },
            ),
            Positioned(
              top: 30,
              left: 10,
              right: 10,
              child: Row(
                children: stories
                    .asMap()
                    .map((i, e) {
                      return MapEntry(
                          i,
                          AnimatedBar(
                            animationController: _animationController,
                            position: i,
                            currentIndex: _currentIndex,
                          ));
                    })
                    .values
                    .toList(),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: Container(
                width: double.infinity,
                height: 60,
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.grey[700],
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.5),
                          ),
                          hintText: 'Type a message....',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.camera_alt,
                      color: Colors.grey[700],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController!.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: stories[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < stories.length) {
          _currentIndex += 1;
          _loadStory(story: stories[_currentIndex]);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          _currentIndex = 0;
          _loadStory(story: stories[_currentIndex]);
        }
      });
    } else {
      if (story.mediaType == MediaType.video) {
        if (_videoPlayerController!.value.isPlaying) {
          _videoPlayerController!.pause();
          _animationController.stop();
        } else {
          _videoPlayerController!.play();
          _animationController.forward();
        }
      }
    }
  }

  void _loadStory({required Story story, bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();
    switch (story.mediaType) {
      case MediaType.image:
        _animationController.duration = story.duration;
        _animationController.forward();
        break;
      case MediaType.video:
        _videoPlayerController = null;
        _videoPlayerController?.dispose();
        _videoPlayerController = VideoPlayerController.network(story.url)
          ..initialize().then((_) {
            setState(() {});
            if (_videoPlayerController!.value.isInitialized) {
              _animationController.duration =
                  _videoPlayerController!.value.duration;
              _videoPlayerController!.play();
              _animationController.forward();
            }
          });
        break;
    }
    if (animateToPage) {
      if (_pageController!.hasClients) {
        _pageController!.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
