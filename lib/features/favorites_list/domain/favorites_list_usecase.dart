import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/favorites_list/domain/favorites_list_entity.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_usecase.dart';
import 'package:showvis/main.dart';

class FavoritesListUseCase extends UseCase<FavoritesListEntity> {
  FavoritesListUseCase() : super(entity: const FavoritesListEntity()) {
    final showsUseCase =
        showsCatalogUseCase.getUseCaseFromContext(globalContainer);
    showsUseCase.addListener(_showsCatalogUseCaseListener);
  }

  void _showsCatalogUseCaseListener(ShowsCatalogEntity showsEntity) {
    entity = FavoritesListEntity(favoriteShows: showsEntity.favoriteShows);
  }
}

final favoritesListUseCase =
    UseCaseProvider<FavoritesListEntity, FavoritesListUseCase>(
  (_) => FavoritesListUseCase(),
);
