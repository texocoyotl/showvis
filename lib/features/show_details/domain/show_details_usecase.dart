import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/dependencies/http_client/http_client.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_entity.dart';
import 'package:showvis/main.dart';

class ShowsCatalogUseCase extends UseCase<ShowsCatalogEntity> {
  ShowsCatalogUseCase() : super(entity: const ShowsCatalogEntity());

  void fetch() async {
    // this will create a new view model, followed by an UI update
    entity = entity.merge(state: EntityState.loading);

    final JsonResponse res =
        await getIt<HttpClient>().query(path: 'shows?page=0', onError: (_) {});

    if (res is JsonFailureResponse) {
      entity = entity.merge(state: EntityState.networkError);

      // Once an state is published, a second update is triggered to clean error states
      // Future.delayed(Duration(milliseconds: 100), () async {
      //   entity = entity.merge(state: EntityState.initial);
      // });

      return;
    }

    // With successful data received, the state obtains the response, producing
    // the normal view model / UI update
    final List<dynamic> list = (res as JsonSuccessResponse).content;
    entity = entity.merge(
      state: EntityState.completed,
      shows: {for (var show in list) show['id']: Show.fromJson(show)},
    );
  }
}

final showsCatalogUseCase =
    UseCaseProvider<ShowsCatalogEntity, ShowsCatalogUseCase>(
  (_) => ShowsCatalogUseCase(),
);
