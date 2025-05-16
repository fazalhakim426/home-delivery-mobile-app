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

    return SizedBox(
      height: chartHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              maxY: (orderCounts.reduce(max) * 1.2).toDouble(),
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    reservedSize: 32,
                    getTitlesWidget: (value, _) {
                      return Text(value.toInt().toString(),
                          style: const TextStyle(fontSize: 10));
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
                      if (index < 0 || index >= months.length) return const SizedBox.shrink();

                      final label = months[index].split('-')[1]; // Just the month
                      return Transform.rotate(
                        angle: -0.5, // Rotate slightly for space
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
}
