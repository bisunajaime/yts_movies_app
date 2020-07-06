import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:ytsapp/models/movie_model.dart';

class YtsApiClient {
  final baseUrl = "https://yts.mx/api/v2";
  final http.Client httpClient;
  YtsApiClient({@required this.httpClient});

  Future<List<MovieModel>> fetchMovies({int page}) async {
    List<MovieModel> movies = [];
    final url = '$baseUrl/list_movies.json&page=$page';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem ${response.statusCode}');
    }
    final decodedJson = jsonDecode(response.body);
    decodedJson['data']['movies']
        .forEach((movie) => movies.add(MovieModel.fromJson(movie)));
    return movies;
  }
}
