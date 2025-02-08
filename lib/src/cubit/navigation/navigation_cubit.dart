import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_state.dart';

class NavigationBarCubit extends Cubit<NavigationBarState> {
  NavigationBarCubit() : super(const NavigationBarState(tab: 0));

  setTab(int index) => emit(NavigationBarState(tab: index));
}
