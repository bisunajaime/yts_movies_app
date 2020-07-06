import 'package:equatable/equatable.dart';

class Torrent extends Equatable {
  String date_uploaded;
  int date_uploaded_unix;
  String hash;
  int peers;
  String quality;
  int seeds;
  String size;
  int size_bytes;
  String type;
  String url;

  Torrent(
      {this.date_uploaded,
      this.date_uploaded_unix,
      this.hash,
      this.peers,
      this.quality,
      this.seeds,
      this.size,
      this.size_bytes,
      this.type,
      this.url});

  factory Torrent.fromJson(Map<String, dynamic> json) {
    return Torrent(
      date_uploaded: json['date_uploaded'],
      date_uploaded_unix: json['date_uploaded_unix'],
      hash: json['hash'],
      peers: json['peers'],
      quality: json['quality'],
      seeds: json['seeds'],
      size: json['size'],
      size_bytes: json['size_bytes'],
      type: json['type'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_uploaded'] = this.date_uploaded;
    data['date_uploaded_unix'] = this.date_uploaded_unix;
    data['hash'] = this.hash;
    data['peers'] = this.peers;
    data['quality'] = this.quality;
    data['seeds'] = this.seeds;
    data['size'] = this.size;
    data['size_bytes'] = this.size_bytes;
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }

  @override
  List<Object> get props => [
        date_uploaded,
        date_uploaded_unix,
        hash,
        peers,
        quality,
        seeds,
        size,
        size_bytes,
        type,
        url,
      ];
}
