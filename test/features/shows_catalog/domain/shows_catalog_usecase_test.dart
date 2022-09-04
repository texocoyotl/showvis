import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:showvis/core/stateful_collections.dart';
import 'package:showvis/dependencies/http_client.dart';
import 'package:showvis/features/shows_catalog/domain/shows_catalog_usecase.dart';

import '../../../test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ShowsCatalogUseCase useCase;
  StreamSubscription? listener;

  setUp(() {
    registerTestFavoritesPersistanceDependency();
    useCase = ShowsCatalogUseCase();
  });

  tearDownAll(() {
    listener?.cancel();
  });
  test('ShowsCatalogUseCase init, favorite shows list should be empty',
      () async {
    expect(useCase.entity.favoriteShows, isEmpty);
  });

  test('ShowsCatalogUseCase fetch shows with success', () async {
    registerTestHttpDependency(showsSuccessResponse);

    listener = useCase.stream.listen((entity) {
      expect(
          (entity.showsInView.map.isEmpty &&
                  entity.showsInView.state == CollectionState.loading) ||
              (entity.showsInView.map.length == 1 &&
                  entity.showsInView.state == CollectionState.populated),
          isTrue);
    });

    useCase.fetchShowsInView();
  }, timeout: const Timeout(Duration(milliseconds: 500)));

  test('ShowsCatalogUseCase fetch shows with failure', () async {
    registerTestHttpDependency(const JsonFailureResponse());

    listener = useCase.stream.listen((entity) {
      expect(
          (entity.showsInView.map.isEmpty &&
                  entity.showsInView.state == CollectionState.loading) ||
              (entity.showsInView.map.isEmpty &&
                  entity.showsInView.state == CollectionState.networkError),
          isTrue);
    });

    useCase.fetchShowsInView();
  }, timeout: const Timeout(Duration(milliseconds: 500)));

  test('ShowsCatalogUseCase search for shows with success', () async {
    registerTestHttpDependency(showSearchSuccessResponse);

    listener = useCase.stream.listen((entity) {
      expect(
          (entity.showsInView.map.isEmpty &&
                  entity.showsInView.state == CollectionState.loading) ||
              (entity.showsInView.map.length == 1 &&
                  entity.showsInView.state == CollectionState.populated),
          isTrue);
    });

    useCase.search('test');
  }, timeout: const Timeout(Duration(milliseconds: 500)));

  test('ShowsCatalogUseCase search for shows with failure', () async {
    registerTestHttpDependency(const JsonFailureResponse());

    listener = useCase.stream.listen((entity) {
      expect(
          (entity.showsInView.map.isEmpty &&
                  entity.showsInView.state == CollectionState.loading) ||
              (entity.showsInView.map.isEmpty &&
                  entity.showsInView.state == CollectionState.networkError),
          isTrue);
    });

    useCase.search('test');
  }, timeout: const Timeout(Duration(milliseconds: 500)));
}

const showsSuccessResponse = JsonSuccessResponse(<dynamic>[
  {
    "id": 1,
    "url": "https://www.tvmaze.com/shows/1/under-the-dome",
    "name": "Under the Dome",
    "type": "Scripted",
    "language": "English",
    "genres": ["Drama", "Science-Fiction", "Thriller"],
    "status": "Ended",
    "runtime": 60,
    "averageRuntime": 60,
    "premiered": "2013-06-24",
    "ended": "2015-09-10",
    "officialSite": "http://www.cbs.com/shows/under-the-dome/",
    "schedule": {
      "time": "22:00",
      "days": ["Thursday"]
    },
    "rating": {"average": 6.5},
    "weight": 99,
    "network": {
      "id": 2,
      "name": "CBS",
      "country": {
        "name": "United States",
        "code": "US",
        "timezone": "America/New_York"
      },
      "officialSite": "https://www.cbs.com/"
    },
    "webChannel": null,
    "dvdCountry": null,
    "externals": {"tvrage": 25988, "thetvdb": 264492, "imdb": "tt1553656"},
    "image": {
      "medium":
          "https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
      "original":
          "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"
    },
    "summary":
        "<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>",
    "updated": 1631010933,
    "_links": {
      "self": {"href": "https://api.tvmaze.com/shows/1"},
      "previousepisode": {"href": "https://api.tvmaze.com/episodes/185054"}
    }
  },
]);

const showSearchSuccessResponse = JsonSuccessResponse([
  {
    "score": 0.9075305,
    "show": {
      "id": 318,
      "url": "https://www.tvmaze.com/shows/318/community",
      "name": "Community",
      "type": "Scripted",
      "language": "English",
      "genres": ["Comedy"],
      "status": "Ended",
      "runtime": 30,
      "averageRuntime": 30,
      "premiered": "2009-09-17",
      "ended": "2015-06-02",
      "officialSite": "http://www.nbc.com/community",
      "schedule": {
        "time": "",
        "days": ["Tuesday"]
      },
      "rating": {"average": 8.3},
      "weight": 93,
      "network": null,
      "webChannel": {
        "id": 5,
        "name": "YAHOO! View",
        "country": {
          "name": "United States",
          "code": "US",
          "timezone": "America/New_York"
        },
        "officialSite": null
      },
      "dvdCountry": null,
      "externals": {"tvrage": 22589, "thetvdb": 94571, "imdb": "tt1439629"},
      "image": {
        "medium":
            "https://static.tvmaze.com/uploads/images/medium_portrait/2/5134.jpg",
        "original":
            "https://static.tvmaze.com/uploads/images/original_untouched/2/5134.jpg"
      },
      "summary":
          "<p><b>Community </b>is a smart, exuberant comedy that is consistently ranked as one of the most inventive and original half-hours on television. This ensemble comedy centers around a tight-knit group of friends who all met at what is possibly the world's worst educational institution - Greendale Community College.</p>",
      "updated": 1652409307,
      "_links": {
        "self": {"href": "https://api.tvmaze.com/shows/318"},
        "previousepisode": {"href": "https://api.tvmaze.com/episodes/162188"}
      }
    }
  },
]);
