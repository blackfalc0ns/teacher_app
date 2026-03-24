import 'package:flutter/material.dart';

import '../widgets/settings_section_title.dart';
import '../widgets/support/faq_category_card.dart';
import '../widgets/support/support_header_card.dart';
import '../widgets/support/support_top_bar.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const SupportTopBar(
              title: 'مركز المساعدة',
              subtitle: 'إجابات سريعة لأكثر الاستخدامات اليومية شيوعًا.',
            ),
            const SizedBox(height: 14),
            const SupportHeaderCard(
              title: 'دليل المعلم المختصر',
              subtitle:
                  'راجع أهم الأسئلة التشغيلية المرتبطة بالجدول والفصول والحضور والواجبات داخل التطبيق.',
              icon: Icons.help_center_outlined,
              stats: [
                SupportHeaderStat(
                  label: 'أكثر موضوع',
                  value: 'الحضور والواجبات',
                  icon: Icons.auto_stories_outlined,
                ),
                SupportHeaderStat(
                  label: 'نوع الإجابات',
                  value: 'سريعة وعملية',
                  icon: Icons.flash_on_rounded,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'الموضوعات الشائعة',
              subtitle: 'المحتوى الأهم الذي يحتاجه المعلم أثناء يومه الدراسي.',
            ),
            const SizedBox(height: 10),
            const FaqCategoryCard(
              title: 'الحساب وتسجيل الدخول',
              subtitle: 'البدء والوصول للحساب بصورة صحيحة.',
              icon: Icons.login_rounded,
              points: [
                'إذا تعذر الدخول، تحقّق أولًا من اسم المستخدم وكلمة المرور وتاريخ الجهاز.',
                'في حال انتهاء الجلسة، أعد تسجيل الدخول ثم راجع إعدادات الأمان والجلسات.',
                'لتغيير بيانات الحساب الأساسية، استخدم الملف الشخصي أو راجع إدارة المدرسة عند الحاجة.',
              ],
            ),
            const FaqCategoryCard(
              title: 'الجدول وفصولي',
              subtitle: 'الوصول السريع إلى الحصص والفصول المسندة.',
              icon: Icons.class_outlined,
              points: [
                'يعرض الجدول الحصص المسندة حسب اليوم أو الأسبوع مع الدخول المباشر إلى الفصل.',
                'تبويب فصولي مخصص لمتابعة الفصول المسندة ومؤشرات الواجبات والتصحيح.',
                'إذا لم يظهر فصل معين، راجع الإسناد الأكاديمي أو تواصل مع الإدارة المدرسية.',
              ],
            ),
            const FaqCategoryCard(
              title: 'الحضور والانضباط',
              subtitle: 'إدارة حضور الطلاب أثناء الحصة.',
              icon: Icons.fact_check_outlined,
              points: [
                'الدخول إلى أخذ الحضور يتم من داخل الفصل أو من الحصة نفسها في الجدول.',
                'يمكن تحديث الحالات قبل الاعتماد النهائي إذا بقي طلاب دون حسم.',
                'في حال عدم حفظ السجل، تأكد من الاتصال ثم أعد المحاولة قبل مغادرة الصفحة.',
              ],
            ),
            const FaqCategoryCard(
              title: 'الواجبات والتصحيح',
              subtitle: 'إنشاء الواجب ومتابعة التسليمات والتقييم.',
              icon: Icons.assignment_outlined,
              points: [
                'يمكن إنشاء واجب جديد من صفحة الواجبات أو من داخل الفصل المرتبط بالحصة.',
                'متابعة الواجب تعرض من سلّم، من تأخر، ومن يحتاج إلى تصحيح يدوي.',
                'الأسئلة المقالية والقصيرة قد تتطلب تدخلاً من المعلم لاعتماد الدرجة النهائية.',
              ],
            ),
            const FaqCategoryCard(
              title: 'الرسائل والإشعارات',
              subtitle: 'الوصول السريع للتنبيهات والتواصل.',
              icon: Icons.notifications_active_outlined,
              points: [
                'تنبيهات التطبيق يمكن تخصيصها من الإعدادات بحسب الحضور والواجبات والرسائل.',
                'إذا لم تصلك إشعارات، راجع أذونات الجهاز وإعدادات التنبيه داخل التطبيق.',
                'الرسائل الحساسة يمكن إخفاء معاينتها من صفحة الخصوصية والأمان.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}
