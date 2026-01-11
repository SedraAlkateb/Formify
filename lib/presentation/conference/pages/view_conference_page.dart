import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/data/mapper/mapper.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/survey/widget/list_survey_widget.dart';

class ViewConferencePage extends StatelessWidget {
  const ViewConferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Navigator.pop(context),
            icon:Icon(Icons.arrow_back_ios_new,color: ColorManager.black,)
        ),
          title:  Text("Conference Details",style: TextStyle(color: ColorManager.black),),
      backgroundColor: ColorManager.white,
      ),
      body: BlocBuilder<ConferenceBloc, ConferenceState>(
        builder: (context, state) {
          if (state is GetConferenceByIdState) {
            final GetAllConferenceByIdModel  conference = state.conferenceModel;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conference header section (Card with Conference Info)
              Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4C4EB9),  // اللون الأول (أزرق)
                    Color(0xFF7A7EF4),  // اللون الثاني (أزرق فاتح)
                    Color(0xFFA4A6E1),
                  ],
                  begin: Alignment.topLeft,   // البداية من الزاوية العليا اليسرى
                  end: Alignment.bottomRight, // النهاية عند الزاوية السفلى اليمنى
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              // إضافة أي محتوى هنا داخل الـ Container
            padding: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conference.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Conference Description
                          Text(
                            conference.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Date and location section
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(

                    shadowColor: ColorManager.white,
                    color: ColorManager.white,
                    shape: RoundedRectangleBorder(
                     // side: BorderSide(color: ColorManager.fieldBackground, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Section
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.blue, size: 30),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "From: ",  // النص الثابت "From:"
                                          style: TextStyle(
                                            fontSize: 18,  // حجم الخط
                                            fontWeight: FontWeight.bold,  // خط عريض
                                            color: Colors.black,  // اللون
                                          ),
                                        ),
                                        TextSpan(
                                          text: conference.startDate,  // التاريخ أو النص الذي ترغب في عرضه
                                          style: TextStyle(
                                            fontSize: 18,  // حجم الخط
                                            fontWeight: FontWeight.normal,  // خط عادي
                                            color: Colors.black,  // اللون المخصص
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "To: ",  // النص الثابت "To:"
                                          style: TextStyle(
                                            fontSize: 18,  // حجم الخط
                                            fontWeight: FontWeight.bold,  // خط عريض
                                            color: Colors.black,  // اللون
                                          ),
                                        ),
                                        TextSpan(
                                          text: conference.endDate,  // التاريخ أو النص الذي ترغب في عرضه
                                          style: TextStyle(
                                            fontSize: 18,  // حجم الخط
                                            fontWeight: FontWeight.normal,  // خط عادي
                                            color: Colors.black,  // اللون المخصص
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(color: ColorManager.fieldBackground, height: 5),
                        // Location Section
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.orange, size: 30),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  conference.address,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.description_outlined),
                            SizedBox(width: 8,),
                            Text(
                              "Surveys",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("استبيان "),
                            Text(conference.surveys.length.toString()),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 4,),
                  // List of Surveys (ListView)
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: conference.surveys.length, // Number of surveys
                    itemBuilder: (context, index) {

                      return surveyListWidget( conference.surveys[index].toDomain());
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


