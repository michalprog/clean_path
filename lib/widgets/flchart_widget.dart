import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/data_types/record.dart';
import '/utils_files/statistic_utils.dart';

class FlchartWidget extends StatelessWidget {
  final List<Record> records;

  const FlchartWidget({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    double screenWidth = MediaQuery.of(context).size.width;

    final spots = StatisticUtils.convertRecordsToFlSpots(records);
    final minY = spots.isEmpty ? 0 : spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.isEmpty ? 1 : spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final maxX = spots.isEmpty ? 1 : spots.map((s) => s.x).reduce((a, b) => a > b ? a : b);
    final intervalY = (maxY / 5).ceilToDouble().clamp(1, double.infinity);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Średni czas trwania prób',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 200,
            width: screenWidth * 0.9,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff1a1a2e),
              borderRadius: BorderRadius.circular(16),
            ),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: maxX.toDouble(),
                minY: 0,
                maxY: maxY.toDouble(),
                backgroundColor: const Color(0xff1a1a2e),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 1.0,
                  verticalInterval: 1.0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xff37434d),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: const Color(0xff37434d),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d)),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: intervalY.toDouble(),
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}d',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt() + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: LinearGradient(colors: gradientColors),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}
