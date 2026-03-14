import '../../../../core/di/injection_container.dart';
import '../repo/schedule_repo.dart';
import '../../presentation/cubits/schedule_cubit.dart';

void initScheduleDI() {
  // Repo
  sl.registerLazySingleton<ScheduleRepo>(() => ScheduleRepoImpl(sl()));

  // Cubit
  sl.registerFactory(() => ScheduleCubit(sl()));
}
