import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/models/consultation_model.dart';
import 'package:patient_app/utils/app_colors.dart';

class ConsultationCard extends StatelessWidget {
  final ConsultationModel plan;
  final Function onTap;

  const ConsultationCard({
    required this.plan,
    required this.onTap,
  });
Color getStatusColor(){
  if(plan.status=="Active"){
    return AppColors.primaryColor;
  }else if(plan.status=="Expire Soon"||plan.status=="Expired"){
    return AppColors.red;
  }else if(plan.status=="Pending"){
    return AppColors.orange;
  }else if(plan.status=="Completed"){
    return AppColors.green;
  }else{
    return Colors.grey;
  }
}
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        '${plan.expirationDate.day} ${getMonthName(plan.expirationDate.month)} ${plan.expirationDate.year}';

    return Padding(
      padding:  EdgeInsets.only(bottom: 15.sp),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.sp),
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.2))
        ),
        padding: EdgeInsets.symmetric(horizontal:15.sp,vertical: 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  plan.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: getStatusColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    plan.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.call,
              text: plan.consultationType,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.calendar_today,
              text: 'Expires on $formattedDate',
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.monetization_on,
              text: '\$${plan.cost.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 8),
            Text(
              '${plan.creditsUsed} out of ${plan.totalCredits} credits',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const Divider(height: 30, thickness: 1),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onTap();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Renew Plan',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String text}) {
    return Row(
      children: <Widget>[
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}