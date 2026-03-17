import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../data/models/chat_contact_model.dart';

class ChatTileWidget extends StatelessWidget {
  final ChatContactModel contact;

  const ChatTileWidget({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = contact.unreadCount > 0;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/chat_details',
          arguments: {'name': contact.name, 'avatarUrl': contact.imagePath},
        );
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: contact.imagePath == null
                  ? AppColors.primary
                  : Colors.grey[200],
              backgroundImage:
                  (contact.imagePath != null &&
                      contact.imagePath != 'assets/images/default_avatar.png')
                  ? AssetImage(contact.imagePath!)
                  : null,
              child: contact.imagePath == null
                  ? const Icon(Icons.school, color: Colors.white, size: 24)
                  : (contact.imagePath == 'assets/images/default_avatar.png'
                        ? const Icon(Icons.person, color: Colors.grey, size: 30)
                        : null),
            ),
            if (contact.isGroup)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.group,
                    size: 10,
                    color: AppColors.grey,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      contact.name,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasUnread) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${contact.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              contact.date,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size12,
                color: Colors.grey[400]!,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              if (contact.status != MessageStatus.none) ...[
                _buildStatusIcon(contact.status),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  contact.message,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: hasUnread ? AppColors.primary : AppColors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.read:
        return const Icon(Icons.done_all, color: AppColors.primary, size: 16);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, color: Colors.grey, size: 16);
      case MessageStatus.sent:
        return const Icon(Icons.check, color: Colors.grey, size: 16);
      case MessageStatus.none:
        return const SizedBox();
    }
  }
}
