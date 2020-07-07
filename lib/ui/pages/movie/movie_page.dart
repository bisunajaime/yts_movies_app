import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ytsapp/bloc/movie_info_bloc.dart';
import 'package:ytsapp/bloc/similar_movies_bloc.dart';
import 'package:ytsapp/models/cast.dart';
import 'package:ytsapp/models/movie_list_model.dart';
import 'package:ytsapp/models/movie_model.dart';
import 'package:ytsapp/models/torrent_model.dart';
import 'package:ytsapp/repository/yts_api_client.dart';
import 'package:ytsapp/repository/yts_repository.dart';
import 'package:http/http.dart' as http;
import 'package:ytsapp/styles/fonts.dart';

class MoviePage extends StatefulWidget {
  final int id;
  final MovieModel model;
  MoviePage({this.id, this.model});
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  YtsRepository ytsRepository = YtsRepository(
    ytsApiClient: YtsApiClient(
      httpClient: http.Client(),
    ),
  );

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('There was a problem'),
          content: Text('Url can not be found / launched.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieInfoBloc(
            ytsRepository: ytsRepository,
          ),
        ),
        BlocProvider(
          create: (context) => SimilarMoviesBloc(
            ytsRepository: ytsRepository,
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xff0e0e0e),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * .7,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff0e0e0e),
                        Colors.transparent,
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
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff0e0e0e),
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.model.medium_cover_image,
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black26,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<MovieInfoBloc, MovieInfoState>(
                    builder: (context, state) {
                      if (state is MovieInfoInitial) {
                        BlocProvider.of<MovieInfoBloc>(context).add(
                          FetchMovieInfo(
                            id: widget.id,
                          ),
                        );
                      }
                      if (state is MovieInfoFailed) {
                        return Text('There was a problem');
                      }
                      if (state is MovieInfoLoaded) {
                        return _buildMovieInfo(state.movieInfo);
                      }

                      return Center(
                        child: Column(
                          children: <Widget>[
                            CircularProgressIndicator(
                              backgroundColor: Colors.greenAccent,
                            ),
                            Text(
                              'Loading movie info',
                              style: Fonts.P_MED,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  BlocBuilder<SimilarMoviesBloc, SimilarMoviesState>(
                    builder: (context, state) {
                      if (state is SimilarMoviesInitial) {
                        BlocProvider.of<SimilarMoviesBloc>(context)
                            .add(FetchSimilarMovies(id: widget.model.id));
                      }

                      if (state is SimilarMoviesFailed) {
                        return Text('Failed');
                      }

                      if (state is SimilarMoviesLoaded) {
                        return _buildSimilarMovies(state.similarMovies);
                      }

                      return Container();
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildMovieInfo(MovieModel movie) {
    print(movie.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: Text(
            movie.title_long,
            style: Fonts.P_BOLD.copyWith(
              fontSize: 15,
              color: Colors.greenAccent,
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.greenAccent,
                    size: 12,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    movie.rating.toString(),
                    style: Fonts.P_BOLD.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.file_download,
                    color: Colors.greenAccent,
                    size: 12,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    movie.download_count.toString(),
                    style: Fonts.P_BOLD.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.thumb_up,
                    color: Colors.greenAccent,
                    size: 12,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    movie.like_count.toString(),
                    style: Fonts.P_BOLD.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.file_upload,
                    color: Colors.greenAccent,
                    size: 12,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    DateFormat.yMMMd()
                        .format(DateTime.parse(movie.date_uploaded)),
                    style: Fonts.P_BOLD.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.timer,
                    color: Colors.greenAccent,
                    size: 12,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "${(movie.runtime / 60).toStringAsFixed(2).toString()} hrs",
                    style: Fonts.P_BOLD.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          height: 20,
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: movie.genres.length,
            itemBuilder: (context, i) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.greenAccent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                margin: EdgeInsets.symmetric(horizontal: 2),
                child: Center(
                  child: Text(
                    movie.genres[i],
                    style: Fonts.P_MED.copyWith(
                      fontSize: 8,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            movie.description_full,
            style: Fonts.P_REG.copyWith(
              fontSize: 10,
              height: 1.6,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              color: Colors.redAccent,
              child: Icon(
                Icons.play_arrow,
                color: Color(0xff1b1b1b),
              ),
              onPressed: () => _launchURL(
                  'https://www.youtube.com/watch?v=${movie.yt_trailer_code}'),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: Text(
            'Cast',
            style: Fonts.P_BOLD.copyWith(
              fontSize: 15,
              color: Colors.greenAccent,
            ),
          ),
        ),
        Container(
          height: 150,
          width: double.infinity,
          child: movie.cast == null
              ? Center(
                  child: Text(
                    'Not Specified',
                    style: Fonts.P_BOLD,
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: movie.cast.length,
                  itemBuilder: (context, i) => _buildCast(movie.cast[i]),
                ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'Torrent Links',
            style: Fonts.P_BOLD.copyWith(
              color: Colors.greenAccent,
            ),
          ),
        ),
        Container(
          height: 90,
          width: double.infinity,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: movie.torrents.length,
            itemBuilder: (context, i) => _buildTorrents(movie.torrents[i]),
          ),
        ),
      ],
    );
  }

  _buildTorrents(Torrent torrent) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FlatButton(
        color: Colors.greenAccent,
        onPressed: () => _launchURL(torrent.url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              torrent.quality,
              style: Fonts.P_MED.copyWith(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
            Text(
              torrent.size,
              style: Fonts.P_BOLD.copyWith(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            Text(
              DateFormat.yMMMd().format(
                DateTime.parse(
                  torrent.date_uploaded,
                ),
              ),
              style: Fonts.P_MED.copyWith(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimilarMovies(List<MovieModel> similarMovies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'Similar Movies',
            style: Fonts.P_BOLD.copyWith(
              fontSize: 15,
              color: Colors.greenAccent,
            ),
          ),
        ),
        Container(
          height: 200,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: similarMovies.length,
            itemBuilder: (context, i) {
              MovieModel movie = similarMovies[i];
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
                  width: 140,
                  margin: EdgeInsets.all(3),
                  height: double.infinity,
                  child: Stack(
                    children: <Widget>[
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: movie.medium_cover_image,
                        fit: BoxFit.cover,
                        fadeInCurve: Curves.ease,
                        fadeOutCurve: Curves.ease,
                        fadeInDuration: Duration(milliseconds: 250),
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
                            Text(
                              movie.rating.toString(),
                              style: Fonts.P_BOLD.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _buildCast(CastModel cast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(2),
            height: double.infinity,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: cast.url_small_image == null
                    ? AssetImage('assets/images/placeholder.png')
                    : NetworkImage(
                        cast.url_small_image,
                      ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(
          cast.name,
          style: Fonts.P_REG.copyWith(
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}
