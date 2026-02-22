import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';

Widget userListItem(UserModel user) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: ColorManager.black.withOpacity(0.08)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        /// Avatar ثابت مع icon
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ColorManager.splash1,
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 26),
        ),

        const SizedBox(width: 12),

        /// Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Name
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              /// Email
              Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      user.email,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              /// Phone
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    user.phone,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// Arrow
        Icon(Icons.chevron_right, color: Colors.grey.shade400),
      ],
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
      side: BorderSide(color: ColorManager.black.withOpacity(0.1), width: 1),

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
                      gradient: LinearGradient(colors: colors),
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
