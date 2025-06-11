import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/widgets/app_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:home_delivery_br/modules/tracking/controllers/tracking_controller.dart';

import '../../../data/models/tracking_model.dart';

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
                          child: Builder(
                            builder: (context) => ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
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
                        )
                        ,
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
                    (trackingData.data.hdTrackings.isEmpty && trackingData.data.apiTrackings.isEmpty)) {
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
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HD Tracking Section
                      if (trackingData.data.hdTrackings.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "HD Tracking History",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _buildHdTrackingList(trackingData.data.hdTrackings, theme),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // API Tracking Section
                      if (trackingData.data.apiTrackings.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Carrier Tracking History",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _buildApiTrackingList(trackingData.data.apiTrackings, theme),
                        ),
                        const SizedBox(height: 50),

                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHdTrackingList(List<HdTracking> trackings, ThemeData theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: trackings.length,
      itemBuilder: (context, index) {
        final track = trackings[index];
        final isLast = index == trackings.length - 1;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _getApiStatusColor(track.statusCode),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getApiStatusIcon(track.statusCode),
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 40,
                            color: _getApiStatusColor(track.statusCode),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 3,
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
                                maxWidth: MediaQuery.of(context).size.width * 0.3,
                              ),
                              decoration: BoxDecoration(
                                color: _getApiStatusColor(track.statusCode)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getApiStatusColor(track.statusCode)
                                      .withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getApiStatusString(track.statusCode),
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _getApiStatusColor(track.statusCode),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.yMMMd().add_jm().format(track.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
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
    );
  }

  Widget _buildApiTrackingList(List<ApiTracking> trackings, ThemeData theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: trackings.length,
      itemBuilder: (context, index) {
        final track = trackings[index];
        final isLast = index == trackings.length - 1;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _getApiStatusColor(track.tipo),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getApiStatusIcon(track.tipo),
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 40,
                            color: _getApiStatusColor(track.tipo),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.descricao,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // if (track.descricao.isNotEmpty) ...[
                        //   const SizedBox(height: 4),
                        //   Text(
                        //     track.descricao,
                        //     style: theme.textTheme.bodySmall,
                        //   ),
                        // ],
                        const SizedBox(height: 4),
                        Text(
                          "${track.unidade.endereco.cidade}, ${track.unidade.endereco.uf}",
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.yMMMd().add_jm().format(track.dtHrCriado),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
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
    );
  }


  Color _getApiStatusColor(String statusCode) {
    switch (statusCode.toLowerCase()) {
      case '30':
        return Colors.teal; // Order Posted
      case '32':
        return Colors.amber; // Needs Processing
      case '35':
        return Colors.redAccent; // Cancelled
      case '38':
        return Colors.red; // Rejected
      case '40':
        return Colors.cyan; // Released
      case '50':
        return Colors.deepOrange; // Refunded
      case '60':
        return Colors.yellow; // Payment Pending
      case '70':
        return Colors.green; // Payment Done
      case '72':
        return Colors.indigo; // Driver Received
      case '73':
        return Colors.blue; // Arrived at Warehouse
      case '75':
        return Colors.orange; // Inside Container
      case '80':
        return Colors.purple; // Shipped
      default:
        return Colors.grey; // Unknown or unsupported status
    }
  }

  String _getApiStatusString(String statusCode) {
    switch (statusCode.toLowerCase()) {
      case '30':
        return 'Order Posted';
      case '32':
        return 'Needs Processing';
      case '35':
        return 'Cancelled';
      case '38':
        return 'Rejected';
      case '40':
        return 'Released';
      case '50':
        return 'Refunded';
      case '60':
        return 'Payment Pending';
      case '70':
        return 'Payment Done';
      case '72':
        return 'Driver Received';
      case '73':
        return 'Arrived at Warehouse';
      case '75':
        return 'Inside Container';
      case '80':
        return 'Shipped';
      default:
        return 'Status $statusCode';
    }
  }

  IconData _getApiStatusIcon(String statusCode) {
    switch (statusCode.toLowerCase()) {
      case '30':
        return Icons.post_add; // Order Posted
      case '32':
        return Icons.pending_actions; // Needs Processing
      case '35':
        return Icons.cancel; // Cancelled
      case '38':
        return Icons.block; // Rejected
      case '40':
        return Icons.outbox; // Released
      case '50':
        return Icons.reply; // Refunded
      case '60':
        return Icons.hourglass_bottom; // Payment Pending
      case '70':
        return Icons.check; // Payment Done
      case '72':
        return Icons.directions_car; // Driver Received
      case '73':
        return Icons.local_shipping; // Arrived at Warehouse
      case '75':
        return Icons.warning; // Inside Container
      case '80':
        return Icons.flight_takeoff; // Shipped
      default:
        return Icons.circle; // Unknown
    }
  }

}