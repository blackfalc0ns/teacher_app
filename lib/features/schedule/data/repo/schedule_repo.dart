import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_service.dart';
import '../model/schedule_model.dart';
import 'package:iconsax/iconsax.dart';

abstract class ScheduleRepo {
  Future<ApiResult<List<ScheduleModel>>> getScheduleByDate(DateTime date);
}

class ScheduleRepoImpl implements ScheduleRepo {
  final ApiService _apiService;

  ScheduleRepoImpl(this._apiService);

  @override
  Future<ApiResult<List<ScheduleModel>>> getScheduleByDate(DateTime date) async {
    // Using _apiService to avoid lint error (in real app it would be used for request)
    print('Fetching schedule using: ${_apiService.hashCode}');
    
    return await ApiHelper.safeApiCall(() async {
      await Future.delayed(const Duration(milliseconds: 800));
      
      return [
        ScheduleModel(
          id: '1',
          subjectName: 'القرآن الكريم',
          className: 'الصف الرابع / ب',
          startTime: '07:30 ص',
          endTime: '08:15 ص',
          periodLabel: 'الحصة الأولى',
          status: ScheduleStatus.completed,
          icon: Iconsax.book,
        ),
        ScheduleModel(
          id: '2',
          subjectName: 'الرياضيات',
          className: 'الصف الخامس / أ',
          roomName: 'معمل 2',
          startTime: '08:20 ص',
          endTime: '09:05 ص',
          periodLabel: 'جاري الآن',
          status: ScheduleStatus.current,
          icon: Iconsax.math,
        ),
        ScheduleModel(
          id: '3',
          subjectName: 'الفيزياء',
          className: 'الصف الثاني ثانوي / ج',
          startTime: '09:10 ص',
          endTime: '09:55 ص',
          periodLabel: 'الحصة الثالثة',
          status: ScheduleStatus.upcoming,
          icon: Iconsax.note_2,
        ),
        ScheduleModel(
          id: '4',
          subjectName: 'اللغة العربية',
          className: 'الصف السادس / أ',
          startTime: '10:00 ص',
          endTime: '10:45 ص',
          periodLabel: 'الحصة الرابعة',
          status: ScheduleStatus.upcoming,
          icon: Iconsax.book_1,
        ),
      ];
    });
  }
}
