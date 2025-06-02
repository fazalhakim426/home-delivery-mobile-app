import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/widgets/app_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:home_delivery_br/modules/tracking/controllers/tracking_controller.dart';

class TrackingView extends GetView<TrackingController> {
  const TrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // Search Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Track Your Package",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: codeController,
                            decoration: InputDecoration(
                              hintText: 'Enter tracking number',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              final code = codeController.text.trim();
                              if (code.isNotEmpty) {
                                controller.fetchTracking(code);
                              } else {
                                Get.snackbar(
                                  "Missing Information",
                                  "Please enter a tracking code",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: theme.colorScheme.error,
                                  colorText: theme.colorScheme.onError,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text("Track"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Results Section
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Fetching tracking information..."),
                      ],
                    ),
                  );
                }

                final trackingData = controller.tracking.value;

                if (trackingData == null ||
                    trackingData.data.hdTrackings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 64,
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No tracking information found",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        if (codeController.text.isEmpty)
                          Text(
                            "Enter a tracking number to begin",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                      ],
                    ),
                  );
                }return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Tracking History",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: trackingData.data.hdTrackings.length,
                          itemBuilder: (context, index) {
                            final track = trackingData.data.hdTrackings[index];
                            final isLast = index == trackingData.data.hdTrackings.length - 1;

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Status indicator column
                                      SizedBox(
                                        width: 40,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // if (index > 0)
                                            //   Container(
                                            //     width: 2,
                                            //     height: 16,
                                            //     color: _getStatusColor(trackingData.data.hdTrackings[index-1].statusCode),
                                            //   ),
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(track.statusCode),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                _getStatusIcon(track.statusCode),
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                            if (!isLast)
                                              Container(
                                                width: 2,
                                                height: 40,
                                                color: _getStatusColor(track.statusCode),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Tracking details - now in a Flexible widget to share space with status
                                      Flexible(
                                        flex: 3, // Takes 3 parts of available space
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        track.description,
                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "${track.city}, ${track.state}",
                                                        style: theme.textTheme.bodySmall,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.of(context).size.width * 0.3, // Limit width
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(track.statusCode)
                                                        .withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: _getStatusColor(track.statusCode)
                                                          .withOpacity(0.3),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    track.statusCode.toUpperCase(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: theme.textTheme.labelSmall?.copyWith(
                                                      color: _getStatusColor(track.statusCode),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              DateFormat.yMMMd()
                                                  .add_jm()
                                                  .format(track.createdAt),
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.onSurface
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isLast) const Divider(height: 1, indent: 56),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String statusCode) {
    switch (statusCode.toLowerCase()) {
      case '70':
        return Colors.green;
      case '73':
        return Colors.blue;
      case '75':
        return Colors.orange;
      case '80':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String statusCode) {
    switch (statusCode.toLowerCase()) {
      case '70':
        return Icons.check;
      case '73':
        return Icons.local_shipping;
      case '75':
        return Icons.warning;
      case '80':
        return Icons.assignment_return;
      default:
        return Icons.circle;
    }
  }
}