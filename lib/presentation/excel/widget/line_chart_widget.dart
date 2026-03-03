import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:formify/presentation/excel/ex.dart';

class LineChartWidget extends StatelessWidget {
  final List<ChartPoint> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: List.generate(
                data.length,
                    (index) => FlSpot(
                  index.toDouble(),
                  data[index].value.toDouble(),
                ),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(data[value.toInt()].label);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}