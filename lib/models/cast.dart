import 'package:equatable/equatable.dart';

class CastModel extends Equatable {
  String character_name;
  String imdb_code;
  String name;
  String url_small_image;

  CastModel(
      {this.character_name, this.imdb_code, this.name, this.url_small_image});

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      character_name: json['character_name'],
      imdb_code: json['imdb_code'],
      name: json['name'],
      url_small_image: json['url_small_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['character_name'] = this.character_name;
    data['imdb_code'] = this.imdb_code;
    data['name'] = this.name;
    data['url_small_image'] = this.url_small_image;
    return data;
  }

  @override
  List<Object> get props => [
        character_name,
        imdb_code,
        name,
        url_small_image,
      ];
}
