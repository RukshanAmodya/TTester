import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';

class AppAnalyticsScreen extends StatelessWidget {
  final String appId;
  const AppAnalyticsScreen({super.key, required this.appId});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final app = appState.allApps.firstWhere((a) => a.id == appId);

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "${app.name} Analytics",
          style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status overview card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(fontSize: 14, color: AppColors.textLight),
                      ),
                      Text(
                        app.status,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: app.status == "Testing" ? Colors.orange : (app.status == "Completed" ? Colors.green : Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: app.status == "Completed"
                        ? 1.0
                        : (app.status == "Testing" ? app.daysElapsed / 14 : 0.0),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        app.status == "Recruiting"
                            ? "Waiting for ${12 - app.testersCount} more testers to join"
                            : "Testing active for ${app.daysElapsed} of 14 days",
                        style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                      ),
                      Text(
                        app.status == "Recruiting"
                            ? "${app.testersCount}/12 Joined"
                            : "Day ${app.daysElapsed}/14",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Testers compliance tracker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Testers Tracker (${app.testers.length} Testers)",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: PremiumCardDecoration.outlineCard,
              child: app.testers.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          "No testers joined yet. Once testers join, their compliance checklist will show up here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textLight, fontSize: 13),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: app.testers.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final tester = app.testers[index];
                        // Calculate active check-ins
                        final checkins = tester.checkinDays.where((day) => day).length;
                        return ExpansionTile(
                          shape: const Border(),
                          collapsedShape: const Border(),
                          title: Text(
                            tester.testerName,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          subtitle: Text(
                            "${tester.testerEmail} • Active days: $checkins/14",
                            style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "14-Day Check-in Compliance Grid:",
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                    ),
                                    itemCount: 14,
                                    itemBuilder: (context, dIndex) {
                                      final didCheck = tester.checkinDays[dIndex];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: didCheck ? Colors.green.shade100 : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: didCheck ? Colors.green : Colors.grey.shade300,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${dIndex + 1}",
                                          style: TextStyle(
                                            color: didCheck ? Colors.green.shade900 : Colors.grey.shade600,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            // Bug Reports section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Bug Reports & Feedback (${app.bugReports.length})",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: PremiumCardDecoration.outlineCard,
              child: app.bugReports.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          "No bug reports received yet! Perfect status.",
                          style: TextStyle(color: AppColors.textLight, fontSize: 13),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: app.bugReports.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final report = app.bugReports[index];
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    report.testerName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    "${report.date.day}/${report.date.month} ${report.date.hour}:${report.date.minute.toString().padLeft(2, '0')}",
                                    style: const TextStyle(color: AppColors.textLight, fontSize: 10),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                report.description,
                                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
