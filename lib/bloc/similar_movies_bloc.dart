import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ytsapp/models/movie_list_model.dart';
import 'package:meta/meta.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/repository/yts_repository.dart';

// EVENTS

abstract class SimilarMoviesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSimilarMovies extends SimilarMoviesEvent {
  final int id;
  FetchSimilarMovies({@required this.id});
  @override
  List<Object> get props => [id];
}

// STATES

abstract class SimilarMoviesState extends Equatable {
  const SimilarMoviesState();
  @override
  List<Object> get props => [];
}

class SimilarMoviesInitial extends SimilarMoviesState {}

class SimilarMoviesLoading extends SimilarMoviesState {}

class SimilarMoviesFailed extends SimilarMoviesState {}

class SimilarMoviesLoaded extends SimilarMoviesState {
  final List<MovieModel> similarMovies;

  const SimilarMoviesLoaded({@required this.similarMovies});

  @override
  List<Object> get props => [similarMovies];

  @override
  String toString() =>
      "SimilarMoviesSuccess { SimilarMovies: ${similarMovies.length} }";
}

// BLOC

class SimilarMoviesBloc extends Bloc<SimilarMoviesEvent, SimilarMoviesState> {
  final YtsRepository ytsRepository;
  SimilarMoviesBloc({@required this.ytsRepository});

  @override
  SimilarMoviesState get initialState => SimilarMoviesInitial();

  @override
  Stream<SimilarMoviesState> mapEventToState(SimilarMoviesEvent event) async* {
    if (event is FetchSimilarMovies) {
      yield SimilarMoviesLoading();
      try {
        final List<MovieModel> model =
            await ytsRepository.fetchSimilarMovies(id: event.id);
        yield SimilarMoviesLoaded(similarMovies: model);
      } catch (e) {
        print(e);
        yield SimilarMoviesFailed();
      }
    }
  }
}
