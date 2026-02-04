import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Widget allUserWidget(UserModel user) {
  return Card(
    color: ColorManager.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: ColorManager.fieldBackground, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile image circle (if needed)
          CircleAvatar(
            radius: 30,
            backgroundColor: ColorManager.primary,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User's name
                Text(
                  user.fullName, // Display user's full name
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // User's email
                Text(
                  user.email, // Display user's email
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                // User's phone number
                Text(
                  user.phone, // Display user's phone number
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                // User's location
                Text(
                  user.address, // Display user's location
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Right icon (for more details or actions)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: ColorManager.black.withOpacity(0.5),
                size: 30,
              ),
              const SizedBox(height: 4),
              // Number of surveys
              //   Text(
              //     "${user.surveysCount} Surveys",  // Display number of surveys
              //     style: TextStyle(
              //       fontSize: 12,
              //       fontWeight: FontWeight.w500,
              //       color: Colors.grey,
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    ),
  );
}
