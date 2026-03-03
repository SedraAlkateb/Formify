import 'package:flutter/material.dart';
import 'package:formify/presentation/excel/ex.dart';
import 'package:formify/presentation/excel/page/open_exel_page.dart';

class ExelConferencePage extends StatefulWidget
{
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

  @override
  void initState() {
    super.initState();
    fetchUserData().then((data) {
      setState(() {
        allUsers = data;
        filteredUsers = data;
      });
    });
  }

  void filterData(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = allUsers.where((user) {
        return user['username'].toLowerCase().contains(query.toLowerCase()) ||
            user['location'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض بيانات المستخدمين'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () {
              generateExcel(filteredUsers); // حفظ البيانات في ملف Excel
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: filterData,
              decoration: InputDecoration(
                labelText: 'بحث حسب الاسم أو الموقع',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // تمكين التمرير الأفقي
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('اسم المستخدم')),
                    DataColumn(label: Text('الموقع')),
                    DataColumn(label: Text('أكثر دواء مفضل')),
                  ],
                  rows: filteredUsers.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(user['username'])),
                      DataCell(Text(user['location'])),
                      DataCell(Text(user['favoriteMedicine'])),
                    ]);
                  }).toList(),
                ),
              ),
            ),

            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OpenFilePage(),));
            }, child: Text("fghfdgd"))
          ],
        ),
      ),
    );
  }
}
