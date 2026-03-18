import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../widgets/legal/legal_header_card.dart';
import '../widgets/legal/legal_section_card.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _TopBar(title: 'سياسة الخصوصية'),
            const SizedBox(height: 14),
            const LegalHeaderCard(
              title: 'سياسة الخصوصية',
              subtitle: 'توضح هذه الصفحة كيفية جمع بيانات المعلم والطلاب المرتبطة باستخدام التطبيق وحمايتها ومعالجتها داخل البيئة المدرسية.',
              icon: Icons.privacy_tip_outlined,
            ),
            const SizedBox(height: 14),
            const LegalSectionCard(
              title: 'البيانات التي يتم جمعها',
              points: [
                'بيانات حساب المعلم الأساسية مثل الاسم والرقم الوظيفي وبيانات التواصل المرتبطة بالحساب.',
                'بيانات تشغيلية مثل الجدول الدراسي، الحضور، الواجبات، الرسائل، وسجل الاستخدام داخل التطبيق.',
                'بيانات فنية محدودة مثل نوع الجهاز، وقت آخر مزامنة، وأخطاء الاستخدام الضرورية لتحسين الاستقرار.',
              ],
            ),
            const LegalSectionCard(
              title: 'أغراض استخدام البيانات',
              points: [
                'تمكين المعلم من إدارة الحصص والحضور والواجبات والتواصل مع الأطراف ذات العلاقة داخل المدرسة.',
                'تحسين تجربة الاستخدام والأداء واستمرارية مزامنة البيانات بشكل آمن وموثوق.',
                'دعم عمليات المتابعة الأكاديمية والإدارية وفق صلاحيات المستخدم داخل النظام المدرسي.',
              ],
            ),
            const LegalSectionCard(
              title: 'حماية البيانات',
              points: [
                'يتم التعامل مع البيانات داخل التطبيق وفق ضوابط وصول وصلاحيات مرتبطة بدور المستخدم.',
                'تُستخدم إعدادات الأمان مثل كلمات المرور والتحقق الإضافي لحماية الوصول إلى الحساب.',
                'لا يجوز للمعلم مشاركة بيانات الطلاب أو سجلاتهم خارج الغرض المدرسي المصرح به.',
              ],
            ),
            const LegalSectionCard(
              title: 'مشاركة البيانات',
              points: [
                'لا تتم مشاركة البيانات إلا ضمن السياق التشغيلي المصرح به بين المدرسة والمستخدمين المخولين داخل النظام.',
                'قد يتم إظهار بيانات لازمة للإدارة أو المشرفين أو أولياء الأمور بحسب الدور والصلاحيات المعتمدة.',
                'لا يتم استخدام بيانات الطلاب والمعلمين في أغراض دعائية أو تجارية خارج نطاق الخدمة التعليمية.',
              ],
            ),
            const LegalSectionCard(
              title: 'حقوق المستخدم',
              points: [
                'يمكن للمستخدم مراجعة بيانات حسابه الأساسية من خلال الصفحات المخصصة داخل التطبيق.',
                'يمكن طلب تحديث بعض البيانات الإدارية أو الوظيفية من خلال الجهة المشرفة في المدرسة.',
                'يمكن للمستخدم مراجعة إعدادات الخصوصية والأمان والتحكم في بعض التفضيلات الفنية داخل التطبيق.',
              ],
            ),
            const LegalSectionCard(
              title: 'الاحتفاظ بالبيانات',
              points: [
                'يتم الاحتفاظ بالبيانات التشغيلية للفترة اللازمة لتحقيق المتطلبات التعليمية والتنظيمية للمدرسة.',
                'قد تخضع بعض السجلات لفترات احتفاظ أطول إذا كانت مطلوبة للتوثيق أو المتابعة الأكاديمية والإدارية.',
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
