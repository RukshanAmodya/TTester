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

    Color statusColor = Colors.orange;
    if (app.status == "Completed") {
      statusColor = Colors.green;
    } else if (app.status == "Recruiting") {
      statusColor = Colors.blue;
    }

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Campaign Analytics",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Board Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          app.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              app.packageName,
                              style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
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
                  const SizedBox(height: 24),
                  // Progress details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        app.status == "Recruiting"
                            ? "Tester Recruiting Progress"
                            : "Testing Duration Schedule",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        app.status == "Recruiting"
                            ? "${app.testersCount}/12 Testers"
                            : "Day ${app.daysElapsed}/14",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: app.status == "Completed"
                          ? 1.0
                          : (app.status == "Testing" ? app.daysElapsed / 14 : app.testersCount / 12),
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Tester Tracking Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tester Engagement Tracker",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${app.testers.length} joined",
                      style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (app.testers.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(28),
                decoration: PremiumCardDecoration.outlineCard,
                child: const Center(
                  child: Column(
                    children: [
                      Icon(Icons.people_outline_rounded, color: AppColors.textLight, size: 36),
                      SizedBox(height: 12),
                      Text(
                        "No testers joined yet. Recruiting in progress...",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textLight, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: app.testers.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final tester = app.testers[index];
                  final checkins = tester.checkinDays.where((day) => day).length;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: PremiumCardDecoration.outlineCard,
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        iconColor: AppColors.primary,
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
                            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                                const SizedBox(height: 4),
                                const Text(
                                  "14-Day Live Check-in Compliance Grid:",
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                ),
                                const SizedBox(height: 10),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    mainAxisSpacing: 6,
                                    crossAxisSpacing: 6,
                                  ),
                                  itemCount: 14,
                                  itemBuilder: (context, dIndex) {
                                    final didCheck = tester.checkinDays[dIndex];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: didCheck ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: didCheck ? const Color(0xFF10B981).withOpacity(0.3) : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: didCheck
                                          ? const Icon(Icons.check_rounded, color: Color(0xFF10B981), size: 12)
                                          : Text(
                                              "${dIndex + 1}",
                                              style: const TextStyle(
                                                color: AppColors.textLight,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            // Bug Reports section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Submitted Bug Reports & Feedback",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${app.bugReports.length} issues",
                      style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (app.bugReports.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(28),
                decoration: PremiumCardDecoration.outlineCard,
                child: const Center(
                  child: Column(
                    children: [
                      Icon(Icons.bug_report_outlined, color: Color(0xFF10B981), size: 36),
                      SizedBox(height: 12),
                      Text(
                        "Clean report! No bugs or negative feedback reported.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF047857), fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: app.bugReports.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final report = app.bugReports[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: PremiumCardDecoration.outlineCard.copyWith(
                      border: Border.all(color: const Color(0xFFFEE2E2), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEE2E2),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                report.testerName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.testerName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark),
                                  ),
                                  Text(
                                    "${report.date.day}/${report.date.month} ${report.date.hour}:${report.date.minute.toString().padLeft(2, '0')}",
                                    style: const TextStyle(color: AppColors.textLight, fontSize: 9),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 18),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFFEE2E2)),
                        const SizedBox(height: 12),
                        Text(
                          report.description,
                          style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
