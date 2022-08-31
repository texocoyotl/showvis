import 'package:equatable/equatable.dart';
import 'package:showvis/core/architecture_components.dart';

class ShowsCatalogEntity extends Entity {
  const ShowsCatalogEntity(
      {this.shows = const [], this.state = EntityState.initial});

  final List<ShowSummary> shows;
  final EntityState state;

  ShowsCatalogEntity merge({List<ShowSummary>? shows, EntityState? state}) =>
      ShowsCatalogEntity(
        shows: shows ?? this.shows,
        state: state ?? this.state,
      );

  @override
  List<Object?> get props => [shows, state];
}

enum EntityState { initial, loading, networkError, completed }

class ShowSummary extends Equatable {
  const ShowSummary({
    required this.id,
    required this.name,
    required this.smallImageUri,
    required this.largeImageUri,
    required this.genres,
  });

  final int id;
  final String name;
  final String smallImageUri; // TODO Replace with Uri class
  final String largeImageUri; // TODO Replace with Uri class
  final List<String> genres; //TODO Convert to enum

  @override
  List<Object?> get props => [id, name, smallImageUri, largeImageUri, genres];

  // ShowSummary merge({
  //   String? id,
  //   String? name,
  //   String? smallImageUri,
  //   String? largeImageUri,
  //   List<String>? genres,
  // }) =>
  //     ShowSummary(
  //       id: id ?? this.id,
  //       name: name ?? this.name,
  //       smallImageUri: smallImageUri ?? this.smallImageUri,
  //       largeImageUri: largeImageUri ?? this.largeImageUri,
  //       genres: genres ?? this.genres,
  //     );
}
