import 'package:flutter/material.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/support/contact_channel_card.dart';
import '../widgets/support/support_header_card.dart';
import '../widgets/support/support_info_card.dart';
import '../widgets/support/support_top_bar.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const SupportTopBar(
              title: 'تواصل معنا',
              subtitle: 'قنوات التواصل الأساسية مع فريق المنصة.',
            ),
            const SizedBox(height: 14),
            const SupportHeaderCard(
              title: 'قنوات مباشرة',
              subtitle:
                  'اختر القناة المناسبة بحسب طبيعة الطلب، سواء كان استفسارًا عامًا أو متابعة لمشكلة تشغيلية.',
              icon: Icons.contact_support_outlined,
              stats: [
                SupportHeaderStat(
                  label: 'أيام العمل',
                  value: 'الأحد - الخميس',
                  icon: Icons.calendar_today_outlined,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'طرق التواصل',
              subtitle: 'القنوات الأساسية في النسخة الحالية.',
            ),
            const SizedBox(height: 10),
            ContactChannelCard(
              title: 'البريد الإلكتروني',
              subtitle: 'للطلبات التي تحتاج تفاصيل أو مرفقات.',
              value: 'support@moazez.sa',
              icon: Icons.email_outlined,
              onTap: () => _showSnackBar(context, 'يمكن نسخ البريد والتواصل مع فريق الدعم.'),
            ),
            ContactChannelCard(
              title: 'الهاتف',
              subtitle: 'للاستفسارات السريعة خلال وقت الدوام.',
              value: '9200 000 00',
              icon: Icons.phone_in_talk_outlined,
              onTap: () => _showSnackBar(context, 'سيتم ربط الاتصال المباشر في تحديث لاحق.'),
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'ساعات الخدمة',
              subtitle: 'موعد الرد المتوقع من الفريق.',
            ),
            const SizedBox(height: 10),
            const SupportInfoCard(
              title: 'أيام العمل',
              subtitle: 'من الأحد إلى الخميس.',
              icon: Icons.calendar_month_outlined,
            ),
            const SupportInfoCard(
              title: 'ساعات الرد',
              subtitle: 'من 7:00 ص إلى 4:00 م.',
              icon: Icons.schedule_rounded,
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
