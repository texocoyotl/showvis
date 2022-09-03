import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';

class ShowsCatalogViewModel extends ViewModel {
  const ShowsCatalogViewModel(
      {required this.shows,
      required this.fromSearch,
      required this.isLoading,
      required this.hasError,
      required this.refresh,
      required this.openDetails,
      required this.search,
      required this.goToNextPage,
      required this.retry});

  final List<Show> shows;
  final bool fromSearch;
  final bool isLoading;
  final bool hasError;

  final ValueChanged<int> openDetails;
  final ValueChanged<String> search;
  final VoidCallback goToNextPage;

  final ValueChanged<String> retry;
  final VoidCallback refresh;
  @override
  List<Object?> get props => [shows, fromSearch, isLoading, hasError];
}
