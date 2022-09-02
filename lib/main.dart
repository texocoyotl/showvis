import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:showvis/dependencies/http_client/http_client.dart';
import 'package:showvis/router.dart';

GetIt getIt = GetIt.instance;
final globalContainer = ProviderContainer();

void main() async {
  getIt.registerSingleton<HttpClient>(
      HttpClientImpl(baseUrl: 'https://api.tvmaze.com/'),
      signalsReady: true);

  runApp(UncontrolledProviderScope(
      container: globalContainer, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.deepPurple,
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
