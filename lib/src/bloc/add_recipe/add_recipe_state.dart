part of 'add_recipe_bloc.dart';

sealed class AddRecipeState extends Equatable {
  const AddRecipeState();
  
  @override
  List<Object> get props => [];
}

final class AddRecipeInitial extends AddRecipeState {}
