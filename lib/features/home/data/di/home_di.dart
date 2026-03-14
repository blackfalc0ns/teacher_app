import 'package:teacher_app/core/di/injection_container.dart';
import '../repo/home_repo.dart';
import '../../presentation/cubits/home_cubit.dart';

void initHomeDI() {
  // Repo
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));

  // Cubit
  sl.registerFactory(() => HomeCubit(sl()));
}
