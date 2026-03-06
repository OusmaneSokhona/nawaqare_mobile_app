import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/document_view_screen.dart';
import 'package:patient_app/utils/app_colors.dart';

class DocumentItemWidget extends StatelessWidget {
  final String documentName;
  final String documentStatus;
  final bool showDivider;
  const DocumentItemWidget({super.key,required this.documentName, required this.documentStatus,this.showDivider=true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
             SizedBox(
               width: 0.65.sw,
               child: Text(
                documentName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
                           ),
             ),
            Spacer(),
            InkWell(onTap: (){
          Get.to(DocumentViewerScreen(documentUrl: documentStatus, fileName: documentName));
            },child: Icon(Icons.remove_red_eye,size: 20.sp,color: AppColors.lightGrey,)),
           Icon(
              Icons.delete_outline,
              size: 20.sp,
              color: CupertinoColors.systemRed,
           )

          ],
        ),
        5.verticalSpace,
        Row(children: [
          Icon(Icons.check,color: AppColors.green,),
          5.horizontalSpace,
          SizedBox(width: 0.75.sw,child: Text(documentStatus,style: TextStyle(color:AppColors.lightGrey,fontSize: 14.sp),maxLines:1,overflow: TextOverflow.ellipsis,)),
        ],),
        8.verticalSpace,
        showDivider?
        Divider(height: 1, color:AppColors.lightGrey.withOpacity(0.3)):SizedBox(),
      ],
    );
  }
}
