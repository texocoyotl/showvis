import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';

class ShowsCatalogViewModel extends ViewModel {
  const ShowsCatalogViewModel({required this.fetchShows, required this.shows});

  final VoidCallback fetchShows;
  final List<ShowSummary> shows;

  @override
  List<Object?> get props => [shows];
}
