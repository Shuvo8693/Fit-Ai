import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pler_to_pler_app/core/utils/constants/app_colors.dart';
import 'package:pler_to_pler_app/custom_assets/assets.gen.dart';
import 'package:pler_to_pler_app/features/home/home_screen.dart';
import 'package:pler_to_pler_app/features/nav_bar/controllers/nav_bar_controller.dart';
import 'package:pler_to_pler_app/features/nav_bar/presentation/screens/widgets/nav_fab_widget.dart';
import 'package:pler_to_pler_app/widgets/widgets.dart';

import '../../../clients/presentation/screens/clients_screen.dart';
import '../../../contentPost/presentation/screens/content_post_screen.dart';
import '../../../contents/presentation/screens/contents_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final NavBarController _navBarController = Get.find<NavBarController>();

  final List<Widget> _screens = [
    HomeScreen(),
    ClientsScreen(),
    ContentsScreen(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.backgroundLight,
        //extendBody: true,
        body: Stack(
          children: [
            // Main screen content
            _screens[_navBarController.selectedIndex.value],

            Positioned(
              bottom: 24.h,
              left: 16.w,
              right: 16.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 320, sigmaY: 320),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF000000).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withOpacity(0.10),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(
                      top: 16.h,
                      right: 12.w,
                      bottom: 16.h,
                      left: 12.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(0),
                        _buildNavItem(1),
                        GestureDetector(
                          onTap: () {
                            NavFabWidget.instance.show(
                              context,
                              onPostContent: () {
                                // Navigates to the screen designed from image_b98f83.png
                                Get.to(() => const ContentPostScreen());
                              },
                              onAddSchedule: () {
                                // Logic for adding schedules can go here
                                debugPrint("Add Schedule clicked");
                              },
                              onAddExercise: () {
                                // Logic for adding exercise plans can go here
                                debugPrint("Add Exercise clicked");
                              },
                            );
                          },
                          child: Assets.icons.addButton.svg(
                            height: 48.h, // Adjusted slightly for better touch target
                            width: 48.w,
                          ),
                        ),
                        _buildNavItem(2),
                        _buildNavItem(3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    bool isSelected = _navBarController.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => _navBarController.onChange(index),
      child: SizedBox(
        //height: 40.h,
        width: 60.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              _navItems[index]["icon"],
              width: 24.w,
              height: 24.h,
            ),
            CustomText(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              text: _navItems[index]["label"],
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _navItems = [
    {"icon": Assets.icons.home.path, "label": "Home"},
    {"icon": Assets.icons.clients.path, "label": "Clients"},
    {"icon": Assets.icons.contents.path, "label": "Contents"},
    {"icon": Assets.icons.schedules.path, "label": "schedules"},
  ];
}
