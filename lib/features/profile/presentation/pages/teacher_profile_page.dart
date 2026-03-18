import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/teacher_profile_model.dart';
import '../widgets/profile_account_info_card.dart';
import '../widgets/profile_actions_card.dart';
import '../widgets/profile_contact_card.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_highlights_card.dart';
import '../widgets/profile_identity_card.dart';
import '../widgets/profile_performance_card.dart';
import '../widgets/profile_section_title.dart';
import '../widgets/profile_workload_card.dart';

class TeacherProfilePage extends StatelessWidget {
  final TeacherProfileModel profile;

  const TeacherProfilePage({
    super.key,
    required this.profile,
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
                        'الملف الشخصي',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size17,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'عرض شامل للهوية المهنية والبيانات الأساسية للمعلم.',
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
            ProfileHeaderCard(profile: profile),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'الهوية المهنية',
              subtitle: 'المسمى، التخصص، المرحلة، والبيانات الوظيفية الأساسية.',
            ),
            const SizedBox(height: 10),
            ProfileIdentityCard(profile: profile),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'بيانات التواصل',
              subtitle: 'قنوات التواصل الأساسية داخل المدرسة والمنصة.',
            ),
            const SizedBox(height: 10),
            ProfileContactCard(profile: profile),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'الحمل التدريسي',
              subtitle: 'نظرة مختصرة على عدد الفصول والطلاب والحصص والمتابعة.',
            ),
            const SizedBox(height: 10),
            ProfileWorkloadCard(profile: profile),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'مؤشرات الأداء',
              subtitle: 'مؤشرات تقريبية على الانضباط والمتابعة وجودة الإغلاق اليومي.',
            ),
            const SizedBox(height: 10),
            ProfilePerformanceCard(profile: profile),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'نقاط القوة الحالية',
              subtitle: 'ملخص سريع لما يميز أداء المعلم في التطبيق والعمليات اليومية.',
            ),
            const SizedBox(height: 10),
            ProfileHighlightsCard(highlights: profile.highlights),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'إجراءات الحساب',
              subtitle: 'وصول سريع لتعديل البيانات والوثائق وإعدادات الأمان.',
            ),
            const SizedBox(height: 10),
            const ProfileActionsCard(),
            const SizedBox(height: 14),
            const ProfileSectionTitle(
              title: 'معلومات الحساب',
              subtitle: 'تفاصيل مرتبطة بالحساب والمزامنة والإصدار التنظيمي.',
            ),
            const SizedBox(height: 10),
            ProfileAccountInfoCard(items: profile.accountItems),
            const SizedBox(height: 20),
            _LogoutButton(onLogout: () => _handleLogout(context)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'تسجيل الخروج',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: AppColors.primaryDark,
          ),
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size13,
            color: AppColors.grey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: AppColors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تسجيل الخروج بنجاح'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'تسجيل الخروج',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const _LogoutButton({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onLogout,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'تسجيل الخروج من الحساب',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
