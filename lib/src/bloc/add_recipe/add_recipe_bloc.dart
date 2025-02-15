import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_recipe_event.dart';
part 'add_recipe_state.dart';

class AddRecipeBloc extends Bloc<AddRecipeEvent, AddRecipeState> {
  AddRecipeBloc() : super(AddRecipeInitial()) {
    on<AddRecipeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
