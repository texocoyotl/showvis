import 'package:equatable/equatable.dart';

enum CollectionState { initial, loading, populated, networkError }

class StatefulList<E> extends Equatable {
  StatefulList({
    List<E>? list,
    this.state = CollectionState.initial,
  }) : list = list ?? <E>[];
  final List<E> list;
  final CollectionState state;

  @override
  List<Object?> get props => [list, state];
}

class StatefulMap<K, V> extends Equatable {
  StatefulMap({
    Map<K, V>? map,
    this.state = CollectionState.initial,
  }) : map = map ?? <K, V>{};
  final Map<K, V> map;
  final CollectionState state;

  @override
  List<Object?> get props => [map, state];
}
