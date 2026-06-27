import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';


class DoctorExcelPage extends StatefulWidget {
  const DoctorExcelPage({super.key,required this.allDoctors});
 final List<UserModel>allDoctors ;
  @override
  State<DoctorExcelPage> createState() => _DoctorExcelPageState();
}

class _DoctorExcelPageState extends State<DoctorExcelPage> {
  String searchQuery = '';
  double tableScale = 1.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // حسابات الأحجام بناءً على المقياس (Scale)
    final double normalCellWidth = 160 * tableScale;
    final double smallCellWidth = 50 * tableScale;
    final double headerFontSize = 14 * tableScale;
    final double dataFontSize = 15 * tableScale;

    final filteredDoctors = widget.allDoctors.where((doc) {
      final query = searchQuery.toLowerCase();
      return doc.fullName.toLowerCase().contains(query) ||
          doc.phone.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("عرض بيانات الأطباء"),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // حقل البحث
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                labelText: 'بحث بالاسم أو العنوان أو الرقم...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // أزرار التحكم بالحجم
            Row(
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => setState(() => tableScale = (tableScale - 0.1).clamp(0.5, 1.5))),
                Text("${(tableScale * 100).round()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => tableScale = (tableScale + 0.1).clamp(0.5, 1.5))),
                const Spacer(),
                Text("النتائج: ${filteredDoctors.length}", style: TextStyle(color: colors.primary)),
              ],
            ),
            const SizedBox(height: 10),

            // الجدول
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(colors.primary),
                        headingRowHeight: 60 * tableScale,
                        dataRowMinHeight: 50 * tableScale,
                        dataRowMaxHeight: 80 * tableScale,
                        columns: _buildColumns(headerFontSize),
                        rows: filteredDoctors.asMap().entries.map((entry) {
                          return _buildDataRow(entry.key, entry.value, dataFontSize, smallCellWidth, normalCellWidth, colors);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(double fontSize) {
    const labels = ['#', 'اسم المستخدم', 'العنوان', 'الرقم', 'النوع','الملاحظة'];
    return labels.map((label) => DataColumn(
        label: Text(label, style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold))
    )).toList();
  }

  DataRow _buildDataRow(int index, UserModel doc, double fontSize, double smallWidth, double normalWidth, ColorScheme colors) {
    final style = TextStyle(fontSize: fontSize);
    return DataRow(
      color: WidgetStateProperty.all(index.isOdd ? colors.surfaceVariant.withOpacity(0.3) : Colors.white),
      cells: [
        DataCell(SizedBox(width: smallWidth, child: Text('${index + 1}', style: style))),
        DataCell(SizedBox(width: normalWidth, child: Text(doc.fullName, style: style))),
        DataCell(SizedBox(width: normalWidth, child: Text(doc.address??"", style: style))),
        DataCell(SizedBox(width: normalWidth, child: Text(doc.phone, style: style))),
        DataCell(SizedBox(width: normalWidth, child: Text(doc.userType.name, style: style))),
        DataCell(SizedBox(width: normalWidth, child: Text(doc.notes??"", style: style))),
      ],
    );
  }
}