import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Widget allUserWidget(UserModel user) {
  final gradients = [
    [Color(0xFFff9a9e), Color(0xFFfad0c4)],
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    [Color(0xFFfbc2eb), Color(0xFFa6c1ee)],
  ];

  final colors = gradients[user.id % gradients.length];

  return Card(

    color: ColorManager.white,
    shape: RoundedRectangleBorder(

      side: BorderSide(

          color: ColorManager.black.withOpacity(0.1), width: 1),

      borderRadius: BorderRadius.circular(12),

    ),

    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image circle (if needed)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /*
                     decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF4C4EB9), // اللون الأول (أزرق)
                                  Color(0xFF7A7EF4), // اللون الثاني (أزرق فاتح)
                                  Color(0xFFA4A6E1),
                                ],
                                begin: Alignment
                                    .topLeft, // البداية من الزاوية العليا اليسرى
                                end: Alignment
                                    .bottomRight, // النهاية عند الزاوية السفلى اليمنى
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                   */

      Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
      colors: colors,
      ),
    ),
    child: Center(
      child: Text(
        user.fullName[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    ),
  ),
  SizedBox(width: 10),
                  Text(
                    user.fullName, // Display user's full name
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              Icon(
                Icons.arrow_forward_ios,
                color: ColorManager.black.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              SizedBox(width: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User's name
                  const SizedBox(height: 4),
                  // User's email
                  Row(
                    children: [
                      Icon(Icons.email_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        user.email, // Display user's email
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        user.phone, // Display user's email
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        user.address, // Display user's email
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Right icon (for more details or actions)
        ],
      ),
    ),
  );
}
Widget userWidget(UserModel user) {
  final gradients = [
    [Color(0xFFff9a9e), Color(0xFFfad0c4)],
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    [Color(0xFFfbc2eb), Color(0xFFa6c1ee)],
  ];

  final colors = gradients[user.id % gradients.length];

  return Card(

    color: ColorManager.white,
    shape: RoundedRectangleBorder(

      side: BorderSide(

          color: ColorManager.black.withOpacity(0.1), width: 1),

      borderRadius: BorderRadius.circular(12),

    ),

    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image circle (if needed)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: colors,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user.fullName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    user.fullName, // Display user's full name
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              SizedBox(width: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User's name
                  const SizedBox(height: 4),
                  // User's email
                  Row(
                    children: [
                      Icon(Icons.email_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        user.email, // Display user's email
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        user.phone, // Display user's email
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        user.address, // Display user's email
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Right icon (for more details or actions)
        ],
      ),
    ),
  );
}

