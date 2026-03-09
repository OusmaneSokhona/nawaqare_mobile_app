import 'package:flutter/material.dart';
import 'package:patient_app/models/vaccination_history_model.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/vaccination_card.dart';

class VaccinationHistoryList extends StatelessWidget {
  final List<VaccinationHistoryModel> list;
  const VaccinationHistoryList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return VaccinationCard(
            vaccinationHistoryModel: list[index],
            onTap: () {}
        );
      },
    );
  }
}