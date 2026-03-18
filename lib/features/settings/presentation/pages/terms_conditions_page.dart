import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../widgets/legal/legal_header_card.dart';
import '../widgets/legal/legal_section_card.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _TopBar(title: 'الشروط والأحكام'),
            const SizedBox(height: 14),
            const LegalHeaderCard(
              title: 'الشروط والأحكام',
              subtitle: 'تنظم هذه الأحكام استخدام تطبيق المعلم، وصلاحيات الوصول، والالتزامات المرتبطة باستخدام الخدمة داخل المدرسة.',
              icon: Icons.gavel_rounded,
            ),
            const SizedBox(height: 14),
            const LegalSectionCard(
              title: 'نطاق الاستخدام',
              points: [
                'هذا التطبيق مخصص للاستخدام المدرسي المهني من قبل المعلمين والمستخدمين المخولين داخل الجهة التعليمية.',
                'يجب استخدام الحساب لأغراض تعليمية وإدارية مرتبطة بالعمل فقط، وليس لأي استخدام شخصي خارج هذا النطاق.',
                'يعد الدخول إلى النظام واستخدام خصائصه إقرارًا بالالتزام بهذه الشروط.',
              ],
            ),
            const LegalSectionCard(
              title: 'مسؤولية المستخدم',
              points: [
                'يلتزم المعلم بالحفاظ على سرية بيانات الدخول وعدم مشاركتها مع أي طرف غير مصرح له.',
                'يلتزم المستخدم بصحة البيانات المدخلة مثل الحضور والواجبات والملاحظات المرتبطة بالطلاب.',
                'يجب استخدام أدوات الرسائل والتواصل والمرفقات بما يتوافق مع السياسات المدرسية والمعايير المهنية.',
              ],
            ),
            const LegalSectionCard(
              title: 'الصلاحيات والوصول',
              points: [
                'تحدد المدرسة أو الجهة الإدارية الصلاحيات المتاحة لكل مستخدم داخل التطبيق.',
                'قد يتم تقييد بعض الخصائص أو تعديلها بحسب الدور الوظيفي أو المرحلة أو الحاجة التشغيلية.',
                'لا يجوز محاولة الوصول إلى بيانات أو خصائص لا تدخل ضمن الصلاحيات الممنوحة للحساب.',
              ],
            ),
            const LegalSectionCard(
              title: 'المحتوى والبيانات',
              points: [
                'تعد السجلات والبيانات والمرفقات المدخلة داخل النظام جزءًا من السجل التشغيلي المعتمد للمدرسة.',
                'يجب عدم حذف أو تغيير أو مشاركة أي بيانات بما يخالف التعليمات التنظيمية أو يضر بسير العمل.',
                'تحتفظ الجهة المشغلة بحق مراجعة السجلات عند الحاجة لأغراض المتابعة أو الجودة أو الامتثال التنظيمي.',
              ],
            ),
            const LegalSectionCard(
              title: 'التوافر والتحديثات',
              points: [
                'قد يتم تحديث التطبيق أو بعض خصائصه بشكل دوري لتحسين الأداء أو إضافة متطلبات تشغيلية جديدة.',
                'قد تتوقف بعض الخدمات مؤقتًا لأغراض الصيانة أو المزامنة أو تحسين البنية التشغيلية.',
              ],
            ),
            const LegalSectionCard(
              title: 'الإجراءات المخالفة',
              points: [
                'قد يؤدي الاستخدام غير المصرح به أو المخالف إلى تقييد الوصول أو تعليق الحساب وفق سياسات الجهة المشرفة.',
                'تتحمل الجهة المشغلة الحق في اتخاذ الإجراء المناسب عند إساءة الاستخدام أو الإضرار بالبيانات أو بالأطراف ذات العلاقة.',
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'آخر تحديث: مارس 2026',
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size9,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;

  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size17,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }
}
