import 'package:equatable/equatable.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:html/parser.dart';
import 'package:showvis/core/stateful_collections.dart';

class ShowsCatalogEntity extends Entity {
  ShowsCatalogEntity({
    StatefulList<Show>? showsInView,
    this.fromSearch = false,
    StatefulMap<int, Map<int, Episode>>? episodes,
  })  : showsInView = showsInView ?? StatefulList<Show>(),
        episodes = episodes ?? StatefulMap<int, Map<int, Episode>>();

  final StatefulList<Show> showsInView;
  final bool fromSearch;
  final StatefulMap<int, Map<int, Episode>> episodes;

  ShowsCatalogEntity merge(
          {Map<int, Show>? shows,
          bool? fromSearch,
          EntityState? state,
          StatefulList<Show>? showsInView,
          StatefulMap<int, Map<int, Episode>>? episodes}) =>
      ShowsCatalogEntity(
        showsInView: showsInView ?? this.showsInView,
        fromSearch: fromSearch ?? this.fromSearch,
        episodes: episodes ?? this.episodes,
      );

  @override
  List<Object?> get props => [showsInView, fromSearch, episodes];
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
        premiered: DateTime.parse(json['premiered'] ?? '2099-01-01'),
        ended: DateTime.parse(json['ended'] ?? '2099-01-01'),
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
        summary: parse(json['summary']).documentElement!.text,
        imageUrl: json['image']['original'] ?? '',
        airDate: DateTime.parse(
            '${json['airdate'] ?? '2099-01-01'} ${json['airtime'] ?? '00:00'}'),
      );

  @override
  List<Object?> get props =>
      [id, name, season, number, summary, imageUrl, airDate];
}
