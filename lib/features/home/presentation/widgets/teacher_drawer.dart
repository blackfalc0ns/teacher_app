import 'package:flutter/material.dart';
import 'package:teacher_app/core/widgets/optimized_image.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/home_data_model.dart';

class TeacherDrawer extends StatelessWidget {
  final HomeDataModel data;

  const TeacherDrawer({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.70;

    return Drawer(
      width: drawerWidth.clamp(260.0, 312.0),
      backgroundColor: const Color(0xFFF6F9FC),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _DrawerHeader(userInfo: data.userInfo),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                children: [
                  const _SectionTitle(title: 'الحساب'),
                  const SizedBox(height: 8),
                  _DrawerMenuTile(
                    icon: Icons.person_outline_rounded,
                    title: 'الملف الشخصي',
                    subtitle: 'البيانات الشخصية والمهنية',
                    onTap: () => _openRoute(context, Routes.profile),
                  ),
                  _DrawerMenuTile(
                    icon: Icons.badge_outlined,
                    title: 'البيانات الوظيفية',
                    subtitle: 'المرحلة والمواد والفصول المسندة',
                    onTap: () => _openRoute(context, Routes.employment),
                  ),
                  _DrawerMenuTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'الإشعارات',
                    subtitle: 'تنبيهات الحضور والواجبات والرسائل',
                    onTap: () => _showComingSoon(context, 'الإشعارات'),
                  ),
                  const SizedBox(height: 8),
                  const _SectionTitle(title: 'التطبيق'),
                  const SizedBox(height: 8),
                  _DrawerMenuTile(
                    icon: Icons.settings_outlined,
                    title: 'الإعدادات',
                    subtitle: 'اللغة والتنبيهات وتفضيلات العرض',
                    onTap: () => _openRoute(context, Routes.settings),
                  ),
                  _DrawerMenuTile(
                    icon: Icons.security_rounded,
                    title: 'الخصوصية والأمان',
                    subtitle: 'التحكم في الأذونات وحماية الحساب',
                    onTap: () => _openRoute(context, Routes.privacySecurity),
                  ),
                  _DrawerMenuTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'سياسة الخصوصية',
                    subtitle: 'كيفية جمع البيانات واستخدامها',
                    onTap: () => _openRoute(context, Routes.privacyPolicy),
                  ),
                  _DrawerMenuTile(
                    icon: Icons.gavel_rounded,
                    title: 'الشروط والأحكام',
                    subtitle: 'بنود استخدام التطبيق والخدمات',
                    onTap: () => _openRoute(context, Routes.termsConditions),
                  ),
                  const SizedBox(height: 8),
                  const _SectionTitle(title: 'المساعدة'),
                  const SizedBox(height: 8),
                  _DrawerMenuTile(
                    icon: Icons.support_agent_outlined,
                    title: 'الدعم الفني',
                    subtitle: 'الإبلاغ عن مشكلة أو طلب مساعدة',
                    onTap: () => _openRoute(context, Routes.support),
                  ),
                  _DrawerMenuTile(
                    icon: Icons.help_outline_rounded,
                    title: 'مركز المساعدة',
                    subtitle: 'إجابات سريعة للأسئلة الشائعة',
                    onTap: () => _openRoute(context, Routes.helpCenter),
                  ),
                  _DrawerMenuTile(
                    icon: Icons.contact_support_outlined,
                    title: 'تواصل معنا',
                    subtitle: 'قنوات التواصل مع فريق المنصة',
                    onTap: () => _openRoute(context, Routes.contactUs),
                  ),
                  const SizedBox(height: 8),
                  const _SectionTitle(title: 'أخرى'),
                  const SizedBox(height: 8),
                  _DrawerMenuTile(
                    icon: Icons.info_outline_rounded,
                    title: 'عن التطبيق',
                    subtitle: 'نبذة مختصرة عن المنصة والإصدار',
                    onTap: () => _openRoute(context, Routes.aboutApp),
                  ),
                  _DrawerMenuTile(
                    icon: Icons.star_border_rounded,
                    title: 'تقييم التطبيق',
                    subtitle: 'شاركنا رأيك لتطوير التجربة',
                    onTap: () => _openRoute(context, Routes.appRating),
                  ),
                  _DrawerMenuTile(
                    icon: Icons.logout_rounded,
                    title: 'تسجيل الخروج',
                    subtitle: 'الخروج من حساب المعلم الحالي',
                    isDestructive: true,
                    onTap: () => _showComingSoon(context, 'تسجيل الخروج'),
                  ),
                ],
              ),
            ),
            const _DrawerFooter(),
          ],
        ),
      ),
    );
  }

  void _openRoute(BuildContext context, String route) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(route, arguments: data);
  }

  void _showComingSoon(BuildContext context, String title) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('سيتم إضافة $title قريبًا.')),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final UserInfoModel userInfo;

  const _DrawerHeader({required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 32, 14, 12),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: OptimizedCircularImage(
              imageUrl: userInfo.avatarUrl,
              size: 52,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userInfo.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size15,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'حساب المعلم',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: AppColors.white.withValues(alpha: 0.88),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, color: AppColors.third, size: 15),
                const SizedBox(width: 4),
                Text(
                  '${userInfo.points}',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _DrawerMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = isDestructive ? AppColors.error : AppColors.primaryDark;
    final iconBg = isDestructive
        ? AppColors.error.withValues(alpha: 0.08)
        : AppColors.primary.withValues(alpha: 0.08);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGrey.withValues(alpha: 0.45),
        ),
      ),
      child: ListTile(
        dense: true,
        minTileHeight: 60,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: tileColor, size: 19),
        ),
        title: Text(
          title,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size11,
            color: tileColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size9,
            color: AppColors.grey,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: isDestructive ? AppColors.error : AppColors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.lightGrey.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/chat_3.png',
            width: 120,
            height: 40,
          ),
          Text(
            'تم التطوير بواسطة فريق معزز',
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'v 1.0.0',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size9,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size11,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}





