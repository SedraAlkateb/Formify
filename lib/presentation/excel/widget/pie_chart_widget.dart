import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:formify/presentation/excel/ex.dart';

class PieChartWidget extends StatelessWidget {
  final List<ChartPoint> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: List.generate(data.length, (index) {
            return PieChartSectionData(
              value: data[index].value.toDouble(),
              title: data[index].label,
              radius: 60,
            );
          }),
        ),
      ),
    );
  }
}