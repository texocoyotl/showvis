import 'package:equatable/equatable.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
abstract class Entity extends Equatable {
  const Entity();

  @override
  bool get stringify => true;
}

abstract class UseCase<E extends Entity> extends StateNotifier<E> {
  UseCase({required E entity}) : super(entity);

  @visibleForTesting
  @protected
  E get entity => super.state;

  @protected
  set entity(newEntity) => super.state = newEntity;
}

class UseCaseProvider<E extends Entity, U extends UseCase<E>> {
  final StateNotifierProvider<U, E> _provider;
  final U Function(Ref) create;

  UseCaseProvider(this.create)
      : _provider = StateNotifierProvider<U, E>(create);

  U getUseCase(WidgetRef ref) => ref.watch(_provider.notifier);

  U getUseCaseFromContext(ProviderContainer container) {
    return container.read(_provider.notifier);
  }

  E subscribe(WidgetRef ref) {
    return ref.watch(_listenForChanges(ref));
  }

  void listen(WidgetRef ref, void Function(E?, E) listener) {
    ref.listen<E>(_listenForChanges(ref), listener);
  }

  AlwaysAliveProviderListenable<E> _listenForChanges(
    WidgetRef ref,
  ) {
    final useCase = getUseCase(ref);
    return _provider.select((e) => useCase.entity);
  }
}

typedef ProviderListener<E extends Entity> = void Function(E entity);

@immutable
abstract class ViewModel extends Equatable {
  const ViewModel();
}

abstract class Presenter<U extends UseCase, E extends Entity,
    V extends ViewModel> extends ConsumerStatefulWidget {
  final UseCaseProvider _provider;
  final PresenterBuilder<V> builder;

  const Presenter(
      {super.key, required UseCaseProvider provider, required this.builder})
      : _provider = provider;

  @override
  // ignore: library_private_types_in_public_api
  _PresenterState<U, E, V> createState() => _PresenterState<U, E, V>();

  @protected
  V createViewModel(U useCase, E entity);

  /// Called when this presenter is inserted into the tree.
  @protected
  void onLayoutReady(BuildContext context, U useCase) {}

  /// Called whenever the [output] updates.
  @protected
  void onUpdate(BuildContext context, E entity) {}

  /// Called whenever the presenter configuration changes.
  @protected
  void didUpdatePresenter(
    BuildContext context,
    covariant Presenter<U, E, V> old,
    U useCase,
  ) {}

  /// Called when this presenter is removed from the tree.
  @protected
  void onDestroy(U useCase) {}

  E subscribe(WidgetRef ref) => _provider.subscribe(ref) as E;
}

// ignore: library_private_types_in_public_api
class _PresenterState<U extends UseCase, E extends Entity, V extends ViewModel>
    extends ConsumerState<Presenter<U, E, V>> {
  U? _useCase;

  @override
  WidgetRef get ref => context as WidgetRef;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onLayoutReady(context, _useCase!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useCase ??= widget._provider.getUseCase(ref) as U;
  }

  @override
  void didUpdateWidget(covariant Presenter<U, E, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdatePresenter(context, oldWidget, _useCase!);
  }

  @override
  Widget build(BuildContext context) {
    widget._provider.listen(ref, _onChange);
    final output = widget.subscribe(ref);
    return widget.builder(widget.createViewModel(_useCase!, output));
  }

  void _onChange(previous, next) {
    if (previous != next) widget.onUpdate(context, next);
  }

  @override
  void dispose() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onDestroy(_useCase!);
    });
    super.dispose();
  }
}

typedef PresenterBuilder<V extends ViewModel> = Widget Function(V viewModel);

abstract class UI<V extends ViewModel> extends StatefulWidget {
  late final PresenterCreator<V>? _create;
  UI({
    Key? key,
    PresenterCreator<V>? create,
  }) : super(key: key) {
    _create = create ?? this.create;
  }

  Widget build(BuildContext context, V viewModel);

  Presenter create(PresenterBuilder<V> builder);

  @override
  // ignore: library_private_types_in_public_api
  _UIState createState() => _UIState<V>();
}

class _UIState<V extends ViewModel> extends State<UI<V>> {
  @override
  Widget build(BuildContext context) {
    return widget._create!
        .call((viewModel) => widget.build(context, viewModel));
  }
}

typedef PresenterCreator<V extends ViewModel> = Presenter Function(
    PresenterBuilder<V> builder);
