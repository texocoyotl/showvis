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

  Future<void> fetchShows(int peopleId) async {
    // If the list is already fetched, this will avoid doing the query again
    // when the user is just tapping the tabs back and forth
    if (entity.shows.state == CollectionState.populated) return;

    entity = entity.merge(
        shows: StatefulMap(map: const {}, state: CollectionState.loading));

    final JsonResponse res = await getIt<HttpClient>()
        .query(path: 'people/$peopleId/castcredits?embed=show');

    if (res is JsonFailureResponse) {
      entity = entity.merge(
          shows:
              StatefulMap(map: const {}, state: CollectionState.networkError));
      return;
    }

    final shows = <int, Show>{
      for (var data in (res as JsonSuccessResponse).content)
        data['_embedded']['show']['id']:
            Show.fromJson(data['_embedded']['show'])
    };

    entity = entity.merge(
        shows: StatefulMap(map: shows, state: CollectionState.populated));
  }

  void clearShows() {
    entity = entity.merge(
        shows: StatefulMap(map: const {}, state: CollectionState.loading));
  }
}

final peopleUseCase = UseCaseProvider<PeopleEntity, PeopleUseCase>(
  (_) => PeopleUseCase(),
);
