import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simpl/modules/tracking/controllers/tracking_controller.dart';
class TrackingView extends GetView<TrackingController> {
  const TrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Tracking Info")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: 'Enter Tracking Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final code = codeController.text.trim();
                    if (code.isNotEmpty) {
                      controller.fetchTracking(code);
                    } else {
                      Get.snackbar("Error", "Please enter a tracking code.");
                    }
                  },
                  child: Text("Search"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final trackingData = controller.tracking.value;

              if (trackingData == null ||
                  trackingData.data.hdTrackings.isEmpty) {
                return const Center(child: Text("No tracking found"));
              }

              return ListView.builder(
                itemCount: trackingData.data.hdTrackings.length,
                itemBuilder: (context, index) {
                  final track = trackingData.data.hdTrackings[index];

                  return ListTile(
                    title: Text(track.description),
                    subtitle: Text(
                      "${track.city}, ${track.state} • ${DateFormat.yMd().add_jm().format(track.createdAt)}",
                    ),
                    trailing: Text(track.statusCode),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}