import 'package:flutter/cupertino.dart';
import 'package:patient_app/models/medical_history_model.dart';
import 'package:patient_app/widgets/profile_widgets/current_medicine_card.dart';

class CurrentMedicineList extends StatelessWidget {
  final List<MedicalHistoryModel> list;
  const CurrentMedicineList({super.key,required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(padding: EdgeInsets.zero,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),itemCount: list.length,itemBuilder: (context,index){
      return CurrentMedicineCard(medicalHistoryModel: list[index], onTap: (){});
    });
  }
}
