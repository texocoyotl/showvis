import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';

class ShowsCatalogUseCase extends UseCase<ShowsCatalogEntity> {
  ShowsCatalogUseCase() : super(entity: const ShowsCatalogEntity());

  void fetch() {
    entity = entity.merge(shows: [
      const ShowSummary(
        id: '1',
        name: 'Under the Dome',
        smallImageUri:
            'https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg',
        largeImageUri:
            'https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg',
        genres: ['Drama', 'Science-Fiction', 'Thriller'],
      )
    ]);
  }
}

final showsCatalogUseCase =
    UseCaseProvider<ShowsCatalogEntity, ShowsCatalogUseCase>(
  (_) => ShowsCatalogUseCase(),
);
