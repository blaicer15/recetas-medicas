part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  int get tabSelected => 0;
}

final class HomeTabSelected extends HomeEvent {
  final int tab;

  const HomeTabSelected(this.tab);

  @override
  int get tabSelected => tab;
}
