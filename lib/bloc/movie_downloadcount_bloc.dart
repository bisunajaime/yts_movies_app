import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/repository/yts_repository.dart';

/*

EVENT

*/

abstract class MovieByDownloadCountEvent extends Equatable {
  const MovieByDownloadCountEvent();
}

class FetchMovieByDownloadCount extends MovieByDownloadCountEvent {
  const FetchMovieByDownloadCount();
  @override
  List<Object> get props => [];
}

//STATES

abstract class MovieByDownloadCountState extends Equatable {
  const MovieByDownloadCountState();

  @override
  List<Object> get props => [];
}

class MovieByDownloadCountEmpty extends MovieByDownloadCountState {}

class MovieByDownloadCountLoading extends MovieByDownloadCountState {}

class MovieByDownloadCountError extends MovieByDownloadCountState {}

class MovieByDownloadCountLoaded extends MovieByDownloadCountState {
  final List<MovieModel> movies;

  const MovieByDownloadCountLoaded({
    this.movies,
  });
  @override
  List<Object> get props => [movies];
  @override
  String toString() =>
      'MovieByDownloadCountSuccess { MovieByDownloadCountMovies: ${movies.length} }';
}

// BLOC

class MovieByDownloadCountBloc
    extends Bloc<MovieByDownloadCountEvent, MovieByDownloadCountState> {
  final YtsRepository ytsRepository;
  MovieByDownloadCountBloc({this.ytsRepository});

  @override
  MovieByDownloadCountState get initialState => MovieByDownloadCountEmpty();

  @override
  Stream<MovieByDownloadCountState> mapEventToState(
      MovieByDownloadCountEvent event) async* {
    if (event is FetchMovieByDownloadCount) {
      yield MovieByDownloadCountLoading();
      try {
        final List<MovieModel> similar = await ytsRepository.fetchMoviesHome(
            sortedBy: 'download_count', genre: 'adventure');
        yield MovieByDownloadCountLoaded(movies: similar);
      } catch (e) {
        yield MovieByDownloadCountError();
      }
    }
  }
}
