import 'package:brtech_assignment/data.dart';
import 'package:brtech_assignment/story_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryScreen(stories: stories),
            ),
          ),
          child: Text('Story'),
        ),
      ),
    );
  }
}
