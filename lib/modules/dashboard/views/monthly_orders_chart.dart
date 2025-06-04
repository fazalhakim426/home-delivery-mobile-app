import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthlyOrdersChart extends StatelessWidget {
  final List<int> orderCounts;
  final List<String> months;

  const MonthlyOrdersChart({
    Key? key,
    required this.orderCounts,
    required this.months,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double chartHeight = Get.height * 0.23;
    final double chartWidth = max(Get.width, months.length * 20.0);

    if (orderCounts.isEmpty) return SizedBox(height: chartHeight);

    final int maxValue = orderCounts.reduce(max);
    final double maxY = _calculateMaxY(maxValue);
    final double interval = _calculateInterval(maxY);

    return SizedBox(
      height: chartHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              maxY: maxY,
              minY: 0,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.3),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: interval,
                    getTitlesWidget: (value, meta) {
                      // Prevent duplicate top label
                      if (value == maxY && meta.appliedInterval == interval) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 42,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= months.length) {
                        return const SizedBox.shrink();
                      }
                      final label = months[index].split('-')[1];
                      return Transform.rotate(
                        angle: -0.5,
                        child: Text(label, style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(orderCounts.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: orderCounts[index].toDouble(),
                      color: Colors.blueAccent,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateMaxY(int maxValue) {
    if (maxValue == 0) return 10;
    if (maxValue < 10) return maxValue * 1.5;

    // Round up to next "nice" number
    final double step = maxValue < 50 ? 5 : 10;
    return (maxValue / step).ceil() * step * 1.05; // Slight padding
  }

  double _calculateInterval(double maxY) {
    if (maxY <= 12) return 2;
    if (maxY <= 30) return 5;
    if (maxY <= 50) return 10;
    return (maxY / 5).roundToDouble();
  }
}