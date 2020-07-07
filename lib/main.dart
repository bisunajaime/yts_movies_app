import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ytsapp/bloc/movie_action_bloc.dart';
import 'package:ytsapp/bloc/movie_comedy_bloc.dart';
import 'package:ytsapp/bloc/movie_downloadcount_bloc.dart';
import 'package:ytsapp/bloc/movie_list_bloc.dart';
import 'package:ytsapp/bloc/movie_romance_bloc.dart';
import 'package:ytsapp/repository/yts_api_client.dart';
import 'package:ytsapp/repository/yts_repository.dart';
import 'package:http/http.dart' as http;
import 'package:ytsapp/styles/fonts.dart';
import 'package:ytsapp/ui/pages/home/home_page.dart';
import 'package:ytsapp/ui/pages/home/movies_page.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final YtsRepository ytsRepository = YtsRepository(
    ytsApiClient: YtsApiClient(
      httpClient: http.Client(),
    ),
  );
  runApp(MyApp(
    ytsRepository: ytsRepository,
  ));
}

// BLoc Delegate
class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class MyApp extends StatelessWidget {
  final YtsRepository ytsRepository;
  MyApp({Key key, @required this.ytsRepository})
      : assert(ytsRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Main(
        ytsRepository: ytsRepository,
      ),
    );
  }
}

class Main extends StatefulWidget {
  final YtsRepository ytsRepository;
  Main({@required this.ytsRepository});
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with AutomaticKeepAliveClientMixin {
  PageController pageController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0xff1E1E1E),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff0E0E0E),
        selectedItemColor: Colors.pinkAccent,
        selectedFontSize: 10,
        selectedLabelStyle: Fonts.P_BOLD.copyWith(
          color: Colors.pinkAccent,
        ),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (i) {
          pageController.animateToPage(
            i,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
          setState(() {
            index = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
              'Home',
              style: Fonts.P_MED.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.movie,
              color: Colors.white,
            ),
            title: Text(
              'Movies',
              style: Fonts.P_MED.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MovieListBloc(
              ytsRepository: widget.ytsRepository,
            )..add(FetchMovieList()),
          ),
          BlocProvider(
            create: (context) => MovieByDownloadCountBloc(
              ytsRepository: widget.ytsRepository,
            ),
          ),
          BlocProvider(
            create: (context) => MovieByActionBloc(
              ytsRepository: widget.ytsRepository,
            ),
          ),
          BlocProvider(
            create: (context) => MovieByComedyBloc(
              ytsRepository: widget.ytsRepository,
            ),
          ),
          BlocProvider(
            create: (context) => MovieByRomanceBloc(
              ytsRepository: widget.ytsRepository,
            ),
          ),
        ],
        child: PageView(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomePage(),
            MoviesPage(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
