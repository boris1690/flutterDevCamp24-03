import 'package:flutter_api/normal_http/model/character.dart';

class ResponseData {
  final List<Character> data;

  ResponseData({
    required this.data,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      data:
          List<Character>.from(json['items'].map((x) => Character.fromJson(x))),
    );
  }
}
