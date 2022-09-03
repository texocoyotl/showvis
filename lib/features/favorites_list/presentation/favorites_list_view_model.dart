import 'package:flutter/foundation.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';

class FavoritesListViewModel extends ViewModel {
  const FavoritesListViewModel(
      {required this.shows, required this.openDetails});

  final List<Show> shows;
  final ValueChanged<int> openDetails;

  @override
  List<Object?> get props => [shows];
}
