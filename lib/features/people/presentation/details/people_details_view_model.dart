import 'package:flutter/foundation.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/stateful_collections.dart';

class PeopleDetailsViewModel extends ViewModel {
  const PeopleDetailsViewModel({
    required this.name,
    required this.gender,
    required this.birthday,
    required this.country,
    required this.countryCode,
    required this.imageUri,
    required this.shows,
    required this.onTabChange,
    required this.goToShow,
  });

  final String name;
  final String gender;
  final String birthday;
  final String country;
  final String countryCode;
  final String imageUri;

  final StatefulList shows;

  final ValueChanged<int> onTabChange;
  final ValueChanged<int> goToShow;

  @override
  List<Object?> get props => [
        name,
        gender,
        birthday,
        country,
        countryCode,
        imageUri,
        shows,
      ];
}
