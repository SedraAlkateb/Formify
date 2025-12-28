import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class ConferenceEndedWidget extends StatelessWidget {
  const ConferenceEndedWidget({super.key,required this.index});
  final int index;
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
          Icon(
            Icons.event_available,
            color: ColorManager.primary,
            size: 30,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " ${BlocProvider.of<ConferenceBloc>(context).allNotActiveConference[index].name} ${index + 1}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Started at: ${BlocProvider.of<ConferenceBloc>(context).allNotActiveConference[index].startDate}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  "Ended at:  ${BlocProvider.of<ConferenceBloc>(context).allNotActiveConference[index].endDate}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: ColorManager.secondary,
          ),
        ],
      ),
    );
  }
}
