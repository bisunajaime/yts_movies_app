import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/repository/yts_repository.dart';

/*

EVENT

*/

abstract class MovieByActionEvent extends Equatable {
  const MovieByActionEvent();
}

class FetchMovieByAction extends MovieByActionEvent {
  const FetchMovieByAction();
  @override
  List<Object> get props => [];
}

//STATES

abstract class MovieByActionState extends Equatable {
  const MovieByActionState();

  @override
  List<Object> get props => [];
}

class MovieByActionEmpty extends MovieByActionState {}

class MovieByActionLoading extends MovieByActionState {}

class MovieByActionError extends MovieByActionState {}

class MovieByActionLoaded extends MovieByActionState {
  final List<MovieModel> movies;

  const MovieByActionLoaded({
    this.movies,
  });
  @override
  List<Object> get props => [movies];
  @override
  String toString() =>
      'MovieByActionSuccess { MovieByActionMovies: ${movies.length} }';
}

// BLOC

class MovieByActionBloc extends Bloc<MovieByActionEvent, MovieByActionState> {
  final YtsRepository ytsRepository;
  MovieByActionBloc({this.ytsRepository});

  @override
  MovieByActionState get initialState => MovieByActionEmpty();

  @override
  Stream<MovieByActionState> mapEventToState(MovieByActionEvent event) async* {
    if (event is FetchMovieByAction) {
      yield MovieByActionLoading();
      try {
        final List<MovieModel> similar = await ytsRepository.fetchMoviesHome(
            sortedBy: 'rating', genre: 'action');
        yield MovieByActionLoaded(movies: similar);
      } catch (e) {
        yield MovieByActionError();
      }
    }
  }
}
