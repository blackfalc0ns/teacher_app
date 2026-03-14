import 'package:get_it/get_it.dart';
import '../../features/home/data/di/home_di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';
import '../network/app_state_service.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core
  final appStateService = AppStateService(sl());
  await appStateService.init();
  sl.registerLazySingleton(() => appStateService);

  await DioClient.initialize(sl());
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // Features
  initHomeDI();
}
