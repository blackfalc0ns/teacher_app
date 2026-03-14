import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../data/models/home_data_model.dart';
import 'package:teacher_app/core/widgets/optimized_image.dart';

class HomeHeader extends StatelessWidget {
  final UserInfoModel userInfo;

  const HomeHeader({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          _buildProfileImage(),
          const SizedBox(width: 15),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userInfo.date,
                  style: getRegularStyle(
                    color: AppColors.grey.withValues(alpha: 0.6),
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userInfo.name,
                  style: getBoldStyle(
                    color: AppColors.primary,
                    fontSize: FontSize.size18,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(Icons.bolt, color: AppColors.primary, size: 18),

                  Text(
                    userInfo.points.toString(),
                    style: getBoldStyle(
                      color: AppColors.primary,
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ],
              ),
              Text(
                'نقاط المدرسة',
                style: getRegularStyle(
                  color: AppColors.grey.withValues(alpha: 0.6),
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          const Divider(color: AppColors.grey),
          const SizedBox(width: 15),
          // Notification Bell
          _buildNotificationBell(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: OptimizedCircularImage(imageUrl: userInfo.avatarUrl, size: 60),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationBell() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications_active_rounded,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }
}
