import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';

class FavoritesListEntity extends Entity {
  const FavoritesListEntity({this.favoriteShows = const {}});

  final Map<int, Show> favoriteShows;

  @override
  List<Object?> get props => [favoriteShows];
}
