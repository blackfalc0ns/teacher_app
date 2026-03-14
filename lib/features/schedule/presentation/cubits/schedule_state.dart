import '../../data/model/schedule_model.dart';
import '../../../../core/errors/api_exception.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleSuccess extends ScheduleState {
  final List<ScheduleModel> schedule;
  final DateTime selectedDate;

  ScheduleSuccess(this.schedule, this.selectedDate);
}

class ScheduleError extends ScheduleState {
  final ApiException error;

  ScheduleError(this.error);
}
