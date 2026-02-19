

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/custom_app_bar.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_container.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/custom_text_field.dart';

class ContentPostScreen extends StatefulWidget {
  const ContentPostScreen({super.key});

  @override
  State<ContentPostScreen> createState() => _ContentPostScreenState();
}

class _ContentPostScreenState extends State<ContentPostScreen> {
  // 0: Video, 1: Update
  int selectedTab = 0;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Post a Content',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Toggle (Video, Update)
            CustomContainer(
              radiusAll: 14.r,
              color: Colors.white,
              paddingAll: 4.r,
              child: Row(
                children: [
                  _buildTabItem('Video', 0),
                  _buildTabItem('Update', 1),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Dynamic Content based on selection
            if (selectedTab == 0) _buildVideoLayout() else _buildUpdateLayout(),

            SizedBox(height: 32.h),

            // Post Button - Label changes based on tab
            CustomButton(
              onPressed: () {},
              label: selectedTab == 0 ? 'Post video' : 'Post update',
              backgroundColor: Colors.black12,
              foregroundColor: Colors.grey,
              width: double.infinity,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }


  Widget _buildUpdateLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add Location Row
        Row(
          children: [
            Icon(Icons.location_on, size: 18.sp, color: Colors.black),
            SizedBox(width: 4.w),
            CustomText(
              text: "Add location",
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Large Update Text Area
        CustomTextField(
          controller: updateController,
          hintText: "Update to all your users",
          maxLines: 12,
          minLines: 10,
          borderRadio: 16.r,
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: 180.h), // Align sparkle to top
            child: Icon(Icons.auto_awesome, size: 18.sp, color: Colors.grey),
          ),
        ),
        SizedBox(height: 16.h),

        // AI Generation Button
        CustomButton(
          onPressed: () {},
          label: "Generate update with P2bot",
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          bordersColor: Colors.black12,
          width: double.infinity,
        ),
        SizedBox(height: 24.h),

        // Bottom Media Icons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMediaActionIcon(Icons.image_outlined),
            _buildMediaActionIcon(Icons.videocam_outlined),
            _buildMediaActionIcon(Icons.segment),
            _buildMediaActionIcon(Icons.local_offer_outlined),
          ],
        ),
      ],
    );
  }

  // --- Layout for "Video" Tab ---
  Widget _buildVideoLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUploadPlaceholder(),
        SizedBox(height: 24.h),
        _buildFieldLabel("Title"),
        CustomTextField(
          controller: titleController,
          hintText: 'Title of the video',
          borderRadio: 12.r,
        ),
        SizedBox(height: 16.h),
        _buildFieldLabel("Category"),
        _buildDropdownField("Select a category"),
        SizedBox(height: 16.h),
        _buildFieldLabel("Description"),
        CustomTextField(
          controller: descriptionController,
          hintText: 'Describe about your video',
          maxLines: 5,
          minLines: 4,
          borderRadio: 12.r,
          prefixIcon: Icon(Icons.auto_awesome, size: 18.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMediaActionIcon(IconData icon) {
    return CustomContainer(
      width: 80.w,
      paddingVertical: 12.h,
      radiusAll: 12.r,
      color: Colors.white,
      bordersColor: Colors.black12,
      child: Icon(icon, color: Colors.black, size: 24.sp),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: CustomContainer(
          radiusAll: 12.r,
          paddingVertical: 10.h,
          color: isSelected ? Colors.black : Colors.transparent,
          alignment: Alignment.center,
          child: CustomText(
            text: label,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.black12, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35.r,
            backgroundColor: Colors.black.withOpacity(0.05),
            child: Icon(Icons.videocam_rounded, size: 32.sp, color: Colors.black),
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: "Max 30 minutes or 1 GB",
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: label,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return CustomContainer(
      paddingHorizontal: 16.w,
      paddingVertical: 14.h,
      radiusAll: 12.r,
      color: Colors.white,
      bordersColor: Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: hint, fontSize: 14.sp, color: Colors.black),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }
}