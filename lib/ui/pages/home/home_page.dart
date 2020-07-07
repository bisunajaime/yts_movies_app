import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ytsapp/bloc/movie_action_bloc.dart';
import 'package:ytsapp/bloc/movie_comedy_bloc.dart';
import 'package:ytsapp/bloc/movie_downloadcount_bloc.dart';
import 'package:ytsapp/bloc/movie_romance_bloc.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/styles/fonts.dart';
import 'package:ytsapp/ui/pages/movie/movie_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'MOST ',
                style: Fonts.P_BOLD.copyWith(
                  color: Colors.greenAccent,
                  fontSize: 20,
                ),
              ),
              Text(
                'DOWNLOADED',
                style: Fonts.P_BOLD.copyWith(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        _buildMostDownloaded(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'ACTION',
            style: Fonts.P_BOLD.copyWith(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        _buildAction(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'COMEDY',
            style: Fonts.P_BOLD.copyWith(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        _buildComedy(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'ROMANCE',
            style: Fonts.P_BOLD.copyWith(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        _buildRomance(),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  _buildMostDownloaded() {
    return BlocBuilder<MovieByDownloadCountBloc, MovieByDownloadCountState>(
      builder: (context, state) {
        if (state is MovieByDownloadCountEmpty) {
          BlocProvider.of<MovieByDownloadCountBloc>(context)
              .add(FetchMovieByDownloadCount());
        }

        if (state is MovieByDownloadCountError) {
          return Center(
            child: Text("There was a problem."),
          );
        }

        if (state is MovieByDownloadCountLoaded) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            child: CarouselSlider.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, i) {
                MovieModel movie = state.movies[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePage(
                        id: movie.id,
                        model: movie,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: movie.medium_cover_image,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.greenAccent,
                              size: 20,
                            ),
                            Text(
                              movie.rating.toString(),
                              style: Fonts.P_BOLD.copyWith(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: false,
                height: double.infinity,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
              ),
            ),
          );
        }

        return Container(
          height: MediaQuery.of(context).size.height * .6,
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            itemCount: 6,
            options: CarouselOptions(
              height: double.infinity,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
            ),
            itemBuilder: (context, i) {
              return Container(
                height: double.infinity,
                margin: EdgeInsets.all(5),
                color: Colors.grey,
                child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white,
                  ),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
                ),
              );
            },
          ),
        );
      },
    );
  }

  _buildLabel(String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        s,
        style: Fonts.P_BOLD.copyWith(
          color: Colors.greenAccent,
          fontSize: 20,
        ),
      ),
    );
  }

  _buildAction() {
    return BlocBuilder<MovieByActionBloc, MovieByActionState>(
      builder: (context, state) {
        if (state is MovieByActionEmpty) {
          BlocProvider.of<MovieByActionBloc>(context).add(FetchMovieByAction());
        }

        if (state is MovieByActionError) {
          return Center(
            child: Text("There was a problem."),
          );
        }

        if (state is MovieByActionLoaded) {
          return Container(
            height: MediaQuery.of(context).size.height * .25,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.movies.length,
              itemBuilder: (context, i) {
                MovieModel movie = state.movies[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePage(
                        id: movie.id,
                        model: movie,
                      ),
                    ),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: 120,
                    margin: EdgeInsets.all(3),
                    child: Stack(
                      children: <Widget>[
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: movie.medium_cover_image,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.greenAccent,
                                size: 20,
                              ),
                              Text(
                                movie.rating.toString(),
                                style: Fonts.P_BOLD.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }

  _buildComedy() {
    return BlocBuilder<MovieByComedyBloc, MovieByComedyState>(
      builder: (context, state) {
        if (state is MovieByComedyEmpty) {
          BlocProvider.of<MovieByComedyBloc>(context).add(FetchMovieByComedy());
        }

        if (state is MovieByComedyError) {
          return Center(
            child: Text("There was a problem."),
          );
        }

        if (state is MovieByComedyLoaded) {
          return Container(
            height: MediaQuery.of(context).size.height * .25,
            width: double.infinity,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: state.movies.length,
              itemBuilder: (context, i) {
                MovieModel movie = state.movies[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePage(
                        id: movie.id,
                        model: movie,
                      ),
                    ),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: 120,
                    margin: EdgeInsets.all(3),
                    child: Stack(
                      children: <Widget>[
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: movie.medium_cover_image,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.greenAccent,
                                size: 20,
                              ),
                              Text(
                                movie.rating.toString(),
                                style: Fonts.P_BOLD.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }

  _buildRomance() {
    return BlocBuilder<MovieByRomanceBloc, MovieByRomanceState>(
      builder: (context, state) {
        if (state is MovieByRomanceEmpty) {
          BlocProvider.of<MovieByRomanceBloc>(context)
              .add(FetchMovieByRomance());
        }

        if (state is MovieByRomanceError) {
          return Center(
            child: Text("There was a problem."),
          );
        }

        if (state is MovieByRomanceLoaded) {
          return Container(
            height: MediaQuery.of(context).size.height * .25,
            width: double.infinity,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: state.movies.length,
              itemBuilder: (context, i) {
                MovieModel movie = state.movies[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePage(
                        id: movie.id,
                        model: movie,
                      ),
                    ),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: 120,
                    margin: EdgeInsets.all(3),
                    child: Stack(
                      children: <Widget>[
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: movie.medium_cover_image,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.greenAccent,
                                size: 20,
                              ),
                              Text(
                                movie.rating.toString(),
                                style: Fonts.P_BOLD.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}
