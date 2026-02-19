import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pler_to_pler_app/core/utils/constants/app_colors.dart';
import 'package:pler_to_pler_app/custom_assets/assets.gen.dart';
import 'package:pler_to_pler_app/features/common/notification/presentation/screen/notification_screen.dart';
import 'package:pler_to_pler_app/features/home/widgets/ai_insight_widget.dart';
import 'package:pler_to_pler_app/features/home/widgets/session_card_widget.dart';
import 'package:pler_to_pler_app/features/profile/profile_screen.dart';
import 'package:pler_to_pler_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleWidget: GestureDetector(
          onTap: () {
            Get.to(() => ProfileScreen());
          },
          child: ListTile(
            leading: CustomImageAvatar(
              image: '',
              radius: 22.r,
              showBorder: true,
            ),
            title: Row(
              children: [
                CustomText(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  textAlign: TextAlign.start,
                  text: 'Hi Maxime!!',
                ),

                SizedBox(width: 6.w),
                CustomContainer(
                  paddingHorizontal: 8.w,
                  radiusAll: 100.r,
                  bordersColor: AppColors.textSecondary,
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 14.r),
                      CustomText(text: 'Online', fontSize: 12.sp, left: 4.w),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: CustomText(
              textAlign: TextAlign.start,
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              text: 'Let’s Manage your  users',
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => NotificationsScreen());
            },
            icon: Assets.icons.notification.svg(height: 48.r, width: 48.r),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            CustomContainer(
              radiusAll: 16.r,
              paddingAll: 16.r,
              width: double.infinity,
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    bottom: 12.h,
                    text: 'Client Overview',
                  ),

                  Wrap(
                    spacing: 16.w,
                    runSpacing: 16.h,
                    children: [
                      _buildClientOverviewCard(
                        icon: Assets.icons.clients.path,
                        label: 'Active Clients',
                        point: '22',
                      ),
                      _buildClientOverviewCard(
                        icon: Assets.icons.star.path,
                        label: 'New this week',
                        point: '3',
                      ),
                      _buildClientOverviewCard(
                        icon: Assets.icons.attention.path,
                        label: 'Need Attention',
                        point: '4',
                      ),
                      _buildClientOverviewCard(
                        icon: Assets.icons.missing.path,
                        label: 'Missed session',
                        point: '4',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),
            CustomContainer(
              radiusAll: 16.r,
              paddingAll: 16.r,
              width: double.infinity,
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        text: 'Today’s Sessions (4)',
                      ),
                      CustomText(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        text: 'View all',
                      ),
                    ],
                  ),

                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return SessionsCardWidget();
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            AiInsightWidget(),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildClientOverviewCard({
    required String icon,
    required String label,
    required String point,
  }) {
    return CustomContainer(
      radiusAll: 12.r,
      paddingAll: 12.r,
      alignment: Alignment.centerLeft,
      color: Colors.black.withOpacity(0.08),
      height: 112.h,
      width: 151.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(icon, height: 24.r, width: 24.r),
          CustomText(
            text: label,
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
          CustomText(
            textAlign: TextAlign.start,
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            text: point,
          ),
        ],
      ),
    );
  }
}
