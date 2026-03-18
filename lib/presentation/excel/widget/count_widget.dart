import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';

class UserTypeCountBoxes extends StatelessWidget {
  const UserTypeCountBoxes({
    super.key,
    required this.data,
  });

  final List<CountModel> data;



  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          " الحضور",
          style: TextStyle(
            fontSize: FontResponsive.font(
              context,
              mobile: 20,
              tablet: 24,
            ),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: data.map((item) {
            return Container(
              width: 170,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ColorManager.border),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    userTypeFromId(item.typeId).icon,
                    color: ColorManager.primary,
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.typeName,
                        style: TextStyle(
                          fontSize: FontResponsive.font(
                            context,
                            mobile: 15,
                            tablet: 18,
                          ),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${item.count}",
                        style: TextStyle(
                          color: ColorManager.primary,
                          fontSize: FontResponsive.font(
                            context,
                            mobile: 24,
                            tablet: 28,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}