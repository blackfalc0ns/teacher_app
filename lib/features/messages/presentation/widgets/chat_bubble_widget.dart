import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../data/models/chat_message_model.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageModel message;
  final String? peerAvatarUrl;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    this.peerAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    // isMe means I am the sender. In Arabic (RTL):
    // - Me -> Bubble on Left (end)
    // - Other -> Bubble on Right (start)
    final bool isMe = message.sender == MessageSender.me;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // If NOT me, show avatar on the right edge
          if (!isMe) ...[
            if (message.isFirstInGroup)
              CircleAvatar(
                radius: 16,
                backgroundImage: peerAvatarUrl != null
                    ? AssetImage(peerAvatarUrl!)
                    : null,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: peerAvatarUrl == null
                    ? const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 18,
                      )
                    : null,
              )
            else
              const SizedBox(width: 32),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Padding(
              // Allow some spacing so bubbles don't stretch fully to the other side
              padding: EdgeInsets.only(
                right: isMe ? 40.0 : 0.0,
                left: isMe ? 0.0 : 40.0,
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Bubble container
                  Container(
                    padding: message.type == MessageType.audio
                        ? const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          )
                        : const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primary : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomRight: isMe
                            ? const Radius.circular(20)
                            : const Radius.circular(4),
                        bottomLeft: isMe
                            ? const Radius.circular(4)
                            : const Radius.circular(20),
                      ),
                    ),
                    child: message.type == MessageType.text
                        ? Text(
                            message.text,
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size14,
                              color: isMe ? Colors.white : AppColors.black,
                            ),
                          )
                        : _buildAudioPlayer(isMe),
                  ),

                  // Footer (Time and Status)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.time,
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size10,
                            color: Colors.grey[400]!,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.isRead ? Icons.done_all : Icons.check,
                            size: 15,
                            color: message.isRead
                                ? AppColors.primary
                                : Colors.grey[400],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(bool isMe) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection:
          TextDirection.ltr, // Keep LTR layout for audio: Play -> Wave -> Time
      children: [
        // Play button
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow_rounded,
            color: isMe ? AppColors.primary : AppColors.black,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        // Waves
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(12, (index) {
              final heights = [
                10.0,
                15.0,
                8.0,
                20.0,
                25.0,
                12.0,
                18.0,
                22.0,
                14.0,
                10.0,
                24.0,
                16.0,
              ];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                width: 3,
                height: heights[index % heights.length],
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.8)
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 12),
        // Duration
        Text(
          message.text,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: isMe ? Colors.white : AppColors.black,
          ),
        ),
      ],
    );
  }
}
