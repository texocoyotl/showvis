import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';

class ShowsCatalogViewModel extends ViewModel {
  const ShowsCatalogViewModel();
  @override
  List<Object?> get props => [];
}

class ShowsCatalogLoadingViewModel extends ShowsCatalogViewModel {
  const ShowsCatalogLoadingViewModel();
}

class ShowsCatalogNetworkFailureViewModel extends ShowsCatalogViewModel {
  const ShowsCatalogNetworkFailureViewModel({required this.retry});

  final VoidCallback retry;
}

class ShowsCatalogSuccessViewModel extends ShowsCatalogViewModel {
  const ShowsCatalogSuccessViewModel(
      {required this.shows, required this.openDetails});

  final List<ShowSummary> shows;
  final ValueChanged<int> openDetails;

  @override
  List<Object?> get props => [shows];
}
