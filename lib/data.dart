import 'package:brtech_assignment/model/story_model.dart';

import 'model/user_model.dart';

final User user = User(
  name: 'Johny Vino',
  profileImage: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
);
final List<Story> stories = [
  Story(
    url: 'assets/ganesh1.jpeg',
    mediaType: MediaType.image,
    duration: const Duration(seconds: 5),
    user: user,
  ),
  Story(
    url: 'assets/ganesh2.jpeg',
    mediaType: MediaType.image,
    user: User(
      name: 'John Doe',
      profileImage: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
    ),
    duration: const Duration(seconds: 2),
  ),
  // Story(
  //   url:
  //       'https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4',
  //   mediaType: MediaType.video,
  //   duration: const Duration(seconds: 0),
  //   user: user,
  // ),
  Story(
    url: 'assets/ganesh3.jpeg',
    mediaType: MediaType.image,
    duration: const Duration(seconds: 2),
    user: user,
  ),
  // Story(
  //   url:
  //       'https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4',
  //   mediaType: MediaType.video,
  //   duration: const Duration(seconds: 0),
  //   user: user,
  // ),
  Story(
    url: 'assets/ganesh4.jpeg',
    mediaType: MediaType.image,
    duration: const Duration(seconds: 2),
    user: user,
  ),
];
