import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../data/models/chat_message_model.dart';
import '../widgets/chat_background_widget.dart';
import '../widgets/chat_bubble_widget.dart';
import '../widgets/chat_input_bar_widget.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String peerName;
  final String? peerAvatarUrl;

  const ChatDetailsScreen({
    super.key,
    required this.peerName,
    this.peerAvatarUrl,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final List<ChatMessageModel> _dummyMessages = [
    ChatMessageModel(
      id: '1',
      text: 'السلام عليكم، حياك الله يا بطل.',
      type: MessageType.text,
      sender: MessageSender.other,
      date: 'اليوم',
      time: '11:00 م',
      isFirstInGroup: true,
    ),
    ChatMessageModel(
      id: '2',
      text: 'وعليكم السلام أستاذ محمد',
      type: MessageType.text,
      sender: MessageSender.me,
      date: 'اليوم',
      time: '11:04 م',
      isRead: true,
      isFirstInGroup: true,
    ),
    ChatMessageModel(
      id: '3',
      text: 'عرفت حل المعادلة ولا لسه ؟',
      type: MessageType.text,
      sender: MessageSender.other,
      date: 'اليوم',
      time: '11:05 م',
      isFirstInGroup: true,
    ),
    ChatMessageModel(
      id: '4',
      text: 'ارسلك الشرح ؟',
      type: MessageType.text,
      sender: MessageSender.other,
      date: 'اليوم',
      time: '11:05 م',
    ),
    ChatMessageModel(
      id: '5',
      text: '0:15', // Audio duration
      type: MessageType.audio,
      sender: MessageSender.me,
      date: 'اليوم',
      time: '11:08 م',
      isRead: true,
      isFirstInGroup: true,
    ),
    ChatMessageModel(
      id: '6',
      text: 'برسلك مقطع صوتي لشرح المسألة',
      type: MessageType.text,
      sender: MessageSender.other,
      date: 'اليوم',
      time: '11:10 م',
      isFirstInGroup: true,
    ),
    ChatMessageModel(
      id: '7',
      text: '1:20', // Audio duration
      type: MessageType.audio,
      sender: MessageSender.other,
      date: 'اليوم',
      time: '11:15 م',
    ),
    ChatMessageModel(
      id: '8',
      text: 'تمام',
      type: MessageType.text,
      sender: MessageSender.me,
      date: 'اليوم',
      time: '8:23 ص',
      isRead: false,
      isFirstInGroup: true,
    ),
    ChatMessageModel(
      id: '9',
      text: '0:45', // Audio duration
      type: MessageType.audio,
      sender: MessageSender.me,
      date: 'اليوم',
      time: 'الآن',
      isRead: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                widget.peerName,
                textAlign: TextAlign.right,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                  color: AppColors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: widget.peerAvatarUrl != null
                      ? AssetImage(widget.peerAvatarUrl!)
                      : null,
                  child: widget.peerAvatarUrl == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent[400],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const ChatBackgroundWidget(),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  itemCount: _dummyMessages.length,
                  itemBuilder: (context, index) {
                    final message = _dummyMessages[index];

                    // Determine if we show date header
                    bool isFirstInDate = false;
                    if (index == 0) {
                      isFirstInDate = true;
                    } else if (_dummyMessages[index - 1].date != message.date) {
                      isFirstInDate = true;
                    } // We can inject date headers explicitly

                    // Injecting a fixed date header for realism (as in screenshot)
                    if (index == 5 || isFirstInDate) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'الخميس, 1-1-2026',
                              style: getMediumStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size12,
                                color: Colors.grey[400]!,
                              ),
                            ),
                          ),
                          ChatBubbleWidget(
                            message: message,
                            peerAvatarUrl: widget.peerAvatarUrl,
                          ),
                        ],
                      );
                    }

                    return ChatBubbleWidget(
                      message: message,
                      peerAvatarUrl: widget.peerAvatarUrl,
                    );
                  },
                ),
              ],
            ),
          ),
          const ChatInputBarWidget(),
        ],
      ),
    );
  }
}
