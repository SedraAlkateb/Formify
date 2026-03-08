import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/excel/bloc/excel_st_bloc.dart';
import 'package:formify/presentation/excel/page/open_exel_page.dart';

class ExelConferencePage extends StatefulWidget {
  const ExelConferencePage({super.key});

  @override
  _ExelConferencePageState createState() {
    return _ExelConferencePageState();
  }
}

class _ExelConferencePageState extends State<ExelConferencePage> {
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  String searchQuery = '';
  int? _hoveredRowIndex;  //  لتخزين صف الـ hover

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('عرض بيانات المستخدمين'),
        backgroundColor: colors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () {
              //   generateExcel(filteredUsers); // حفظ البيانات في ملف Excel
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ExcelStBloc, ExcelStState>(
          builder: (context, state) {
            if (state is ExelSuccess) {
              final List<Map<String, String>> exelModel = state.exelModel;
              final Map<int, String> rowExcel = state.rowExcel;
              return Column(
                children: [
                  TextField(
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                        filteredUsers = exelModel.where((user) {
                          return user['user']!.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              ) ||
                              user['address']!.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              );
                        }).toList();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'بحث حسب الاسم أو الموقع',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // لتمكين التمرير الأفقي
                      child: SingleChildScrollView(
                        scrollDirection:
                            Axis.vertical, // لتمكين التمرير العمودي
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                "#",
                                style: TextStyle(
                                  color: Colors.white,
                                ), // تغيير لون النص في الهيدر
                              ),
                              numeric: true,
                            ),
                            DataColumn(
                              label: Text(
                                "اسم المستخدم",
                                style: TextStyle(
                                  color: Colors.white,
                                ), // تغيير لون النص في الهيدر
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "العنوان",
                                style: TextStyle(
                                  color: Colors.white,
                                ), // تغيير لون النص في الهيدر
                              ),
                            ),
                            // إضافة الأعمدة المتبقية
                            ...rowExcel.entries.map((entry) {
                              return DataColumn(
                                label: Text(
                                  entry.value,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ), // تغيير لون النص في الهيدر
                                ),
                              );
                            }).toList(),
                          ],
                          rows: [
                            for (
                              int i = 0;
                              i <
                                  (filteredUsers.isNotEmpty
                                          ? filteredUsers
                                          : exelModel)
                                      .length;
                              i++
                            )
                              DataRow(
                                onHover: (isHovered) {
                                  setState(() {
                                    print("object");
                                    _hoveredRowIndex = isHovered ? i : null;
                                  });
                                },
                                color: MaterialStateProperty.resolveWith<Color?>((
                                  Set<MaterialState> states,
                                ) {
                                  return _hoveredRowIndex == i
                                      ? Colors.blue
                                      : i.isOdd
                                      ? colors.surfaceContainerLow
                                      : Colors
                                            .white; // زيادة التباعد بين الصفوف
                                }),
                                cells: [

                                  // إضافة الترقيم في بداية الصف
                                  DataCell(
                                    Text('${i + 1}'),
                                  ), // الترقيم يبدأ من 1
                                  DataCell(
                                    Text(
                                      filteredUsers.isNotEmpty
                                          ? filteredUsers[i]['user'] ?? ''
                                          : exelModel[i]['user'] ?? '',
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      filteredUsers.isNotEmpty
                                          ? filteredUsers[i]['address'] ?? ''
                                          : exelModel[i]['address'] ?? '',
                                    ),
                                  ),
                                  // إضافة الأعمدة المتبقية
                                  ...rowExcel.entries.map((entry) {
                                    return DataCell(
                                      Text(
                                        filteredUsers.isNotEmpty
                                            ? filteredUsers[i][entry.value] ??
                                                  "لا توجد إجابة"
                                            : exelModel[i][entry.value] ??
                                                  "لا توجد إجابة",
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                          ],
                          columnSpacing: 120, // زيادة المسافة بين الأعمدة
                          dividerThickness: 1,
                          headingRowHeight: 80,
                          dataRowHeight: 80,
                          decoration: BoxDecoration(
                            color:
                                colors.primary, // تغيير لون الخلفية للـ header
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // حدود دائرية للجدول
                          ),
                          border: TableBorder(
                            horizontalInside: BorderSide(
                              color: Colors.transparent,
                            ), // إزالة الفواصل بين الصفوف
                            verticalInside: BorderSide(
                              color: Colors.transparent,
                            ), // إزالة الفواصل بين الأعمدة
                            bottom: BorderSide(
                              color: Colors.black.withOpacity(
                                0.5,
                              ), // إضافة حد أسفل الجدول
                              width: 1,
                            ),
                          ),
                          dataTextStyle: TextStyle(
                            fontSize: 16, // تغيير حجم الخط
                            color: Colors.black, // لون النص
                          ),
                        ),
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OpenFilePage()),
                      );
                    },
                    child: Text("فتح ملف Excel"),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
