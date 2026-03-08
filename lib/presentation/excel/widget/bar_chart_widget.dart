import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:formify/presentation/excel/ex.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartPoint> data;

  const BarChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(data.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data[index].value.toDouble(),
                  width: 25,
                ),
              ],
            );
          }),
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