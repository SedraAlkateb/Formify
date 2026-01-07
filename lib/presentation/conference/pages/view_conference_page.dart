import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class ViewConferencePage extends StatelessWidget {
  const ViewConferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Conference Details",
        ),

      ),
      body: BlocBuilder<ConferenceBloc, ConferenceState>(
        builder: (context, state) {
          if (state is GetConferenceByIdState) {
            final conference = state.conferenceModel;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conference header section (Card with Conference Info)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Icon
                          Row(
                            children: [
                              Icon(Icons.event, color: Colors.purple, size: 30),
                              const SizedBox(width: 10),
                              Text(
                                conference.name,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Conference Description
                          Text(
                              conference.description,
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 20),
                          // Date and location section

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConferenceDetailsCard(),
                  // Surveys Section Header
                  Text(
                    "Surveys",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),

                  // List of Surveys (ListView)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 6, // Number of surveys
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Survey ${index + 1}: Feedback on Conference",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ConferenceDetailsCard extends StatelessWidget {
  const ConferenceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: ColorManager.fieldBackground,
      color: ColorManager.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: ColorManager.fieldBackground,width: 2),
        borderRadius: BorderRadius.circular(12),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue, size: 30),
                const SizedBox(width: 8),
                Text(
                  "Mar 15 - Mar 18",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
           Container(
               color: ColorManager.fieldBackground,
              height: 5),
          // Location Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange, size: 30),
                const SizedBox(width: 8),
                Text(
                  "Riyadh International Convention & Exhibition Center, Riyadh, Saudi Arabia",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
