import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/presentation/excel/bloc/excel_st_bloc.dart';
import 'package:formify/presentation/excel/widget/export_exel.dart';

class ExelConferencePage extends StatefulWidget {
  const ExelConferencePage({super.key,required this.filename});
  final String filename;
  @override
  State<ExelConferencePage> createState() => _ExelConferencePageState();
}

class _ExelConferencePageState extends State<ExelConferencePage> {
  String searchQuery = '';
  String selectedSearchField = 'all';
  int? _hoveredRowIndex;
  double tableScale = 1.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final double headerCellWidth = 200 * tableScale;
    final double normalCellWidth = 200 * tableScale;
    final double smallCellWidth = 70 * tableScale;
    final double columnSpacing = 40 * tableScale;
    final double headingRowHeight = 110 * tableScale;
    final double dataRowMinHeight = 64 * tableScale;
    final double dataRowMaxHeight = 120 * tableScale;
    final double headerFontSize = 14 * tableScale;
    final double dataFontSize = 16 * tableScale;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title:  Text(widget. filename),
        backgroundColor: colors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () async {
              try {
                final file = await exportUsersToExcel(
                  userAnswersList:BlocProvider.of<ExcelStBloc>(context).userAnswersList,
                  questionsMap: BlocProvider.of<ExcelStBloc>(context).questionsMap,
                  filename: widget. filename,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حفظ الملف: ${file.path}')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('حدث خطأ أثناء حفظ الملف: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0,right: 16),
        child: BlocBuilder<ExcelStBloc, ExcelStState>(
          builder: (context, state) {
            if (state is! ExelSuccess) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<Map<String, String>> exelModel = state.exelModel;
            final Map<int, String> rowExcel = state.rowExcel;
            final Map<String, String> searchFields =state.searchFields;


            if (!searchFields.containsKey(selectedSearchField)) {
              selectedSearchField = 'all';
            }

            final filteredUsers = searchQuery.trim().isEmpty
                ? exelModel
                : exelModel.where((user) {
              final query = searchQuery.toLowerCase().trim();

              if (selectedSearchField == 'all') {
                return user.values.any(
                      (value) => value.toLowerCase().contains(query),
                );
              }

              final fieldValue =
              (user[selectedSearchField] ?? '').toLowerCase().trim();

              return fieldValue.contains(query);
            }).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40,),
                  DropdownButtonFormField<String>(
                   value: selectedSearchField,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'فلترة حسب الحقل',
                    ),
                    items: searchFields.entries.map((entry) {

                      return DropdownMenuItem<String>(

                        value: entry.key,

                        child: Text(
                          entry.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedSearchField = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                    decoration: InputDecoration(

                      labelText:
                      'بحث ضمن: ${searchFields[selectedSearchField]}',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'عدد النتائج: ${filteredUsers.length}',
                    style: TextStyle(
                      fontSize: 15,
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              tooltip: 'تصغير الجدول',
                              onPressed: () {
                                setState(() {
                                  tableScale =
                                      (tableScale - 0.1).clamp(0.5, 2.0);
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              '${(tableScale * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            IconButton(
                              tooltip: 'تكبير الجدول',
                              onPressed: () {
                                setState(() {
                                  tableScale =
                                      (tableScale + 0.1).clamp(0.5, 2.0);
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            tableScale = 1.0;
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة الحجم'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              colors.primary,
                            ),
                            columnSpacing: columnSpacing,
                            dividerThickness: 1,
                            headingRowHeight: headingRowHeight,
                            dataRowMinHeight: dataRowMinHeight,
                            dataRowMaxHeight: dataRowMaxHeight,
                            dataTextStyle: TextStyle(
                              fontSize: dataFontSize,
                              color: Colors.black,
                            ),
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                color: colors.outlineVariant.withOpacity(0.25),
                              ),
                              verticalInside: BorderSide(
                                color: colors.outlineVariant.withOpacity(0.15),
                              ),
                              bottom: BorderSide(
                                color: Colors.black.withOpacity(0.25),
                                width: 1,
                              ),
                            ),
                            columns: [
                              DataColumn(
                                numeric: true,
                                label: SizedBox(
                                  width: smallCellWidth,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: 10 * tableScale,
                                    ),
                                    child: Text(
                                      '#',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: headerFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: normalCellWidth,
                                  child: Text(
                                    'اسم المستخدم',
                                    maxLines: 3,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: headerFontSize,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: normalCellWidth,
                                  child: Text(
                                    'العنوان',
                                    maxLines: 3,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: headerFontSize,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                              ...rowExcel.entries.map((entry) {
                                return DataColumn(
                                  label: SizedBox(
                                    width: headerCellWidth,
                                    child: Text(
                                      entry.value,
                                      maxLines: 4,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: headerFontSize,
                                        fontWeight: FontWeight.w600,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                            rows: [
                              for (int i = 0; i < filteredUsers.length; i++)
                                DataRow(
                                  onHover: (isHovered) {
                                    setState(() {
                                      _hoveredRowIndex = isHovered ? i : null;
                                    });
                                  },
                                  color: WidgetStateProperty.resolveWith<Color?>(
                                        (states) {
                                      if (_hoveredRowIndex == i) {
                                        return Colors.blue.withOpacity(0.12);
                                      }
                                      return i.isOdd
                                          ? colors.surfaceContainerLow
                                          : Colors.white;
                                    },
                                  ),
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: smallCellWidth,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: 10 * tableScale,
                                          ),
                                          child: Text('${i + 1}'),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: normalCellWidth,
                                        child: Text(
                                          filteredUsers[i]['user'] ?? '',
                                          maxLines: 3,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: normalCellWidth,
                                        child: Text(
                                          filteredUsers[i]['address'] ?? '',
                                          maxLines: 3,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    ...rowExcel.entries.map((entry) {
                                      return DataCell(
                                        SizedBox(
                                          width: normalCellWidth,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Text(
                                              filteredUsers[i][entry.value] ??
                                                  'لا توجد إجابة',
                                              maxLines: 10,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}