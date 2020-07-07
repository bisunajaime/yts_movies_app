import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ytsapp/models/movie_list_model.dart';
import 'package:meta/meta.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/repository/yts_repository.dart';

// EVENTS

abstract class MovieInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMovieInfo extends MovieInfoEvent {
  final int id;
  FetchMovieInfo({@required this.id});
  @override
  List<Object> get props => [id];
}

// STATES

abstract class MovieInfoState extends Equatable {
  const MovieInfoState();
  @override
  List<Object> get props => [];
}

class MovieInfoInitial extends MovieInfoState {}

class MovieInfoLoading extends MovieInfoState {}

class MovieInfoFailed extends MovieInfoState {}

class MovieInfoLoaded extends MovieInfoState {
  final MovieModel movieInfo;

  const MovieInfoLoaded({@required this.movieInfo});

  @override
  List<Object> get props => [movieInfo];

  @override
  String toString() => "MovieInfoSuccess { MovieInfo: ${movieInfo.title} }";
}

// BLOC

class MovieInfoBloc extends Bloc<MovieInfoEvent, MovieInfoState> {
  final YtsRepository ytsRepository;
  MovieInfoBloc({@required this.ytsRepository});

  @override
  MovieInfoState get initialState => MovieInfoInitial();

  @override
  Stream<MovieInfoState> mapEventToState(MovieInfoEvent event) async* {
    if (event is FetchMovieInfo) {
      yield MovieInfoLoading();
      try {
        final MovieModel model =
            await ytsRepository.fetchMovieInfo(id: event.id);
        yield MovieInfoLoaded(movieInfo: model);
      } catch (e) {
        print(e);
        yield MovieInfoFailed();
      }
    }
  }
}
