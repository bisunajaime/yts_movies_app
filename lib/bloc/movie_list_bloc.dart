import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ytsapp/models/movie_list_model.dart';
import 'package:meta/meta.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/repository/yts_repository.dart';

// EVENTS

abstract class MovieListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMovieList extends MovieListEvent {}

// STATES

abstract class MovieListState extends Equatable {
  const MovieListState();
  @override
  List<Object> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListFailed extends MovieListState {}

class MovieListSuccess extends MovieListState {
  final List<MovieModel> movieList;
  final bool hasReachedMax;

  const MovieListSuccess({@required this.movieList, this.hasReachedMax});
  MovieListSuccess copyWith({
    List<MovieModel> movieList,
    bool hasReachedMax,
  }) {
    return MovieListSuccess(
      movieList: movieList ?? this.movieList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [movieList, hasReachedMax];

  @override
  String toString() =>
      "MovieListSuccess { movieList: ${movieList.length}, hasReachedMax: $hasReachedMax }";
}

// BLOC

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final YtsRepository ytsRepository;
  int page = 1;
  MovieListBloc({@required this.ytsRepository});

  @override
  MovieListState get initialState => MovieListInitial();

  @override
  Stream<MovieListState> mapEventToState(MovieListEvent event) async* {
    final currentState = state;
    if (event is FetchMovieList && !_hasReachedMax(currentState)) {
      try {
        if (currentState is MovieListInitial) {
          final movies = await ytsRepository.fetchMovies(page: page);
          yield MovieListSuccess(movieList: movies, hasReachedMax: false);
          return;
        }
        if (currentState is MovieListSuccess) {
          final movies = await ytsRepository.fetchMovies(page: ++page);
          yield movies.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MovieListSuccess(
                  movieList: currentState.movieList + movies,
                  hasReachedMax: false,
                );
        }
      } catch (e) {
        print(e);
        yield MovieListFailed();
      }
    }
  }

  bool _hasReachedMax(MovieListState state) =>
      state is MovieListSuccess && state.hasReachedMax;
}
