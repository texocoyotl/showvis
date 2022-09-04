import 'package:flutter/material.dart';
import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/core/stateful_collections.dart';

class PeopleSearchViewModel extends ViewModel {
  const PeopleSearchViewModel({
    required this.people,
    required this.search,
    required this.cancelSearch,
    required this.openDetails,
  });

  final StatefulList<Person> people;
  final ValueChanged<String> search;
  final VoidCallback cancelSearch;
  final ValueChanged<int> openDetails;

  @override
  List<Object?> get props => [people];
}
