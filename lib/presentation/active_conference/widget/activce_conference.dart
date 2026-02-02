import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

class ActiveConferenceWidget extends StatelessWidget {
  const ActiveConferenceWidget({
    super.key,
    required this.conference,
  });
  final GetAllConferenceModel conference;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.event_available, color: ColorManager.primary, size: 30),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  " ${conference.name}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Started at: ${conference.startDate}",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                Text(
                  "Ended at:  ${conference.endDate}",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
