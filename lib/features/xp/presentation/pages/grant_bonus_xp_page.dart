// import 'package:flutter/material.dart';
// import 'package:teacher_app/core/utils/constant/font_manger.dart';
// import 'package:teacher_app/core/utils/constant/styles_manger.dart';
// import 'package:teacher_app/core/utils/theme/app_colors.dart';
// import 'package:teacher_app/features/xp/data/models/xp_center_model.dart';

// class GrantBonusXpPage extends StatefulWidget {
//   final GrantBonusXpArgs args;

//   const GrantBonusXpPage({
//     super.key,
//     required this.args,
//   });

//   @override
//   State<GrantBonusXpPage> createState() => _GrantBonusXpPageState();
// }

// class _GrantBonusXpPageState extends State<GrantBonusXpPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _pointsController = TextEditingController(text: '10');
//   final _noteController = TextEditingController();

//   static const String _all = 'الكل';
//   late String _selectedCycle;
//   XpStudentProgressModel? _selectedStudent;
//   late String _selectedReason;

//   @override
//   void initState() {
//     super.initState();
//     _selectedCycle = widget.args.initialStudent?.cycleName ?? _all;
//     _selectedStudent = widget.args.initialStudent;
//     _selectedReason = widget.args.dashboard.bonusPolicy.allowedReasons.first;
//   }

//   @override
//   void dispose() {
//     _pointsController.dispose();
//     _noteController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cycleOptions = <String>[
//       _all,
//       ...widget.args.dashboard.assignedClasses.map((item) => item.cycleName).toSet(),
//     ];
//     final students = widget.args.dashboard.students.where((student) {
//       return _selectedCycle == _all || student.cycleName == _selectedCycle;
//     }).toList()
//       ..sort((a, b) => b.seasonXp.compareTo(a.seasonXp));

//     if (_selectedStudent != null &&
//         !students.any((student) => student.id == _selectedStudent!.id)) {
//       _selectedStudent = null;
//     }

