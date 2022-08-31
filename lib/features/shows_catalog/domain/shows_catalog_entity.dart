import 'package:equatable/equatable.dart';
import 'package:showvis/core/architecture_components.dart';

class ShowsCatalogEntity extends Entity {
  const ShowsCatalogEntity({this.shows = const []});

  final List<ShowSummary> shows;

  ShowsCatalogEntity merge({List<ShowSummary>? shows}) =>
      ShowsCatalogEntity(shows: shows ?? this.shows);

  @override
  List<Object?> get props => [shows];
}

class ShowSummary extends Equatable {
  const ShowSummary({
    this.id = '',
    this.name = '',
    this.smallImageUri = '',
    this.largeImageUri = '',
    this.genres = const [],
  });

  final String id;
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
