import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/dependencies/favorites_persistance.dart';
import 'package:showvis/dependencies/http_client.dart';

GetIt getIt = GetIt.instance;

void registerTestHttpDependency(JsonResponse response) {
  getIt.allowReassignment = true;

  final client = HttpClientTest();
  getIt.registerSingleton<HttpClient>(
    client,
    signalsReady: true,
    dispose: (instance) => instance.dispose(),
  );
  when(() => client.query(path: any(named: 'path')))
      .thenAnswer((_) async => response);

  // getIt.registerFactoryParam<HttpClient, JsonResponse, void>(
  //     (s, _) => HttpClientTest(response: s));
}

void registerTestFavoritesPersistanceDependency() {
  getIt.allowReassignment = true;

  getIt.registerSingleton<FavoritesPersistance>(
    FavoritesPersistanceTest(),
    signalsReady: true,
    dispose: (instance) => instance.dispose(),
  );
}

class HttpClientTest extends Mock implements HttpClient {}

class FavoritesPersistanceTest implements FavoritesPersistance {
  @override
  void dispose() {}

  Map<int, Show> shows = {};
  late bool didSave;

  @override
  Future<bool> persistFavoriteShows(Map<int, Show> shows) async {
    return didSave;
  }

  @override
  Future<Map<int, Show>> retrieveFavoriteShows() async {
    return shows;
  }
}
