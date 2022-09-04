import 'package:equatable/equatable.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class Show extends Equatable {
  const Show({
    required this.id,
    required this.name,
    required this.smallImageUri,
    required this.largeImageUri,
    required this.genres,
    required this.premiered,
    required this.ended,
    required this.timeSchedule,
    required this.daysSchedule,
    required this.summary,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': {
          'medium': smallImageUri,
          'original': largeImageUri,
        },
        'genres': genres,
        'premiered': premiered.toIso8601String(),
        'ended': ended.toIso8601String(),
        'schedule': {
          'time': timeSchedule,
          'days': daysSchedule,
        },
        'summary': '<p>$summary</p>',
        'rating': {
          'average': rating,
        }
      };

  factory Show.fromJson(Map<String, dynamic> json) => Show(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        smallImageUri:
            (json['image'] == null) ? '' : json['image']['medium'] ?? '',
        largeImageUri:
            (json['image'] == null) ? '' : json['image']['original'] ?? '',
        genres: [for (String genre in json['genres'] ?? const []) genre],
        premiered: DateTime.parse(json['premiered'] ?? '2999-01-01'),
        ended: DateTime.parse(json['ended'] ?? '2999-01-01'),
        timeSchedule: json['schedule']['time'] ?? '',
        daysSchedule: [
          for (String day in json['schedule']['days'] ?? const []) day
        ],
        summary: parse(json['summary']).documentElement!.text,
        rating: (json['rating']['average'] is int)
            ? double.parse((json['rating']['average'] ?? 0.0).toString())
            : json['rating']['average'] ?? 0.0,
      );

  final int id;
  final String name;
  final String smallImageUri;
  final String largeImageUri;
  final List<String> genres; //TODO Convert to enum
  final DateTime premiered;
  final DateTime ended;
  final String timeSchedule;
  final List<String> daysSchedule;
  final String summary;
  final double rating;

  @override
  List<Object?> get props => [
        id,
        name,
        smallImageUri,
        largeImageUri,
        genres,
        premiered,
        ended,
        timeSchedule,
        daysSchedule,
        summary,
        rating,
      ];
}

class Episode extends Equatable {
  final int id;
  final String name;
  final int season;
  final int number;
  final String summary;
  final String imageUrl;
  final DateTime airDate;

  const Episode({
    required this.id,
    required this.name,
    required this.season,
    required this.number,
    required this.summary,
    required this.imageUrl,
    required this.airDate,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: json['id'],
        name: json['name'] ?? '',
        season: json['season'],
        number: json['number'],
        summary: parse(json['summary'] ?? '').documentElement!.text,
        imageUrl:
            (json['image'] == null) ? '' : json['image']['original'] ?? '',
        airDate: DateTime.parse(
            '${json['airdate'] ?? '2999-01-01'} ${json['airtime'] ?? '00:00'}'),
      );

  @override
  List<Object?> get props =>
      [id, name, season, number, summary, imageUrl, airDate];
}

class Person extends Equatable {
  const Person({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthday,
    required this.country,
    required this.countryCode,
    required this.imageUri,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json['id'],
        name: json['name'] ?? '',
        gender: json['gender'] ?? '',
        birthday: DateTime.parse(json['birthday'] ?? '2999-01-01'),
        country:
            (json['country'] == null) ? '' : json['country']!['name'] ?? '',
        countryCode:
            (json['country'] == null) ? '' : json['country']!['name'] ?? '',
        imageUri:
            (json['image'] == null) ? '' : json['image']['original'] ?? '',
      );

  final int id;
  final String name;
  final String gender;
  final DateTime birthday;
  final String country;
  final String countryCode;
  final String imageUri;

  @override
  List<Object?> get props => [
        id,
        name,
        gender,
        birthday,
        country,
        countryCode,
        imageUri,
      ];
}
