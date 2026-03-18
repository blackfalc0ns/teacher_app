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
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16,32, 8, 16),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Top Row: Drawer Icon, Profile, User Info, Points, Notification
          Row(
            children: [
              // Drawer Icon
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu_rounded,
                  color: AppColors.white,
                  size: 28,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              
              // Profile Image
              _buildProfileImage(),
              const SizedBox(width: 12),
              
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo.name,
                      style: getBoldStyle(
                        color: AppColors.white,
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userInfo.date,
                      style: getRegularStyle(
                        color: AppColors.white.withValues(alpha: 0.85),
                        fontSize: FontSize.size11,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Points
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, color: AppColors.third, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      userInfo.points.toString(),
                      style: getBoldStyle(
                        color: AppColors.white,
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              // Notification Bell
              _buildNotificationBell(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 2),
          ),
          child: OptimizedCircularImage(imageUrl: userInfo.avatarUrl, size: 48),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 12,
            height: 12,
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
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications_active_rounded,
        color: AppColors.white,
        size: 20,
      ),
    );
  }
}
