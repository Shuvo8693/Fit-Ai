import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_container.dart';
import '../../../../widgets/custom_scaffold.dart';
import '../../../../widgets/custom_text.dart';


class ChatScreen extends StatelessWidget {
  final String clientName;

  const ChatScreen({super.key, required this.clientName});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: clientName,

      ),
      body: Column(
        children: [
          // Chat area
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                Center(
                  child: CustomContainer(
                    paddingHorizontal: 12.w,
                    paddingVertical: 4.h,
                    color: Colors.black.withOpacity(0.05),
                    radiusAll: 20.r,
                    child: CustomText(text: "New message", fontSize: 12.sp, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20.h),

                // Client Message
                _buildChatBubble(
                  message: "Hi Trainer iam having some truble following suggested excerise plan. can you help me out?",
                  time: "10:24 PM",
                  isMe: false,
                ),

                // Trainer (My) Message
                _buildChatBubble(
                  message: "Let me know whats causing problem. I will help you out",
                  time: "10:25 PM",
                  isMe: true,
                ),
              ],
            ),
          ),

          // Input Area
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble({required String message, required String time, required bool isMe}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          CustomContainer(
            paddingAll: 12.r,
            radiusAll: 16.r,
            color: isMe ? Colors.white : Colors.black.withOpacity(0.05),
            bordersColor: isMe ? Colors.black.withOpacity(0.05) : null,
            child: CustomText(
              text: message,
              textAlign: TextAlign.start,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          CustomText(text: time, fontSize: 10.sp, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return CustomContainer(
      paddingAll: 16.r,
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: CustomContainer(
                paddingHorizontal: 12.w,
                radiusAll: 12.r,
                color: Colors.black.withOpacity(0.05),
                child: Row(
                  children: [
                    const Icon(Icons.image_outlined, color: Colors.black),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter your message",
                          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Send Button
            CircleAvatar(
              radius: 24.r,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}