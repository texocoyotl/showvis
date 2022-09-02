import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';

class ShowsCatalogViewModel extends ViewModel {
  const ShowsCatalogViewModel({
    required this.fromSearch,
  });

  final bool fromSearch;
  @override
  List<Object?> get props => [];
}

class ShowsCatalogLoadingViewModel extends ShowsCatalogViewModel {
  const ShowsCatalogLoadingViewModel({required super.fromSearch});
}

class ShowsCatalogWithContentViewModel extends ShowsCatalogViewModel {
  const ShowsCatalogWithContentViewModel(
      {required super.fromSearch, required this.refresh});

  final VoidCallback refresh;
}

class ShowsCatalogNetworkFailureViewModel
    extends ShowsCatalogWithContentViewModel {
  const ShowsCatalogNetworkFailureViewModel(
      {required this.retry, required super.fromSearch, required super.refresh});

  final ValueChanged<String> retry;
}

class ShowsCatalogSuccessViewModel extends ShowsCatalogWithContentViewModel {
  const ShowsCatalogSuccessViewModel(
      {required this.shows,
      required super.fromSearch,
      required super.refresh,
      required this.openDetails,
      required this.search,
      required this.goToPreviousPage,
      required this.goToNextPage});

  final List<Show> shows;

  final ValueChanged<int> openDetails;
  final ValueChanged<String> search;
  final VoidCallback goToPreviousPage;
  final VoidCallback goToNextPage;

  @override
  List<Object?> get props => [shows, fromSearch];
}

// class ShowsCatalogSearchSuccessViewModel extends ShowsCatalogViewModel {
//   const ShowsCatalogSearchSuccessViewModel({
//     required this.shows,
//     required this.searchText,
//     required this.openDetails,
//   });

//   final List<Show> shows;
//   final String searchText;
//   final ValueChanged<int> openDetails;

//   @override
//   List<Object?> get props => [shows, searchText];
// }
