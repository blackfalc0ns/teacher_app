import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/common/custom_app_bar.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../data/models/chat_contact_model.dart';
import '../widgets/messages_search_bar_widget.dart';
import '../widgets/messages_filters_widget.dart';
import '../widgets/chat_tile_widget.dart';

class MessagesScreen extends StatefulWidget {
  final bool showBackButton;
  const MessagesScreen({super.key, this.showBackButton = false});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'الكل',
    'المدرسين',
    'الطلاب',
    'المجموعات',
    'المواد',
  ];

  final List<ChatContactModel> _contacts = [
    ChatContactModel(
      name: 'أ.محمد سالم الدوسري',
      message: 'راجع المرفق بخصوص معادلات الكيمياء',
      date: '8 مارس',
      imagePath: 'assets/images/caht_1.png',
      unreadCount: 2,
    ),
    ChatContactModel(
      name: 'مشروع "نيوم"',
      message: 'أنت : هل انتهيت من البحث عن الطاقة؟',
      date: '7 مارس',
      imagePath: 'assets/images/chat_2.png',
      status: MessageStatus.read,
      isGroup: true,
    ),
    ChatContactModel(
      name: 'دعم "معزز" الأكاديمي',
      message: 'تم تحديث ملخص درس الرياضيات اليوم.',
      date: '5 مارس',
      imagePath: 'assets/images/chat_3.png',
      status: MessageStatus.delivered,
      isGroup: true,
    ),
    ChatContactModel(
      name: 'عبدالله الشهراني',
      message: 'ممكن نراجع مسألة الفيزياء سوا ؟',
      date: '1 مارس',
      imagePath: 'assets/images/chat_4.png',
      status: MessageStatus.sent,
    ),
    ChatContactModel(
      name: 'رياضيات 5',
      message: 'تم تحديث ملخص درس الرياضيات',
      date: '1 مارس',
      imagePath: null, // Custom circle for this
      status: MessageStatus.delivered,
      isGroup: true,
    ),
    ChatContactModel(
      name: 'أ. فهد الكناني',
      message: 'راجع المرفق بخصوص معادلات الكيمياء.',
      date: '28 فبراير',
      imagePath: 'assets/images/default_avatar.png', // Fallback avatar handler
      status: MessageStatus.delivered,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'صندوق الرسائل'),
      body: Column(
        children: [
          const MessagesSearchBarWidget(),
          MessagesFiltersWidget(
            filters: _filters,
            selectedIndex: _selectedFilterIndex,
            onFilterSelected: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _contacts.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 80.0),
                child: Divider(color: Colors.grey[200], height: 1),
              ),
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return ChatTileWidget(contact: contact);
              },
            ),
          ),
        ],
      ),
    );
  }
}
