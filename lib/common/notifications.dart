import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/notifications_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controllers/base_view_controller.dart';
import '../utils/assets_path.dart';
import '../widgets/custom_text.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Notifications",
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            GetBuilder<BaseViewController>(
              builder: (controller) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:  controller.notifications.value?.data?.length??0,
                  itemBuilder: (context, index){
                    String getDateOnly(String? dateTime) {
                      if (dateTime == null || dateTime.isEmpty) return "";
                      return dateTime.split('T').first;
                    }
                  return
                  //   Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10.r),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: AppColors.blackColor.withValues(alpha: 0.15),
                  //         blurRadius: 25.r,
                  //         offset: const Offset(0, 5),
                  //         spreadRadius: 0,
                  //       ),
                  //     ],
                  //     color: AppColors.whiteColor,
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //           children: [
                  //             Padding(
                  //               padding: EdgeInsets.symmetric(horizontal: 10.w),
                  //               child: CircleAvatar(
                  //                 radius: 28.r,
                  //                 backgroundColor: AppColors.yellow1,
                  //                 child: Image.asset(AssetsPath.frame, width: 25.w),
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: Padding(
                  //                 padding: EdgeInsets.only(right: 10.w),
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     CustomText(
                  //                       text:  "Notification",
                  //                       fontSize: 18.sp,
                  //                       fontFamily: "Raleway",
                  //                       weight: FontWeight.bold,
                  //                       fontColor: AppColors.blackColor,
                  //                     ),
                  //                     Padding(
                  //                       padding: const EdgeInsets.only(top: 8.0),
                  //                       child: CustomText(
                  //                         overflow: TextOverflow.visible,
                  //                         text:  "No messageNo messagNo messagNo messagNo messagNo messagNo messag",
                  //                         fontSize: 16.sp,
                  //                         fontFamily: "Raleway",
                  //                         fontColor: AppColors.blackColor,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // );


                    NotificationsWidget(message:controller.notifications.value?.data?[index].message ,
                    title:controller.notifications.value?.data?[index].type ,
                      time: getDateOnly(controller.notifications.value?.data?[index].createdAt)

                    );
                }




                );
              }
            )],
        ),
      ),
      appBarColor: AppColors.whiteColor,
    );
  }
}
