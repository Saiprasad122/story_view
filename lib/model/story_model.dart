import 'package:brtech_assignment/model/user_model.dart';

enum MediaType {
  image,
  video,
}

class Story {
  final String url;
  final MediaType mediaType;
  final Duration duration;
  final User user;

  const Story({
    required this.url,
    required this.mediaType,
    required this.duration,
    required this.user,
  });
}
