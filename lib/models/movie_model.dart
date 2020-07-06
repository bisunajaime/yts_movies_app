import 'package:equatable/equatable.dart';
import 'package:ytsapp/models/torrent_model.dart';

class MovieModel extends Equatable {
  String background_image;
  String background_image_original;
  String date_uploaded;
  int date_uploaded_unix;
  String description_full;
  String description_intro;
  int download_count;
  List<String> genres;
  int id;
  String imdb_code;
  String language;
  String large_cover_image;
  int like_count;
  String medium_cover_image;
  String mpa_rating;
  double rating;
  int runtime;
  String slug;
  String small_cover_image;
  String title;
  String title_english;
  String title_long;
  List<Torrent> torrents;
  String url;
  int year;
  String yt_trailer_code;

  MovieModel(
      {this.background_image,
      this.background_image_original,
      this.date_uploaded,
      this.date_uploaded_unix,
      this.description_full,
      this.description_intro,
      this.download_count,
      this.genres,
      this.id,
      this.imdb_code,
      this.language,
      this.large_cover_image,
      this.like_count,
      this.medium_cover_image,
      this.mpa_rating,
      this.rating,
      this.runtime,
      this.slug,
      this.small_cover_image,
      this.title,
      this.title_english,
      this.title_long,
      this.torrents,
      this.url,
      this.year,
      this.yt_trailer_code});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      background_image: json['background_image'],
      background_image_original: json['background_image_original'],
      date_uploaded: json['date_uploaded'],
      date_uploaded_unix: json['date_uploaded_unix'],
      description_full: json['description_full'],
      description_intro: json['description_intro'],
      download_count: json['download_count'],
      genres:
          json['genres'] != null ? new List<String>.from(json['genres']) : null,
      id: json['id'],
      imdb_code: json['imdb_code'],
      language: json['language'],
      large_cover_image: json['large_cover_image'],
      like_count: json['like_count'],
      medium_cover_image: json['medium_cover_image'],
      mpa_rating: json['mpa_rating'],
      rating: json['rating'],
      runtime: json['runtime'],
      slug: json['slug'],
      small_cover_image: json['small_cover_image'],
      title: json['title'],
      title_english: json['title_english'],
      title_long: json['title_long'],
      torrents: json['torrents'] != null
          ? (json['torrents'] as List).map((i) => Torrent.fromJson(i)).toList()
          : null,
      url: json['url'],
      year: json['year'],
      yt_trailer_code: json['yt_trailer_code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['background_image'] = this.background_image;
    data['background_image_original'] = this.background_image_original;
    data['date_uploaded'] = this.date_uploaded;
    data['date_uploaded_unix'] = this.date_uploaded_unix;
    data['description_full'] = this.description_full;
    data['description_intro'] = this.description_intro;
    data['download_count'] = this.download_count;
    data['id'] = this.id;
    data['imdb_code'] = this.imdb_code;
    data['language'] = this.language;
    data['large_cover_image'] = this.large_cover_image;
    data['like_count'] = this.like_count;
    data['medium_cover_image'] = this.medium_cover_image;
    data['mpa_rating'] = this.mpa_rating;
    data['rating'] = this.rating;
    data['runtime'] = this.runtime;
    data['slug'] = this.slug;
    data['small_cover_image'] = this.small_cover_image;
    data['title'] = this.title;
    data['title_english'] = this.title_english;
    data['title_long'] = this.title_long;
    data['url'] = this.url;
    data['year'] = this.year;
    data['yt_trailer_code'] = this.yt_trailer_code;
    if (this.genres != null) {
      data['genres'] = this.genres;
    }
    if (this.torrents != null) {
      data['torrents'] = this.torrents.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object> get props => [
        background_image,
        background_image_original,
        date_uploaded,
        date_uploaded_unix,
        description_full,
        description_intro,
        download_count,
        id,
        imdb_code,
        language,
        large_cover_image,
        like_count,
        medium_cover_image,
        mpa_rating,
        rating,
        runtime,
        slug,
        small_cover_image,
        title,
        title_english,
        title_long,
        url,
        year,
        yt_trailer_code,
        genres,
        torrents,
      ];
}
