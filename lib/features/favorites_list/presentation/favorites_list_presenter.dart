import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/favorites_list/domain/favorites_list_entity.dart';
import 'package:showvis/features/favorites_list/domain/favorites_list_usecase.dart';
import 'package:showvis/features/favorites_list/presentation/favorites_list_view_model.dart';
import 'package:showvis/router.dart';

class FavoritesListPresenter extends Presenter<FavoritesListUseCase,
    FavoritesListEntity, FavoritesListViewModel> {
  FavoritesListPresenter(
      {super.key, required PresenterBuilder<FavoritesListViewModel> builder})
      : super(builder: builder, provider: favoritesListUseCase);

  @override
  FavoritesListViewModel createViewModel(
          FavoritesListUseCase useCase, FavoritesListEntity entity) =>
      FavoritesListViewModel(
          shows: entity.favoriteShows.values.toList()
            ..sort(
              (previous, next) => previous.name.compareTo(next.name),
            ),
          openDetails: (id) {
            router.push('/details/$id');
          });
}
