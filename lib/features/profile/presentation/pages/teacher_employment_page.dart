import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/teacher_employment_model.dart';
import '../../data/models/teacher_profile_model.dart';
import '../widgets/employment/employment_assignments_card.dart';
import '../widgets/employment/employment_header_card.dart';
import '../widgets/employment/employment_info_grid_card.dart';
import '../widgets/employment/employment_permissions_card.dart';
import '../widgets/profile_section_title.dart';

class TeacherEmploymentPage extends StatelessWidget {
  final TeacherEmploymentModel employment;

  const TeacherEmploymentPage({
    super.key,
    required this.employment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'البيانات الوظيفية',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size17,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'عرض الإسناد الوظيفي والأكاديمي والصلاحيات المرتبطة بحساب المعلم.',
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size10,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            EmploymentHeaderCard(employment: employment),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'البيانات التنظيمية',
              subtitle: 'تفاصيل التعيين والمرجعية الإدارية ونوع الوظيفة.',
            ),
            const SizedBox(height: 10),
            EmploymentInfoGridCard(items: employment.organizationalInfo),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'الإسناد الأكاديمي',
              subtitle: 'المواد والفصول التي تم تكليف المعلم بها خلال العام الدراسي.',
            ),
            const SizedBox(height: 10),
            EmploymentAssignmentsCard(employment: employment),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'الحمل الوظيفي',
              subtitle: 'حجم العمل المرتبط بعدد الطلاب والحصص وساعات العمل.',
            ),
            const SizedBox(height: 10),
            EmploymentInfoGridCard(items: employment.workloadInfo),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'الصلاحيات داخل النظام',
              subtitle: 'أهم ما يستطيع المعلم الوصول إليه أو إدارته داخل التطبيق.',
            ),
            const SizedBox(height: 10),
            EmploymentPermissionsCard(
              title: 'الصلاحيات الممنوحة',
              items: employment.permissions,
              color: AppColors.primary,
            ),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'المسؤوليات الأساسية',
              subtitle: 'المهام التشغيلية التي يفترض تنفيذها ضمن دور المعلم.',
            ),
            const SizedBox(height: 10),
            EmploymentPermissionsCard(
              title: 'المسؤوليات اليومية والأكاديمية',
              items: employment.responsibilities,
              color: AppColors.third,
            ),
          ],
        ),
      ),
    );
  }
}
