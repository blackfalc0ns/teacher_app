import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/schedule_repo.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepo _scheduleRepo;

  ScheduleCubit(this._scheduleRepo) : super(ScheduleInitial());

  Future<void> fetchSchedule(DateTime date) async {
    emit(ScheduleLoading());
    final result = await _scheduleRepo.getScheduleByDate(date);
    result.when(
      success: (data) => emit(ScheduleSuccess(data, date)),
      failure: (error) => emit(ScheduleError(error)),
    );
  }
}
