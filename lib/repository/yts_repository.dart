import 'package:ytsapp/models/movie_list_model.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/repository/yts_api_client.dart';

class YtsRepository {
  final YtsApiClient ytsApiClient;
  YtsRepository({this.ytsApiClient});

  Future<List<MovieModel>> fetchMovies({int page}) async {
    return await ytsApiClient.fetchMovies(page: page);
  }

  Future<MovieModel> fetchMovieInfo({int id}) async {
    return await ytsApiClient.fetchMovieInfo(id: id);
  }

  Future<List<MovieModel>> fetchSimilarMovies({int id}) async {
    return await ytsApiClient.fetchSimilarMovies(id: id);
  }

  Future<List<MovieModel>> fetchMoviesHome(
      {String sortedBy, String genre}) async {
    return await ytsApiClient.fetchMoviesHome(sortedBy: sortedBy, genre: genre);
  }
}
