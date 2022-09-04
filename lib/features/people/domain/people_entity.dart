import 'package:showvis/core/architecture_components.dart';
import 'package:showvis/core/models.dart';
import 'package:showvis/core/stateful_collections.dart';

class PeopleEntity extends Entity {
  PeopleEntity(
      {StatefulMap<int, Person>? people, StatefulMap<int, Show>? shows})
      : people = people ?? StatefulMap<int, Person>(),
        shows = shows ?? StatefulMap<int, Show>();

  final StatefulMap<int, Person> people;
  final StatefulMap<int, Show> shows;

  @override
  List<Object?> get props => [people, shows];

  PeopleEntity merge(
          {StatefulMap<int, Person>? people, StatefulMap<int, Show>? shows}) =>
      PeopleEntity(
        people: people ?? this.people,
        shows: shows ?? this.shows,
      );
}
