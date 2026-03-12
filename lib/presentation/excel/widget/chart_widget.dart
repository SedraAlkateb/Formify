import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ChartType { line, pie, bar, starChart, starResult }

class StatisticsChartsSection extends StatelessWidget {
  final List<StatisticStatModel> data;

  const StatisticsChartsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Statistics2ChartCard(data: data),
        const SizedBox(height: 16),
        Statistics3ChartCard(data: data),
      ],
    );
  }
}

////////////////////////
/// CARD 1
/// line + pie + bar
class Statistics2ChartCard extends StatefulWidget {
  final List<StatisticStatModel> data;

  const Statistics2ChartCard({super.key, required this.data});

  @override
  State<Statistics2ChartCard> createState() => _Statistics2ChartCardState();
}

class _Statistics2ChartCardState extends State<Statistics2ChartCard> {
  ChartType selectedType = ChartType.bar;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton(
                    label: 'خطي',
                    type: ChartType.line,
                    icon: Icons.show_chart_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTypeButton(
                    label: 'دائري',
                    type: ChartType.pie,
                    icon: Icons.pie_chart_outline_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTypeButton(
                    label: 'شريطي',
                    type: ChartType.bar,
                    icon: Icons.bar_chart_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: SizedBox(
                key: ValueKey(selectedType),
                child: _buildSelectedChart(),
              ),
            ),
            const SizedBox(height: 16),
            _CountsList(data: widget.data, showPercent: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required ChartType type,
    required IconData icon,
  }) {
    final isSelected = selectedType == type;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedChart() {
    switch (selectedType) {
      case ChartType.line:
        return SyncLineChartWidget(data: widget.data);
      case ChartType.pie:
        return SyncPieChartWidget(data: widget.data);
      case ChartType.bar:
        return SyncBarChartWidget(data: widget.data);
      default:
        return SyncBarChartWidget(data: widget.data);
    }
  }
}

////////////////////////
/// CARD 2
/// spline + area + splineArea
class Statistics3ChartCard extends StatefulWidget {
  final List<StatisticStatModel> data;

  const Statistics3ChartCard({super.key, required this.data});

  @override
  State<Statistics3ChartCard> createState() => _Statistics3ChartCardState();
}

class _Statistics3ChartCardState extends State<Statistics3ChartCard> {
  ChartType selectedType = ChartType.starResult;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton(
                    label: 'قيم النجوم',
                    type: ChartType.starResult,
                    icon: Icons.show_chart_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTypeButton(
                    label: 'مخطط النجوم',
                    type: ChartType.starChart,
                    icon: Icons.area_chart_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: SizedBox(
                key: ValueKey(selectedType),
                child: _buildSelectedChart(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required ChartType type,
    required IconData icon,
  }) {
    final isSelected = selectedType == type;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedChart() {
    switch (selectedType) {
      case ChartType.starResult:
        return StarRatingResultWidget(data: widget.data);
      case ChartType.starChart:
        return StarRatingChartWidget(data: widget.data);
      default:
        return StarRatingChartWidget(data: widget.data);
    }
  }
}

////////////////////////
/// COUNTS LIST
class _CountsList extends StatelessWidget {
  final List<StatisticStatModel> data;
  final bool showPercent;
  const _CountsList({required this.data, this.showPercent = false});
  @override
  Widget build(BuildContext context) {
    final colors = _chartColors;
    return Column(
      children: List.generate(data.length, (index) {
        final item = data[index];
        final color = colors[index % colors.length];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(
                '% ${item.total} إجابة',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  item.title,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(radius: 5, backgroundColor: color),
            ],
          ),
        );
      }),
    );
  }
}

////////////////////////
/// BAR
class SyncBarChartWidget extends StatelessWidget {
  final List<StatisticStatModel> data;

  const SyncBarChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: data.length > 3 ? -35 : 0,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          interval: _getIntervalFromData(data),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<StatisticStatModel, String>>[
          ColumnSeries<StatisticStatModel, String>(
            dataSource: data,
            xValueMapper: (item, _) => item.title,
            yValueMapper: (item, _) => item.count,
            pointColorMapper: (item, index) =>
                _chartColors[index % _chartColors.length],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

////////////////////////
/// LINE
class SyncLineChartWidget extends StatelessWidget {
  final List<StatisticStatModel> data;

  const SyncLineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: data.length > 3 ? -35 : 0,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          interval: _getIntervalFromData(data),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<StatisticStatModel, String>>[
          LineSeries<StatisticStatModel, String>(
            dataSource: data,
            xValueMapper: (item, _) => item.title,
            yValueMapper: (item, _) => item.count,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            markerSettings: const MarkerSettings(isVisible: true),
            width: 3,
          ),
        ],
      ),
    );
  }
}

////////////////////////
/// PIE
class SyncPieChartWidget extends StatelessWidget {
  final List<StatisticStatModel> data;

  const SyncPieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCircularChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        legend: const Legend(isVisible: false),
        series: <CircularSeries<StatisticStatModel, String>>[
          PieSeries<StatisticStatModel, String>(
            dataSource: data,
            xValueMapper: (item, _) => item.title,
            yValueMapper: (item, _) => item.count,
            pointColorMapper: (item, index) =>
                _chartColors[index % _chartColors.length],
            dataLabelMapper: (item, _) => '${item.count}',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////
/// StarRatingChart

class StarRatingResultWidget extends StatefulWidget {
  final List<StatisticStatModel> data;

  const StarRatingResultWidget({
    super.key,
    required this.data,
  });

  @override
  State<StarRatingResultWidget> createState() => _StarRatingResultWidgetState();
}

class _StarRatingResultWidgetState extends State<StarRatingResultWidget>
    with SingleTickerProviderStateMixin {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalAnswers = widget.data.fold<int>(
      0,
          (sum, item) => sum + item.count,
    );

    final items = widget.data.reversed.toList();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _showContent ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showContent ? Offset.zero : const Offset(0, 0.06),
        curve: Curves.easeOutCubic,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'توزيع التقييم بالنجوم',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'إجمالي الإجابات: $totalAnswers',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),

              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final percent =
                totalAnswers == 0 ? 0.0 : item.count / totalAnswers;

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percent),
                  duration: Duration(milliseconds: 500 + (index * 120)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 42,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                '${item.count}',
                                key: ValueKey(item.count),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: value,
                                minHeight: 12,
                                backgroundColor: Colors.grey.shade200,
                                valueColor:
                                const AlwaysStoppedAnimation<Color>(
                                  Colors.amber,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: List.generate(5, (starIndex) {
                                final isFilled =
                                    (starIndex + 1) >= (5 - index);

                                return TweenAnimationBuilder<double>(
                                  tween: Tween(
                                    begin: 0.85,
                                    end: _showContent ? 1.0 : 0.85,
                                  ),
                                  duration: Duration(
                                    milliseconds: 300 + (starIndex * 50),
                                  ),
                                  curve: Curves.easeOutBack,
                                  builder: (context, scale, child) {
                                    return Transform.scale(
                                      scale: scale,
                                      child: Icon(
                                        isFilled
                                            ? Icons.star_rounded
                                            : Icons.star_border_rounded,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class StarRatingChartWidget extends StatelessWidget {
  final List<StatisticStatModel> data;

  const StarRatingChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          interval: _getIntervalFromData(data),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<StatisticStatModel, String>>[
          ColumnSeries<StatisticStatModel, String>(
            dataSource: data,
            xValueMapper: (item, _) =>item.title,
              //  _buildStarsLabel(int.parse(item.title.split(' ')[0])),
            yValueMapper: (item, _) => item.count,
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  String _buildStarsLabel(int count) {
    return '★' * count;
  }
}
double _getIntervalFromData(List<StatisticStatModel> data) {
  if (data.isEmpty) return 1;

  final values = data.map((e) => e.count).toList();
  final max = values.reduce((a, b) => a > b ? a : b).toDouble();

  if (max <= 5) return 1;
  if (max <= 10) return 2;
  if (max <= 50) return 5;
  if (max <= 100) return 10;

  return (max / 5).ceilToDouble();
}

const List<Color> _chartColors = [
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.red,
  Colors.purple,
  Colors.teal,
];

class StatisticsCountBoxes extends StatelessWidget {
  final List<StatisticStatModel> data;

  const StatisticsCountBoxes({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(data.length, (index) {
        final item = data[index];
        final color = _chartColors[index % _chartColors.length];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 8, left: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color, width: 1.5),
            ),
            child: Column(
              children: [
                Text(
                  '${item.count}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
