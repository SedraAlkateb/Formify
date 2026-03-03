import 'package:flutter/material.dart';
import 'package:formify/presentation/excel/ex.dart';
import 'package:formify/presentation/excel/widget/bar_chart_widget.dart';
import 'package:formify/presentation/excel/widget/line_chart_widget.dart';
import 'package:formify/presentation/excel/widget/pie_chart_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Bar Chart"),
          BarChartWidget(data: stats),

          SizedBox(height: 40),

          Text("Line Chart"),
          LineChartWidget(data: stats),


          SizedBox(height: 40),

          Text("Pie Chart"),
          PieChartWidget(data: stats),
        ],
      ),
    );
  }
}
