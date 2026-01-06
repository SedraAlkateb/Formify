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
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
        ),
        backgroundColor: ColorManager.primary,
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
                  // Conference Name Section
                  _buildSection(
                    title: "Conference Name",
                    content: conference.name,
                  ),

                  // Description Section
                  _buildSection(
                    title: "Description",
                    content: conference.description,
                  ),

                  // Address Section
                  _buildSection(
                    title: "Address",
                    content: conference.address,
                  ),

                  // Dates Section
                  _buildDatesSection(conference),

                  // Is Active Section
                  _buildIsActiveSection(conference),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator()); // Show loading while fetching data
          }
        },
      ),
    );
  }

  // Reusable method to build a section with title and content
  Widget _buildSection({required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the Dates Section
  Widget _buildDatesSection(conference) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Conference Dates",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Start Date: ${conference.startDate}",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              "End Date: ${conference.endDate}",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the Is Active Section
  Widget _buildIsActiveSection(conference) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Text(
              'Is Active: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              conference.isActive ? 'Yes' : 'No',
              style: TextStyle(fontSize: 16, color: conference.isActive ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
