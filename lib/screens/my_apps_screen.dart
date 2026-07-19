import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';
import 'add_app_screen.dart';
import 'app_analytics_screen.dart';
import '../widgets/premium_widgets.dart';

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
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: PremiumCardDecoration.outlineCard.copyWith(
                          // Colored left edge status indicator bar
                          border: Border(
                            left: BorderSide(color: statusColor, width: 5),
                            top: const BorderSide(color: Color(0xFFEFEFEF)),
                            right: const BorderSide(color: Color(0xFFEFEFEF)),
                            bottom: const BorderSide(color: Color(0xFFEFEFEF)),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // App Icon design
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: AppColors.primaryGradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      app.name.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          app.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          app.packageName,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                      ],
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
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              app.status == "Testing"
                                                  ? "Testing schedule: Day ${app.daysElapsed}/14"
                                                  : "Testers joined: ${app.testersCount}/12",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textDark,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Progress Bar
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: app.status == "Testing"
                                                    ? (app.daysElapsed / 14)
                                                    : (app.testersCount / 12),
                                                backgroundColor: const Color(0xFFE2E8F0),
                                                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                                minHeight: 6,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.buttonDark,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                                ],
                              ),
                            ),
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
                                            PremiumToast.show(context, "12 Testers recruited! Testing started.");
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
                                            PremiumToast.show(context, "Advanced simulation calendar by +1 day.");
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
                                            PremiumToast.show(context, "A tester left! Status changed to Recruiting (Paused).", isWarning: true);
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
