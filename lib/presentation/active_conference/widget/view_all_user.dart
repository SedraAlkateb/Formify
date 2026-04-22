import 'package:flutter/material.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/values_manager.dart';

Widget userListItem(UserModel user, BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: AppPadding.p12,
      vertical: AppPadding.p5,
    ),
    padding: EdgeInsets.all(AppPadding.p12),
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
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            /// Avatar ثابت مع icon
            Container(
              width: AppSize.s45,
              height: AppSize.s45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.splash1,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: Constants.isTablet ? 30 : 26,
              ),
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
                    style: TextStyle(
                      fontSize: FontResponsive.font(
                        context,
                        mobile: 15,
                        tablet: 19,
                      ),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: AppSize.s4),
                  user.address!=""?
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: Constants.isTablet ? 18 : 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          user.address??"",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Constants.isTablet ? 17 : 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      )
                    ],
                  ):SizedBox(),
                  user.email!=""?
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: Constants.isTablet ? 18 : 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          user.email??"",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Constants.isTablet ? 17 : 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      )
                    ],
                  ):SizedBox(),
                  const SizedBox(height: 2),
                  /// Phone
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: Constants.isTablet ? 18 : 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user.phone,
                        style: TextStyle(
                          fontSize: Constants.isTablet ? 17 : 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.push_pin_outlined,
                        size: Constants.isTablet ? 18 : 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user.userType.nameAr,
                        style: TextStyle(
                          fontSize: Constants.isTablet ? 17 : 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

          ],
        ),


        SizedBox(height: AppSize.s10),
        Divider(),
        /// Arrow
        Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
          size: Constants.isTablet ? 18 : 22,
        ),
      ],
    ),
  );
}

Widget userWidget(UserModel user, BuildContext context) {
  return Card(
    color: ColorManager.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: ColorManager.black.withOpacity(0.1), width: 1),

      borderRadius: BorderRadius.circular(12),
    ),

    elevation: 5,
    child: Padding(
      padding: EdgeInsets.all(20),
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
                    width: AppSize.s45,
                    height: AppSize.s45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.splash1,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: Constants.isTablet ? 30 : 26,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    user.fullName, // Display user's full name
                    style: TextStyle(
                      fontSize: FontResponsive.font(
                        context,
                        mobile: 16,
                        tablet: 20,
                      ),

                      fontWeight: FontWeight.bold,
                    ),
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
                      user.email!=null?
                      Text(
                        user.email??"", // Display user's email
                        style: TextStyle(
                          fontSize: FontResponsive.font(
                            context,
                            mobile: 14,
                            tablet: 18,
                          ),

                          color: Colors.black,
                        ),
                      ):SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        user.phone, // Display user's email
                        style: TextStyle(
                          fontSize: FontResponsive.font(
                            context,
                            mobile: 14,
                            tablet: 18,
                          ),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  user.address!=null?
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        user.address??"", // Display user's email
                        style: TextStyle(
                          fontSize: FontResponsive.font(
                            context,
                            mobile: 15,
                            tablet: 18,
                          ),

                          color: Colors.black,
                        ),
                      ),
                    ],
                  ):SizedBox(),
                  const SizedBox(height: 4),
                  // User's email
                  Row(
                    children: [
                      Icon(Icons.push_pin_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        user.userType.nameAr, // Display user's email
                        style: TextStyle(
                          fontSize: FontResponsive.font(
                            context,
                            mobile: 14,
                            tablet: 18,
                          ),

                          color: Colors.black,
                        ),
                      )
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
