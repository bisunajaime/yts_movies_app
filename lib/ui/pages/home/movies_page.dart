import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ytsapp/bloc/movie_list_bloc.dart';
import 'package:ytsapp/models/movie_list_model.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/styles/fonts.dart';
import 'package:ytsapp/ui/pages/movie/movie_page.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  MovieListBloc _movieListBloc;
  final scrollThreshold = 200;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    _movieListBloc = BlocProvider.of<MovieListBloc>(context);
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll - currentScroll <= scrollThreshold) {
      _movieListBloc.add(FetchMovieList());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff1E1E1E),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'PEOPLES ',
                  style: Fonts.P_BOLD.copyWith(
                    color: Colors.greenAccent,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'CHOICE',
                  style: Fonts.P_BOLD.copyWith(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: _buildMovies(),
            ),
          )
        ],
      ),
    );
  }

  _buildMovies() {
    return BlocBuilder<MovieListBloc, MovieListState>(
      builder: (context, state) {
        print(state);
        if (state is MovieListInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MovieListFailed) {
          return Text('Failed');
        }

        if (state is MovieListSuccess) {
          if (state.movieList.isEmpty) {
            return Center(
              child: Text('No Movies Available...'),
            );
          }
          return Scrollbar(
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              controller: scrollController,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.7,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: state.hasReachedMax
                  ? state.movieList.length
                  : state.movieList.length + 1,
              itemBuilder: (context, i) {
                return i >= state.movieList.length
                    ? Shimmer.fromColors(
                        child: Container(
                          color: Color(0xff232323),
                        ),
                        baseColor: Color(0xff313131),
                        highlightColor: Color(0xff4A4A4A),
                      )
                    : _buildMovieWidget(state.movieList[i]);
              },
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  _buildMovieWidget(MovieModel model) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoviePage(
            id: model.id,
            model: model,
          ),
        ),
      ),
      child: Stack(
        children: <Widget>[
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black26,
                ],
              ).createShader(
                Rect.fromLTRB(
                  0,
                  0,
                  rect.width,
                  rect.height,
                ),
              );
            },
            blendMode: BlendMode.darken,
            child: FadeInImage.assetNetwork(
              width: double.infinity,
              height: double.infinity,
              placeholder: 'assets/images/placeholder.png',
              image: model.medium_cover_image,
              fit: BoxFit.cover,
              fadeInCurve: Curves.ease,
              fadeInDuration: Duration(milliseconds: 150),
              fadeOutCurve: Curves.ease,
            ),
          ),
          Positioned(
            bottom: 2,
            left: 2,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.greenAccent,
                  size: 15,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  model.rating.toString(),
                  style: Fonts.P_BOLD.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/*

 onNotification: (scroll) {
            final maxScroll = scroll.metrics.maxScrollExtent;
            final currentScroll = scroll.metrics.pixels;
            if (maxScroll - currentScroll <= scrollThreshold) {
              BlocProvider.of<MovieListBloc>(context).add(FetchMovieList());
              return true;
            }
            return false;
          },

 */
