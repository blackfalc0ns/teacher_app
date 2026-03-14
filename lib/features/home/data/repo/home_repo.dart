import 'package:teacher_app/core/network/api_helper.dart';
import 'package:teacher_app/core/network/api_service.dart';
import '../models/home_data_model.dart';

abstract class HomeRepo {
  Future<ApiResult<HomeDataModel>> getHomeData();
}

class HomeRepoImpl implements HomeRepo {
  final ApiService _apiService;

  HomeRepoImpl(this._apiService);

  @override
  Future<ApiResult<HomeDataModel>> getHomeData() async {
    return ApiHelper.safeApiCall<HomeDataModel>(() async {
      // MIGRATION_TODO: Replace with actual API call when backend is ready
      // final response = await _apiService.get(ApiEndpoints.home);
      // return HomeDataModel.fromJson(response.data);
      
      // Mock data for initial implementation
      await Future.delayed(const Duration(seconds: 1));
      return HomeDataModel(
        userInfo: UserInfoModel(
          name: 'أ/ محمد',
          date: 'الأحد، 15 فبراير 2026',
          points: 1240,
          avatarUrl: '',
        ),
        stats: [
          HomeStatModel(
            title: 'الحصة الحالية',
            value: 'العلوم',
            subValue: 'سادس / 1',
            type: HomeStatType.currentClass,
          ),
          HomeStatModel(
            title: 'الحصص المتبقية',
            value: '6 حصص',
            type: HomeStatType.remainingClasses,
          ),
          HomeStatModel(
            title: 'النقاط الممنوحة',
            value: '550 XP',
            type: HomeStatType.points,
          ),
        ],
        weeklySchedule: [
          ScheduleDayModel(
            dayName: 'الأحد',
            items: [
              ScheduleItemModel(subject: 'الرياضيات', className: '1/4', time: '8:45-8', periodIndex: 1),
              ScheduleItemModel(subject: 'العلوم', className: '1/6', time: '11-11:45', periodIndex: 4, isCurrent: true),
            ],
          ),
          ScheduleDayModel(
            dayName: 'الاثنين',
            items: [
              ScheduleItemModel(subject: 'الرياضيات', className: '2/5', time: '8:45-8', periodIndex: 1),
              ScheduleItemModel(subject: 'الرياضيات', className: '2/5', time: '9:45-9', periodIndex: 2),
              ScheduleItemModel(subject: 'تاريخ', className: '2/5', time: '11-11:45', periodIndex: 4),
            ],
          ),
        ],
        actionSummaries: [
          ActionSummaryModel(
            title: 'تقارير الطلاب',
            subTitle: 'الأسبوع الحالي',
            count: 0,
            progress: 0.4,
          ),
          ActionSummaryModel(
            title: 'الواجبات',
            subTitle: 'تحتاج مراجعة',
            count: 12,
            tag: '12 جديد',
            progress: 0.7,
          ),
        ],
      );
    });
  }
}
