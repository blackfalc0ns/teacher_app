import 'package:teacher_app/core/errors/api_exception.dart';
import '../../data/models/home_data_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final HomeDataModel data;
  HomeSuccess(this.data);
}

class HomeError extends HomeState {
  final ApiException error;
  HomeError(this.error);
}
