import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final String title;
  final int totalOrders;
  final int unpaidOrders;
  final int completedOrders;
  final Color backgroundColor;
  final Color foregroundColor;

  const OrderSummaryCard({
    super.key,
    required this.title,
    required this.totalOrders,
    required this.unpaidOrders,
    required this.completedOrders,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Keeps the card compact
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.check_circle, color: foregroundColor, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            totalOrders.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: foregroundColor,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Unpaid", style: TextStyle(color: foregroundColor, fontSize: 12)),
              Text(unpaidOrders.toString(),
                  style: TextStyle(color: foregroundColor, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Completed", style: TextStyle(color: foregroundColor, fontSize: 12)),
              Text(completedOrders.toString(),
                  style: TextStyle(color: foregroundColor, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
