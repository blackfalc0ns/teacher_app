import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeInitial());

  Future<void> getHomeData() async {
    emit(HomeLoading());
    final result = await _homeRepo.getHomeData();
    result.when(
      success: (data) => emit(HomeSuccess(data)),
      failure: (error) => emit(HomeError(error)),
    );
  }
}
