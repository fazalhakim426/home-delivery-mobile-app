import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/Dashboard.dart';
import 'package:home_delivery_br/modules/dashboard/views/monthly_orders_chart.dart';
import 'package:home_delivery_br/widgets/app_scaffold.dart';
import '../controllers/dashboard_controller.dart';
import 'order_summary_card.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();

  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            final dashboard = controller.dashboard.value;

            return controller.isLoading.value && dashboard == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Statistics',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  /// 🔹 Date Filters
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: GestureDetector(
                  //         onTap: () => _selectDate(context, true),
                  //         child: Container(
                  //           padding: const EdgeInsets.all(12),
                  //           decoration: BoxDecoration(
                  //             border: Border.all(color: Colors.grey),
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //           child: Text(
                  //             'Start: ${DateFormat('yyyy-MM-dd').format(controller.startDate.value)}',
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Expanded(
                  //       child: GestureDetector(
                  //         onTap: () => _selectDate(context, false),
                  //         child: Container(
                  //           padding: const EdgeInsets.all(12),
                  //           decoration: BoxDecoration(
                  //             border: Border.all(color: Colors.grey),
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //           child: Text(
                  //             'End: ${DateFormat('yyyy-MM-dd').format(controller.endDate.value)}',
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     IconButton(
                  //       onPressed: () => controller.fetchDashboard(),
                  //       icon: const Icon(Icons.refresh),
                  //     ),
                  //   ],
                  // ),

                  const SizedBox(height: 20),

                  if (dashboard != null) ...[
                    buildOrderSummaryTabs(context, dashboard),
                    const SizedBox(height: 20),
                    buildMonthlyOrderChart(dashboard, controller),
                    const SizedBox(height: 20),
                    buildDonutChart(context, dashboard),
                    const SizedBox(height: 20), // Extra space at bottom for better scrolling
                  ] else
                    const Center(child: Text("No data available")),
                ],
              )
            );
          }),
        ),
      ),
    );
  }
  Widget buildDonutChart(BuildContext context, Dashboard dashboard) {
    // Extract the doughnut data
    final doughnutData = dashboard.doughnutData;

    // Calculate total for percentage calculations
    final total = doughnutData.fold<double>(
      0,
      (sum, item) =>
          sum +
          (item.value is String
              ? double.tryParse(item.value) ?? 0
              : (item.value as num).toDouble()),
    );

    // Prepare chart data
    List<PieChartSectionData> sections =
        doughnutData.map((data) {
          final value =
              data.value is String
                  ? double.tryParse(data.value) ?? 0
                  : (data.value as num).toDouble();
          final percentage = (value / total * 100).toStringAsFixed(1);

          return PieChartSectionData(
            color: _getColorForCategory(data.x),
            value: value,
            title: '$percentage%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 250,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 50,
          sectionsSpace: 2,
          startDegreeOffset: -90,
          pieTouchData: PieTouchData(
            touchCallback: (
              FlTouchEvent event,
              PieTouchResponse? touchResponse,
            ) {
              // Handle touch events if needed
            },
          ),
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'shipped':
        return Colors.blue;
      case 'done':
        return Colors.green;
      case 'refund/cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildOrderSummaryTabs(BuildContext context, Dashboard dashboard) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(text: 'DAY'),
              Tab(text: 'MONTH'),
              Tab(text: 'YEAR'),
              Tab(text: 'TOTAL'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: TabBarView(
              children: [
                buildOrderCard(
                  title: "Today's Orders",
                  total: dashboard.currentDayTotal,
                  completed: dashboard.currentDayConfirm,
                  bgColor: Colors.blue.shade400,
                ),
                buildOrderCard(
                  title: "This Month Orders",
                  total: dashboard.currentMonthTotal,
                  completed: dashboard.currentMonthConfirm,
                  bgColor: Colors.pink.shade400,
                ),
                buildOrderCard(
                  title: "This Year Orders",
                  total: dashboard.currentYearTotal,
                  completed: dashboard.currentYearConfirm,
                  bgColor: Colors.orange.shade400,
                ),
                buildOrderCard(
                  title: "Overall Orders",
                  total: dashboard.totalOrders,
                  completed:dashboard.totalCompleteOrders,
                  bgColor: Colors.green.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderCard({
    required String title,
    required int total,
    required int completed,
    required Color bgColor,
  }) {
    return OrderSummaryCard(
      title: title,
      totalOrders: total,
      unpaidOrders: total - completed,
      completedOrders: completed,
      backgroundColor: bgColor,
      foregroundColor: Colors.white,
    );
  }

  Widget buildMonthlyOrderChart(
    Dashboard? dashboard,
    DashboardController controller,
  ) {
    if (dashboard != null) {
      return MonthlyOrdersChart(
        orderCounts: dashboard.totalOrderCount,
        months: dashboard.months,
      );
    } else if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return const Center(child: Text("No data available"));
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final controller = Get.find<DashboardController>();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          isStart ? controller.startDate.value : controller.endDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      if (isStart) {
        controller.startDate.value = pickedDate;
      } else {
        controller.endDate.value = pickedDate;
      }
    }
  }
}
