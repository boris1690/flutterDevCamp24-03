import 'dart:convert';
import 'package:flutter_api/normal_http/model/response_data.dart';

import 'package:http/http.dart' as http;

class DbzService {
  var url = 'https://dragonball-api.com/api';

  Future<ResponseData> fetchCharacters({int page = 1, int limit = 20}) async {
    final response =
        await http.get(Uri.parse('$url/characters?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ResponseData.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
