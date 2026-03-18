import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../widgets/settings_choice_card.dart';
import '../widgets/settings_navigation_card.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_switch_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _assignmentAlerts = true;
  bool _attendanceAlerts = true;
  bool _messagePreview = false;
  bool _compactCards = true;
  bool _autoSync = true;
  String _language = 'العربية';
  String _calendarView = 'أسبوعي';

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
                        'الإعدادات',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size17,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'التحكم في التنبيهات وتفضيلات العرض والمزامنة وأمان الاستخدام.',
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
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إعدادات حساب المعلم',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size16,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'اضبط الواجهة والتنبيهات بما يلائم يومك الدراسي وسير العمل داخل المدرسة.',
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size10,
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.settings_suggest_rounded,
                      color: AppColors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'التنبيهات',
              subtitle: 'اختيار نوع التنبيهات المهمة خلال اليوم الدراسي.',
            ),
            const SizedBox(height: 10),
            SettingsSwitchCard(
              title: 'التنبيهات العامة',
              subtitle: 'استقبال إشعارات التطبيق الأساسية.',
              icon: Icons.notifications_active_outlined,
              value: _pushNotifications,
              onChanged: (value) => setState(() => _pushNotifications = value),
            ),
            SettingsSwitchCard(
              title: 'تنبيهات الواجبات',
              subtitle: 'تنبيهات التسليم والتصحيح والتأخير.',
              icon: Icons.assignment_late_outlined,
              value: _assignmentAlerts,
              onChanged: (value) => setState(() => _assignmentAlerts = value),
            ),
            SettingsSwitchCard(
              title: 'تنبيهات الحضور',
              subtitle: 'تذكير بإغلاق السجل ومتابعة الغياب.',
              icon: Icons.fact_check_outlined,
              value: _attendanceAlerts,
              onChanged: (value) => setState(() => _attendanceAlerts = value),
            ),
            SettingsSwitchCard(
              title: 'معاينة الرسائل',
              subtitle: 'إظهار جزء من الرسائل في الإشعار.',
              icon: Icons.mark_chat_read_outlined,
              value: _messagePreview,
              onChanged: (value) => setState(() => _messagePreview = value),
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'التجربة والواجهة',
              subtitle: 'تفضيلات مرتبطة باللغة، شكل البطاقات، وعرض الجدول.',
            ),
            const SizedBox(height: 10),
            SettingsChoiceCard(
              title: 'لغة التطبيق',
              subtitle: 'اللغة الأساسية المستخدمة داخل التطبيق.',
              options: const ['العربية', 'English'],
              selected: _language,
              onChanged: (value) => setState(() => _language = value),
            ),
            const SizedBox(height: 10),
            SettingsChoiceCard(
              title: 'نمط عرض الجدول',
              subtitle: 'طريقة العرض المفضلة للجدول الدراسي.',
              options: const ['يومي', 'أسبوعي'],
              selected: _calendarView,
              onChanged: (value) => setState(() => _calendarView = value),
            ),
            const SizedBox(height: 10),
            SettingsSwitchCard(
              title: 'عرض البطاقات المضغوط',
              subtitle: 'تقليل حجم العناصر وإظهار بيانات أكثر في الشاشة.',
              icon: Icons.view_compact_alt_outlined,
              value: _compactCards,
              onChanged: (value) => setState(() => _compactCards = value),
            ),
            SettingsSwitchCard(
              title: 'المزامنة التلقائية',
              subtitle: 'تحديث البيانات عند فتح التطبيق أو العودة إليه.',
              icon: Icons.sync_rounded,
              value: _autoSync,
              onChanged: (value) => setState(() => _autoSync = value),
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'الحساب والخصوصية',
              subtitle: 'إدارة الخصوصية والصلاحيات والجلسات النشطة.',
            ),
            const SizedBox(height: 10),
            SettingsNavigationCard(
              title: 'إدارة الجلسات',
              subtitle: 'مراجعة الأجهزة التي تم تسجيل الدخول منها.',
              icon: Icons.devices_outlined,
              onTap: _showComingSoon,
            ),
            SettingsNavigationCard(
              title: 'أذونات التطبيق',
              subtitle: 'الوصول إلى الكاميرا والملفات والإشعارات.',
              icon: Icons.admin_panel_settings_outlined,
              onTap: _showComingSoon,
            ),
            SettingsNavigationCard(
              title: 'النسخ الاحتياطي والمزامنة',
              subtitle: 'تفضيلات حفظ البيانات واسترجاعها.',
              icon: Icons.backup_outlined,
              onTap: _showComingSoon,
            ),
            SettingsNavigationCard(
              title: 'إعادة تعيين التفضيلات',
              subtitle: 'إرجاع كل الإعدادات إلى الوضع الافتراضي.',
              icon: Icons.restart_alt_rounded,
              onTap: _showComingSoon,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة هذه الوظيفة قريبًا.')),
    );
  }
}
