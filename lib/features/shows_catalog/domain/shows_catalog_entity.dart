import 'package:equatable/equatable.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:html/parser.dart';

class ShowsCatalogEntity extends Entity {
  const ShowsCatalogEntity(
      {this.shows = const {}, this.state = EntityState.initial});

  final Map<int, Show> shows;
  final EntityState state;

  ShowsCatalogEntity merge({Map<int, Show>? shows, EntityState? state}) =>
      ShowsCatalogEntity(
        shows: shows ?? this.shows,
        state: state ?? this.state,
      );

  @override
  List<Object?> get props => [shows, state];
}

enum EntityState { initial, loading, networkError, completed }

class Show extends Equatable {
  const Show(
      {required this.id,
      required this.name,
      required this.smallImageUri,
      required this.largeImageUri,
      required this.genres,
      required this.premiered,
      required this.ended,
      required this.timeSchedule,
      required this.daysSchedule,
      required this.summary,
      required this.rating});

  factory Show.fromJson(Map<String, dynamic> json) => Show(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        smallImageUri: json['image']['medium'] ?? '',
        largeImageUri: json['image']['original'] ?? '',
        genres: [for (String genre in json['genres'] ?? const []) genre],
        premiered: DateTime.tryParse(json['premiered']) ?? DateTime.now(),
        ended: DateTime.parse(json['ended'] ?? '2099-01-01'),
        timeSchedule:
            DateTime.tryParse(json['schedule']['time']) ?? DateTime.now(),
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
  final String smallImageUri; // TODO Replace with Uri class
  final String largeImageUri; // TODO Replace with Uri class
  final List<String> genres; //TODO Convert to enum
  final DateTime premiered;
  final DateTime ended;
  final DateTime timeSchedule;
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
