import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showvis/features/shows_catalog/presentation/catalog/shows_catalog_ui.dart';
import 'package:showvis/main.dart';

import '../../../test_dependencies.dart';
import '../domain/shows_catalog_usecase_test.dart';

void main() {
  testWidgets('ShowCatalog list screen', (tester) async {
    registerTestFavoritesPersistanceDependency();
    registerTestHttpDependency(showsSuccessResponse);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: globalContainer,
        child: MaterialApp(
          home: ShowsCatalogUI(),
        ),
      ),
    );
    //await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));

    final tile = find.byType(ShowTileWidget);
    expect(tile, findsOneWidget);
    expect(
        find.descendant(
            of: tile, matching: find.byKey(const Key('showImage1'))),
        findsOneWidget);
    expect(find.descendant(of: tile, matching: find.text('Under the Dome')),
        findsOneWidget);
    expect(find.descendant(of: tile, matching: find.byType(ShowRatingWidget)),
        findsOneWidget);
    expect(
        find.descendant(of: tile, matching: find.text('6.5')), findsOneWidget);

    //debugDumpApp();
  });
}
