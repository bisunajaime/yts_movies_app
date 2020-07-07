import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:ytsapp/models/movie_list_model.dart';
import 'package:ytsapp/models/movie_model.dart';

class YtsApiClient {
  final baseUrl = "https://yts.mx/api/v2";
  final http.Client httpClient;
  YtsApiClient({@required this.httpClient});

  Future<List<MovieModel>> fetchMovies({int page}) async {
    List<MovieModel> movies = [];
    final url = '$baseUrl/list_movies.json?page=$page&sort_by=rating';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem ${response.statusCode}');
    }
    final decodedJson = jsonDecode(response.body);
    decodedJson['data']['movies']
        .forEach((movie) => movies.add(MovieModel.fromJson(movie)));
    movies.removeLast();
    return movies;
  }

  Future<MovieModel> fetchMovieInfo({int id}) async {
    final url = '$baseUrl/movie_details.json?movie_id=$id&with_cast=true';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem ${response.statusCode}');
    }

    final decodedJson = jsonDecode(response.body);
    MovieModel movie = MovieModel.fromJson(decodedJson['data']['movie']);
    return movie;
  }

  Future<List<MovieModel>> fetchSimilarMovies({int id}) async {
    // https://yts.mx/api/v2/movie_suggestions.json?movie_id=8065
    List<MovieModel> movies = [];
    final url = '$baseUrl/movie_suggestions.json?movie_id=$id';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem ${response.statusCode}');
    }
    final decodedJson = jsonDecode(response.body);
    decodedJson['data']['movies']
        .forEach((movie) => movies.add(MovieModel.fromJson(movie)));
    return movies;
  }

  Future<List<MovieModel>> fetchMoviesHome(
      {String sortedBy, String genre}) async {
    // https://yts.mx/api/v2/list_movies.json?sort_by=download_count
    List<MovieModel> movies = [];
    final url =
        '$baseUrl/list_movies.json?sort_by=$sortedBy&limit=50&genre=$genre';
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
