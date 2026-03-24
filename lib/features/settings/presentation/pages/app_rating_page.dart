import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/support/support_info_card.dart';
import '../widgets/support/support_top_bar.dart';

class AppRatingPage extends StatefulWidget {
  const AppRatingPage({super.key});

  @override
  State<AppRatingPage> createState() => _AppRatingPageState();
}

class _AppRatingPageState extends State<AppRatingPage> {
  int _rating = 4;
  int _selectedTopic = 0;

  final List<String> _topics = const [
    'سهولة الاستخدام',
    'الجدول والفصول',
    'الواجبات والتصحيح',
    'الأداء العام',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const SupportTopBar(
              title: 'تقييم التطبيق',
              subtitle: 'شاركنا رأيك لتطوير تجربة المعلم في معزز.',
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.lightGrey.withValues(alpha: 0.45),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/chat_3.png',
                    width: 68,
                    height: 68,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'كيف تقيّم تجربتك مع معزز؟',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size15,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'اختر تقييمًا عامًا ثم حدّد الجانب الأهم بالنسبة لك.',
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        onPressed: () => setState(() => _rating = index + 1),
                        icon: Icon(
                          index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: index < _rating ? const Color(0xFFFFB547) : AppColors.grey,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const SettingsSectionTitle(
              title: 'ما الجانب الذي تريد تحسينه؟',
              subtitle: 'اختر أكثر جزء تود أن نطوره في النسخ القادمة.',
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                _topics.length,
                (index) => ChoiceChip(
                  label: Text(_topics[index]),
                  selected: _selectedTopic == index,
                  onSelected: (_) => setState(() => _selectedTopic = index),
                  selectedColor: AppColors.primary.withValues(alpha: 0.14),
                  backgroundColor: AppColors.white,
                  labelStyle: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: _selectedTopic == index ? AppColors.primaryDark : AppColors.grey,
                  ),
                  side: BorderSide(
                    color: _selectedTopic == index
                        ? AppColors.primary.withValues(alpha: 0.25)
                        : AppColors.lightGrey.withValues(alpha: 0.55),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const SupportInfoCard(
              title: 'ملاحظاتك مهمة',
              subtitle: 'سيتم لاحقًا ربط هذه الصفحة بإرسال الملاحظات والتقييمات مباشرة للفريق.',
              icon: Icons.rate_review_outlined,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submitRating,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                'إرسال التقييم',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        content: Text('شكرًا لك، تم حفظ تقييمك بشكل محلي في النسخة الحالية.'),
      ),
    );
  }
}
