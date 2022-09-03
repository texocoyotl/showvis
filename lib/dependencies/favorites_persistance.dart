import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:showvis/core/models.dart';

abstract class FavoritesPersistance {
  void dispose();
  Future<bool> persistFavoriteShows(Map<int, Show> shows);
  Future<Map<int, Show>> retrieveFavoriteShows();
}

class FavoritesPersistanceImpl implements FavoritesPersistance {
  @override
  void dispose() {}

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/showvis_cache.json');
  }

  @override
  Future<bool> persistFavoriteShows(Map<int, Show> shows) async {
    final filePath = await _localFile;
    final json = [for (Show show in shows.values) show.toJson()];
    final jsonString = jsonEncode(json);
    try {
      await filePath.writeAsString(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<int, Show>> retrieveFavoriteShows() async {
    final filePath = await _localFile;
    final Map<int, Show> shows = {};

    try {
      final jsonString = await filePath.readAsString();
      final List<dynamic> json = jsonDecode(jsonString);
      shows.addAll({for (var show in json) show['id']: Show.fromJson(show)});
    } catch (e) {
      print('No data has been retrieved.');
    }
    return shows;
  }
}
