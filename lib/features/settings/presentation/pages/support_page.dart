import 'package:flutter/material.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/support/support_header_card.dart';
import '../widgets/support/support_info_card.dart';
import '../widgets/support/support_top_bar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const SupportTopBar(
              title: 'الدعم الفني',
              subtitle: 'مساعدة سريعة للمشكلات التشغيلية داخل التطبيق.',
            ),
            const SizedBox(height: 14),
            const SupportHeaderCard(
              title: 'دعم بسيط وواضح',
              subtitle:
                  'إذا واجهتك مشكلة في الدخول أو الحضور أو الواجبات، ابدأ من هنا ثم أرسل وصفًا مختصرًا للحالة.',
              icon: Icons.support_agent_rounded,
              stats: [
                SupportHeaderStat(
                  label: 'الرد',
                  value: 'خلال الدوام',
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'الإجراءات المتاحة',
              subtitle: 'أهم ما يحتاجه المعلم في النسخة الحالية.',
            ),
            const SizedBox(height: 10),
            SupportInfoCard(
              title: 'فتح طلب دعم',
              subtitle: 'للأعطال التقنية أو عدم ظهور البيانات أو تعذر الحفظ.',
              icon: Icons.confirmation_number_outlined,
              highlighted: true,
              onTap: () => _showSnackBar(
                context,
                'سيتم ربط نموذج طلب الدعم في تحديث لاحق.',
              ),
            ),
            SupportInfoCard(
              title: 'إرسال وصف المشكلة',
              subtitle: 'اذكر الصفحة المتأثرة والخطوات التي سبقت ظهور المشكلة.',
              icon: Icons.bug_report_outlined,
              onTap: () => _showSnackBar(
                context,
                'الوصف المختصر وصورة الشاشة يساعدان على تسريع المعالجة.',
              ),
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'قبل التواصل',
              subtitle: 'خطوتان تختصران وقت التشخيص.',
            ),
            const SizedBox(height: 10),
            const SupportInfoCard(
              title: 'تحقق من الاتصال',
              subtitle: 'بعض المشكلات ترتبط بالشبكة أو بتأخر المزامنة.',
              icon: Icons.wifi_tethering_error_rounded,
            ),
            const SupportInfoCard(
              title: 'أرفق صورة إن أمكن',
              subtitle: 'الصورة أو الرسالة الظاهرة تساعد الفريق على فهم الحالة بسرعة.',
              icon: Icons.photo_camera_back_outlined,
            ),
          ],
        ),
      ),
    );
  }

  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        content: Text(message),
      ),
    );
  }
}