//     final selectedPoints = int.tryParse(_pointsController.text) ?? 0;
//     final remainingBudget =
//         widget.args.dashboard.bonusPolicy.teacherAvailableBudget - selectedPoints;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F9FC),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           'منح Bonus XP',
//           style: getBoldStyle(
//             color: AppColors.primaryDark,
//             fontSize: FontSize.size18,
//             fontFamily: FontConstant.cairo,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildTopHint(),
//               const SizedBox(height: 14),
//               _buildCard(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _SectionTitle(title: 'نطاق المنح'),
//                     const SizedBox(height: 12),
//                     DropdownButtonFormField<String>(
//                       initialValue: _selectedCycle,
//                       decoration: _inputDecoration('المرحلة'),
//                       items: cycleOptions.map((cycle) {
//                         return DropdownMenuItem(
//                           value: cycle,
//                           child: Text(cycle),
//                         );
//                       }).toList(growable: false),
//                       onChanged: (value) {
//                         if (value == null) return;
//                         setState(() {
//                           _selectedCycle = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                     DropdownButtonFormField<String>(
//                       initialValue: _selectedStudent?.id,
//                       decoration: _inputDecoration('الطالب'),
//                       validator: (value) =>
//                           value == null ? 'اختر الطالب أولًا' : null,
//                       items: students.map((student) {
//                         return DropdownMenuItem(
//                           value: student.id,
//                           child: Text(
//                             '${student.studentName} • ${student.classLabel}',
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         );
//                       }).toList(growable: false),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedStudent = students.firstWhere(
//                             (student) => student.id == value,
//                           );
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 14),
//               _buildCard(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _SectionTitle(title: 'تفاصيل Bonus XP'),
//                     const SizedBox(height: 12),
//                     DropdownButtonFormField<String>(
//                       initialValue: _selectedReason,
//                       decoration: _inputDecoration('سبب المنح'),
//                       items: widget.args.dashboard.bonusPolicy.allowedReasons
//                           .map((reason) => DropdownMenuItem(
//                                 value: reason,
//                                 child: Text(reason),
//                               ))
//                           .toList(growable: false),
//                       onChanged: (value) {
//                         if (value == null) return;
//                         setState(() {
//                           _selectedReason = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _pointsController,
//                       keyboardType: TextInputType.number,
//                       decoration: _inputDecoration('عدد النقاط'),
//                       validator: (value) {
//                         final points = int.tryParse(value ?? '');
//                         if (points == null || points <= 0) {
//                           return 'أدخل قيمة صحيحة';
//                         }
//                         if (points >
//                             widget.args.dashboard.bonusPolicy.weeklyLimitPerStudent) {
//                           return 'تجاوز الحد الأسبوعي للطالب';
//                         }
//                         if (points >
//                             widget.args.dashboard.bonusPolicy.teacherAvailableBudget) {
//                           return 'تجاوز الرصيد المتاح للمعلم';
//                         }
//                         return null;
//                       },
//                       onChanged: (_) => setState(() {}),
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _noteController,
//                       maxLines: 3,
//                       decoration: _inputDecoration('ملاحظة مختصرة للمنح'),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 14),
//               _buildCard(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _SectionTitle(title: 'أثر المنح المتوقع'),
//                     const SizedBox(height: 12),
//                     _ImpactRow(
//                       label: 'الرصيد المتاح بعد العملية',
//                       value: '$remainingBudget XP',
//                     ),
//                     const SizedBox(height: 8),
//                     _ImpactRow(
//                       label: 'الحد الأعلى للطالب أسبوعيًا',
//                       value:
//                           '${widget.args.dashboard.bonusPolicy.weeklyLimitPerStudent} XP',
//                     ),
//                     const SizedBox(height: 8),
//                     _ImpactRow(
//                       label: 'تسجل العملية في سجل Bonus XP',
//                       value: 'نعم',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//           child: FilledButton(
//             onPressed: () {
//               if (!_formKey.currentState!.validate()) return;
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     'تم تجهيز منحة Bonus XP للطالب ${_selectedStudent?.studentName ?? ''}',
//                     style: getMediumStyle(
//                       color: AppColors.white,
//                       fontSize: FontSize.size12,
//                       fontFamily: FontConstant.cairo,
//                     ),
//                   ),
//                 ),
//               );
//             },
//             style: FilledButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(18),
//               ),
//             ),
//             child: Text(
//               'تأكيد منح Bonus XP',
//               style: getBoldStyle(
//                 color: AppColors.white,
//                 fontSize: FontSize.size14,
//                 fontFamily: FontConstant.cairo,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopHint() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.third.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.third.withValues(alpha: 0.18)),
//       ),
//       child: Text(
//         'Bonus XP مخصص للتحفيز المحدود فقط، ولا يغيّر منطق XP الأساسي القادم من الدروس والواجبات والاختبارات.',
//         style: getMediumStyle(
//           color: AppColors.primaryDark,
//           fontSize: FontSize.size12,
//           fontFamily: FontConstant.cairo,
//         ),
//       ),
//     );
//   }

//   Widget _buildCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(color: AppColors.lightGrey),
//       ),
//       child: child,
//     );
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       filled: true,
//       fillColor: AppColors.lightGrey.withValues(alpha: 0.22),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;

//   const _SectionTitle({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: getBoldStyle(
//         color: AppColors.primaryDark,
//         fontSize: FontSize.size15,
//         fontFamily: FontConstant.cairo,
//       ),
//     );
//   }
// }

// class _ImpactRow extends StatelessWidget {
//   final String label;
//   final String value;

//   const _ImpactRow({
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             label,
//             style: getRegularStyle(
//               color: AppColors.grey.withValues(alpha: 0.74),
//               fontSize: FontSize.size11,
//               fontFamily: FontConstant.cairo,
//             ),
//           ),
//         ),
//         Text(
//           value,
//           style: getBoldStyle(
//             color: AppColors.primaryDark,
//             fontSize: FontSize.size12,
//             fontFamily: FontConstant.cairo,
//           ),
//         ),
//       ],
//     );
//   }
// }
