import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/dependencies/http_client.dart';
import 'package:showvis/features/people/domain/people_entity.dart';
import 'package:showvis/main.dart';

class PeopleUseCase extends UseCase<PeopleEntity> {
  PeopleUseCase() : super(entity: PeopleEntity());

  Future<void> searchPeople(String text) async {
    if (text.trim().isEmpty) return;

    entity = entity.merge(
        people: StatefulMap(map: const {}, state: CollectionState.loading));

    print('Search for People with $text');

    final JsonResponse res =
        await getIt<HttpClient>().query(path: 'search/people?q=$text');

    if (res is JsonFailureResponse) {
      entity = entity.merge(
          people: StatefulMap<int, Person>(
              map: const {}, state: CollectionState.networkError));
      return;
    }

    final List<dynamic> list = (res as JsonSuccessResponse).content;

    entity = entity.merge(
      people: StatefulMap<int, Person>(map: {
        for (var person in list)
          person['person']['id']: Person.fromJson(person['person'])
      }, state: CollectionState.populated),
    );
  }

  void cancelSearch() {
    entity = entity.merge(
        people: StatefulMap(map: const {}, state: CollectionState.initial));
  }

  Future<void> fetchShows(int peopleId) async {}
}

final peopleUseCase = UseCaseProvider<PeopleEntity, PeopleUseCase>(
  (_) => PeopleUseCase(),
);
