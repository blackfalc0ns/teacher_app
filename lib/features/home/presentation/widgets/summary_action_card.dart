import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../data/models/home_data_model.dart';

class SummaryActionCard extends StatelessWidget {
  final ActionSummaryModel summary;
  final Color? iconColor;

  const SummaryActionCard({super.key, required this.summary, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 55) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              summary.tag != null ? _buildTag(summary.tag!) : _buildBadge(),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            summary.title,
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            summary.subTitle,
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.6),
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 15),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (iconColor ?? AppColors.secondary).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        summary.title.contains('تقارير')
            ? Icons.bar_chart_rounded
            : Icons.assignment_rounded,
        color: iconColor ?? AppColors.secondary,
        size: 24,
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: getBoldStyle(
          color: AppColors.primary,
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'الأداء',
        style: getBoldStyle(
          color: AppColors.secondary,
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: summary.progress,
            backgroundColor: AppColors.lightGrey.withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              iconColor ?? AppColors.secondary,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
