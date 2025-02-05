part of 'home_bloc.dart';

final class HomeState extends Equatable {
  final int tab;

  const HomeState({this.tab = 0});

  @override
  int get tabSelected => tab;

  HomeState copyWith({
    int? tab,
  }) {
    return HomeState(
      tab: tab ?? this.tab,
    );
  }
}
