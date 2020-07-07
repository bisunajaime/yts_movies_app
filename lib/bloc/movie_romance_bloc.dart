import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/repository/yts_repository.dart';

/*

EVENT

*/

abstract class MovieByRomanceEvent extends Equatable {
  const MovieByRomanceEvent();
}

class FetchMovieByRomance extends MovieByRomanceEvent {
  const FetchMovieByRomance();
  @override
  List<Object> get props => [];
}

//STATES

abstract class MovieByRomanceState extends Equatable {
  const MovieByRomanceState();

  @override
  List<Object> get props => [];
}

class MovieByRomanceEmpty extends MovieByRomanceState {}

class MovieByRomanceLoading extends MovieByRomanceState {}

class MovieByRomanceError extends MovieByRomanceState {}

class MovieByRomanceLoaded extends MovieByRomanceState {
  final List<MovieModel> movies;

  const MovieByRomanceLoaded({
    this.movies,
  });
  @override
  List<Object> get props => [movies];
  @override
  String toString() =>
      'MovieByRomanceSuccess { MovieByRomanceMovies: ${movies.length} }';
}

// BLOC

class MovieByRomanceBloc
    extends Bloc<MovieByRomanceEvent, MovieByRomanceState> {
  final YtsRepository ytsRepository;
  MovieByRomanceBloc({this.ytsRepository});

  @override
  MovieByRomanceState get initialState => MovieByRomanceEmpty();

  @override
  Stream<MovieByRomanceState> mapEventToState(
      MovieByRomanceEvent event) async* {
    if (event is FetchMovieByRomance) {
      yield MovieByRomanceLoading();
      try {
        final List<MovieModel> similar = await ytsRepository.fetchMoviesHome(
            sortedBy: 'rating', genre: 'romance');
        yield MovieByRomanceLoaded(movies: similar);
      } catch (e) {
        yield MovieByRomanceError();
      }
    }
  }
}
