import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/support/support_info_card.dart';
import '../widgets/support/support_top_bar.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const SupportTopBar(
              title: 'عن التطبيق',
              subtitle: 'معلومات مختصرة عن تطبيق المعلم معزز.',
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Image.asset('assets/images/chat_3.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'معزز',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size18,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تطبيق المعلم',
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size11,
                      color: AppColors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'منصة تساعد المعلم على إدارة يومه الدراسي، متابعة الجدول، الفصول، الحضور، والواجبات بشكل منظم وبسيط.',
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'نبذة سريعة',
              subtitle: 'ما الذي يقدمه التطبيق للمعلم داخل المدرسة.',
            ),
            const SizedBox(height: 10),
            const SupportInfoCard(
              title: 'إدارة الجدول الدراسي',
              subtitle: 'عرض الحصص اليومية والأسبوعية مع الوصول السريع إلى الفصل.',
              icon: Icons.calendar_month_outlined,
            ),
            const SupportInfoCard(
              title: 'متابعة الفصول والطلاب',
              subtitle: 'الوصول إلى الفصول المسندة ومؤشرات المتابعة الأساسية.',
              icon: Icons.class_outlined,
            ),
            const SupportInfoCard(
              title: 'الحضور والواجبات',
              subtitle: 'تنفيذ الحضور وإنشاء الواجبات ومتابعة التسليمات والتصحيح.',
              icon: Icons.assignment_turned_in_outlined,
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'معلومات الإصدار',
              subtitle: 'بيانات النسخة الحالية من التطبيق.',
            ),
            const SizedBox(height: 10),
            const SupportInfoCard(
              title: 'الإصدار الحالي',
              subtitle: 'v 1.0.0',
              icon: Icons.info_outline_rounded,
            ),
            const SupportInfoCard(
              title: 'فريق التطوير',
              subtitle: 'تم التطوير بواسطة فريق معزز.',
              icon: Icons.groups_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
