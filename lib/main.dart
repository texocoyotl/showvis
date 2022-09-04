import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:showvis/dependencies/favorites_persistance.dart';
import 'package:showvis/dependencies/http_client.dart';
import 'package:showvis/router.dart';

GetIt getIt = GetIt.instance;
final globalContainer = ProviderContainer();

void main() async {
  registerDependencies();
  runApp(UncontrolledProviderScope(
      container: globalContainer, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light().copyWith(
          primary: const Color(0xFF673AB7),
        ),
        indicatorColor: Colors.white,
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyLarge: ThemeData.light().textTheme.bodyLarge!.copyWith(
                    //fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
            ),
      ),
      darkTheme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light().copyWith(
          primary: const Color(0xFF673AB7),
        ),
        indicatorColor: Colors.white,
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyLarge: ThemeData.light().textTheme.bodyLarge!.copyWith(
                    //fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
            ),
      ),
    );
  }
}

void registerDependencies() {
  getIt.registerSingleton<HttpClient>(
    HttpClientImpl(baseUrl: 'https://api.tvmaze.com/'),
    signalsReady: true,
    dispose: (instance) => instance.dispose(),
  );
  getIt.registerSingleton<FavoritesPersistance>(
    FavoritesPersistanceImpl(),
    signalsReady: true,
    dispose: (instance) => instance.dispose(),
  );
}
