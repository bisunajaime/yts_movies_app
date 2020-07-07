import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/repository/yts_repository.dart';

/*

EVENT

*/

abstract class MovieByComedyEvent extends Equatable {
  const MovieByComedyEvent();
}

class FetchMovieByComedy extends MovieByComedyEvent {
  const FetchMovieByComedy();
  @override
  List<Object> get props => [];
}

//STATES

abstract class MovieByComedyState extends Equatable {
  const MovieByComedyState();

  @override
  List<Object> get props => [];
}

class MovieByComedyEmpty extends MovieByComedyState {}

class MovieByComedyLoading extends MovieByComedyState {}

class MovieByComedyError extends MovieByComedyState {}

class MovieByComedyLoaded extends MovieByComedyState {
  final List<MovieModel> movies;

  const MovieByComedyLoaded({
    this.movies,
  });
  @override
  List<Object> get props => [movies];
  @override
  String toString() =>
      'MovieByComedySuccess { MovieByComedyMovies: ${movies.length} }';
}

// BLOC

class MovieByComedyBloc extends Bloc<MovieByComedyEvent, MovieByComedyState> {
  final YtsRepository ytsRepository;
  MovieByComedyBloc({this.ytsRepository});

  @override
  MovieByComedyState get initialState => MovieByComedyEmpty();

  @override
  Stream<MovieByComedyState> mapEventToState(MovieByComedyEvent event) async* {
    if (event is FetchMovieByComedy) {
      yield MovieByComedyLoading();
      try {
        final List<MovieModel> similar = await ytsRepository.fetchMoviesHome(
            sortedBy: 'rating', genre: 'comedy');
        yield MovieByComedyLoaded(movies: similar);
      } catch (e) {
        yield MovieByComedyError();
      }
    }
  }
}
