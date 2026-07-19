import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';

class TestingDetailScreen extends StatefulWidget {
  final String appId;
  const TestingDetailScreen({super.key, required this.appId});

  @override
  State<TestingDetailScreen> createState() => _TestingDetailScreenState();
}

class _TestingDetailScreenState extends State<TestingDetailScreen> {
  final _bugController = TextEditingController();
  bool _isChecking = false;

  @override
  void dispose() {
    _bugController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final app = appState.allApps.firstWhere((a) => a.id == widget.appId);
    
    // Find current user's progress
    final testerProgress = app.testers.firstWhere(
      (t) => t.testerEmail == appState.userEmail,
      orElse: () => TesterProgress(testerName: appState.userName, testerEmail: appState.userEmail, checkinDays: List.generate(14, (_) => false)),
    );

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          app.name,
          style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: PremiumCardDecoration.gradientHeader.copyWith(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          app.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
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
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              app.packageName,
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    app.description,
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Play Store Redirect Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  // Simulate opening URL
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Launching Play Store"),
                      content: Text("Redirecting you to play console testing channel: \n\n${app.playStoreLink}"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text("Open App in Play Store"),
              ),
            ),
            const SizedBox(height: 16),
            // Check-in Verification Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: PremiumCardDecoration.outlineCard,
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified_user_rounded, color: AppColors.primary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Verify Package & Daily Check-in",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Background service checks if target package is currently active on your phone before approving check-in.",
                    style: TextStyle(color: AppColors.textLight, fontSize: 11),
                  ),
                  const SizedBox(height: 16),
                  _isChecking
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              setState(() {
                                _isChecking = true;
                              });
                              // Simulate check duration
                              await Future.delayed(const Duration(seconds: 1));
                              setState(() {
                                _isChecking = false;
                              });
                              
                              final success = appState.verifyAndCheckInApp(app.id);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Package verified successfully! Checked-in and rewarded 🪙 5 coins for testing ${app.name} today."),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Verify failed. Either package not found, or you already checked in today."),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                            child: const Text("Verify & Check-in"),
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 14 Days Live Calendar Grid
            Text(
              "Testing Schedule (Day ${app.daysElapsed}/14)",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: PremiumCardDecoration.outlineCard,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 14,
                itemBuilder: (context, index) {
                  final isChecked = testerProgress.checkinDays[index];
                  final isCurrentActiveDay = app.daysElapsed == index + 1;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: isChecked
                          ? Colors.green
                          : (isCurrentActiveDay ? AppColors.accentBlue : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCurrentActiveDay ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isChecked
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: isCurrentActiveDay ? AppColors.primary : Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Bug Report Submission
            Text(
              "Private Feedback / Bug Report",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              "Send private logs/issues directly to developer. Avoid writing low ratings on the Play Store.",
              style: TextStyle(color: AppColors.textLight, fontSize: 11),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bugController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter bug description, reproduction steps...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_bugController.text.trim().isEmpty) return;
                  appState.submitBugReport(app.id, _bugController.text.trim());
                  _bugController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Feedback submitted successfully. Thank you!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text("Submit Report"),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
