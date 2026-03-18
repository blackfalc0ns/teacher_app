import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../widgets/settings_navigation_card.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_switch_card.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool _twoFactorEnabled = true;
  bool _biometricEnabled = false;
  bool _hideMessagePreview = true;
  bool _shareUsageAnalytics = false;
  bool _allowDownloadOnMobile = true;

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
                        'الخصوصية والأمان',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size17,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'إدارة حماية الحساب، الأجهزة النشطة، وتفضيلات خصوصية البيانات.',
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
                          'حماية حساب المعلم',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size16,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'راجع إعدادات التحقق، الأجهزة المرتبطة، والصلاحيات الحساسة لضمان حماية بياناتك وبيانات الطلاب.',
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
                      Icons.shield_moon_outlined,
                      color: AppColors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'حماية الدخول',
              subtitle: 'خيارات تسجيل الدخول الآمن والتحقق الإضافي.',
            ),
            const SizedBox(height: 10),
            // SettingsSwitchCard(
            //   title: 'التحقق بخطوتين',
            //   subtitle: 'إضافة طبقة حماية إضافية عند تسجيل الدخول.',
            //   icon: Icons.verified_user_outlined,
            //   value: _twoFactorEnabled,
            //   onChanged: (value) => setState(() => _twoFactorEnabled = value),
            // ),
            SettingsSwitchCard(
              title: 'الدخول بالبصمة أو الوجه',
              subtitle: 'فتح التطبيق بسرعة مع الحفاظ على الأمان.',
              icon: Icons.fingerprint_rounded,
              value: _biometricEnabled,
              onChanged: (value) => setState(() => _biometricEnabled = value),
            ),
            SettingsNavigationCard(
              title: 'تغيير كلمة المرور',
              subtitle: 'تحديث كلمة المرور بشكل دوري لحماية الحساب.',
              icon: Icons.password_rounded,
              onTap: _showComingSoon,
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'خصوصية البيانات',
              subtitle: 'التحكم في ما يظهر داخل التطبيق وما يتم مشاركته تقنيًا.',
            ),
            const SizedBox(height: 10),
            SettingsSwitchCard(
              title: 'إخفاء معاينة الرسائل الحساسة',
              subtitle: 'عدم إظهار محتوى الرسالة في التنبيهات.',
              icon: Icons.visibility_off_outlined,
              value: _hideMessagePreview,
              onChanged: (value) => setState(() => _hideMessagePreview = value),
            ),
            // SettingsSwitchCard(
            //   title: 'مشاركة تحليلات الاستخدام',
            //   subtitle: 'مساعدة الفريق على تحسين التطبيق عبر بيانات تقنية مجهولة.',
            //   icon: Icons.analytics_outlined,
            //   value: _shareUsageAnalytics,
            //   onChanged: (value) => setState(() => _shareUsageAnalytics = value),
            // ),
            SettingsSwitchCard(
              title: 'السماح بتنزيل الملفات عبر البيانات',
              subtitle: 'تنزيل مرفقات الطلاب والواجبات عبر شبكة الجوال.',
              icon: Icons.sim_card_download_outlined,
              value: _allowDownloadOnMobile,
              onChanged: (value) => setState(() => _allowDownloadOnMobile = value),
            ),
            const SizedBox(height: 14),
            // const SettingsSectionTitle(
            //   title: 'الأجهزة والجلسات',
            //   subtitle: 'إدارة الأجهزة الحالية والجلسات النشطة للحساب.',
            // ),
            // const SizedBox(height: 10),
            // _SessionCard(
            //   title: 'هذا الجهاز',
            //   subtitle: 'Android • آخر نشاط الآن',
            //   status: 'نشط',
            //   color: AppColors.green,
            // ),
            // const SizedBox(height: 10),
            // _SessionCard(
            //   title: 'متصفح الويب',
            //   subtitle: 'Windows • آخر نشاط أمس 6:40 م',
            //   status: 'معروف',
            //   color: AppColors.primary,
            // ),
            // const SizedBox(height: 10),
            // SettingsNavigationCard(
            //   title: 'تسجيل الخروج من الأجهزة الأخرى',
            //   subtitle: 'إنهاء كل الجلسات المفتوحة ما عدا هذا الجهاز.',
            //   icon: Icons.logout_rounded,
            //   onTap: _showComingSoon,
            //   isDestructive: true,
            // ),
            // const SizedBox(height: 14),
            // const SettingsSectionTitle(
            //   title: 'الصلاحيات والملفات',
            //   subtitle: 'الوصول إلى الكاميرا والملفات والمرفقات والمستندات.',
            // ),
            // const SizedBox(height: 10),
            // SettingsNavigationCard(
            //   title: 'أذونات الجهاز',
            //   subtitle: 'الكاميرا، الإشعارات، التخزين، والوسائط.',
            //   icon: Icons.admin_panel_settings_outlined,
            //   onTap: _showComingSoon,
            // ),
            // SettingsNavigationCard(
            //   title: 'إدارة المستندات المحفوظة',
            //   subtitle: 'مراجعة الملفات المحملة محليًا وبيانات التخزين.',
            //   icon: Icons.folder_copy_outlined,
            //   onTap: _showComingSoon,
            // ),
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

class _SessionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color color;

  const _SessionCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.devices_other_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size9,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size9,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
