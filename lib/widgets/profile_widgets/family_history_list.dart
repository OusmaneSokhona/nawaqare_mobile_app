import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../screens/profile_screens/family_history_card.dart';

class FamilyHistoryList extends StatelessWidget {
  const FamilyHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FamilyHistoryCard(),
        5.verticalSpace,
        FamilyHistoryCard(),
      ],
    );
  }
}
