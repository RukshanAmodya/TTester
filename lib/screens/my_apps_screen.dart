import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';
import 'add_app_screen.dart';
import 'app_analytics_screen.dart';

class MyAppsScreen extends StatelessWidget {
  const MyAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final myApps = appState.myDeveloperApps;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Developer Panel",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
      ),
      body: myApps.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_queue_rounded, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      "No Registered Apps",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Register your Android app package details and deposit 100 coins to request 12 testers for 14 days.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textLight, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddAppScreen()),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add New App"),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "My Registered Apps",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: myApps.length,
                    itemBuilder: (context, index) {
                      final app = myApps[index];
                      Color statusColor = Colors.orange;
                      if (app.status == "Completed") {
                        statusColor = Colors.green;
                      } else if (app.status == "Recruiting") {
                        statusColor = Colors.blue;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: PremiumCardDecoration.outlineCard,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    app.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    app.status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Package: ${app.packageName}",
                              style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Testers Recruited: ${app.testersCount}/12",
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    if (app.status == "Testing")
                                      Text(
                                        "Testing Progress: Day ${app.daysElapsed}/14",
                                        style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                                      ),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonDark,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    minimumSize: Size.zero,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppAnalyticsScreen(appId: app.id),
                                      ),
                                    );
                                  },
                                  child: const Text("Analytics", style: TextStyle(fontSize: 11)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Quick Simulation Tools Section for testing the flow easily
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.terminal_rounded, size: 14, color: AppColors.textLight),
                                      SizedBox(width: 6),
                                      Text(
                                        "Demo Flow Simulator",
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      if (app.status == "Recruiting")
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue.shade600,
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            minimumSize: Size.zero,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          onPressed: () {
                                            appState.simulateTesterJoining(app.id);
                                          },
                                          child: const Text("Simulate 12 Testers Joined", style: TextStyle(fontSize: 10, color: Colors.white)),
                                        ),
                                      if (app.status == "Testing") ...[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange.shade700,
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            minimumSize: Size.zero,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          onPressed: () {
                                            appState.simulateTestingDays(app.id);
                                          },
                                          child: const Text("Simulate +1 Day Progress", style: TextStyle(fontSize: 10, color: Colors.white)),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red.shade600,
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            minimumSize: Size.zero,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          onPressed: () {
                                            appState.simulateTesterLeaving(app.id);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("A tester left! Status changed to Recruiting (Paused)."),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                          child: const Text("Simulate Tester Leaving (Pause)", style: TextStyle(fontSize: 10, color: Colors.white)),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAppScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
