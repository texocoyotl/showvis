import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/stateful_collections.dart';

class ShowDetailsViewModel extends ViewModel {
  const ShowDetailsViewModel({
    required this.name,
    required this.largeImageUri,
    required this.genres,
    required this.premiered,
    required this.ended,
    required this.timeSchedule,
    required this.daysSchedule,
    required this.summary,
    required this.rating,
    required this.episodes,
    required this.isFavorite,
    required this.onTabChange,
    required this.toggleFavorite,
  });

  final String name;
  final String largeImageUri;
  final String genres;
  final String premiered;
  final String ended;
  final String timeSchedule;
  final String daysSchedule;
  final String summary;
  final String rating;
  final bool isFavorite;
  final StatefulMap episodes;

  final ValueChanged<int> onTabChange;
  final VoidCallback toggleFavorite;

  @override
  List<Object?> get props => [
        name,
        largeImageUri,
        genres,
        premiered,
        ended,
        timeSchedule,
        daysSchedule,
        summary,
        rating,
        isFavorite,
        episodes,
      ];
}
