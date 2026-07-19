import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';

class AddAppScreen extends StatefulWidget {
  const AddAppScreen({super.key});

  @override
  State<AddAppScreen> createState() => _AddAppScreenState();
}

class _AddAppScreenState extends State<AddAppScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _packageController = TextEditingController();
  final _linkController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _packageController.dispose();
    _linkController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final hasEnoughCoins = appState.coins >= 100;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Add New App",
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Coin balance notice card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: hasEnoughCoins ? AppColors.accentBlue : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: hasEnoughCoins ? AppColors.primary.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            hasEnoughCoins ? Icons.info_outline : Icons.warning_amber_rounded,
                            color: hasEnoughCoins ? AppColors.primary : Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hasEnoughCoins ? "Registration Cost: 100 Coins" : "Insufficient Coins",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: hasEnoughCoins ? AppColors.primary : Colors.red.shade800,
                                  ),
                                ),
                                Text(
                                  hasEnoughCoins
                                      ? "Your current balance is 🪙 ${appState.coins}."
                                      : "You need 100 coins to register. Currently, you only have 🪙 ${appState.coins}.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: hasEnoughCoins ? AppColors.textDark : Colors.red.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Form fields
                    Text(
                      "App Name",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the app name';
                        }
                        return null;
                      },
                      decoration: _inputDecoration("e.g., Fitness Tracker Pro"),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Package Name (com.company.app)",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _packageController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter package name';
                        }
                        if (!RegExp(r'^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+[0-9a-z_]$').hasMatch(value.trim())) {
                          return 'Enter a valid Android package format';
                        }
                        return null;
                      },
                      decoration: _inputDecoration("e.g., com.questrax.ttester"),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Play Store Testing Link",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _linkController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter testing link';
                        }
                        if (!value.startsWith("http://") && !value.startsWith("https://")) {
                          return 'Must start with http:// or https://';
                        }
                        return null;
                      },
                      decoration: _inputDecoration("e.g., https://play.google.com/apps/testing/..."),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Short Description",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      decoration: _inputDecoration("Briefly describe what your app does and instructions for testers..."),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Payment Bar
          Container(
            padding: const EdgeInsets.only(top: 16, bottom: 32, left: 24, right: 24),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Total Cost", style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                    Text(
                      "🪙 100 Coins",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasEnoughCoins ? AppColors.buttonDark : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  ),
                  onPressed: hasEnoughCoins
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            final success = appState.addApp(
                              _nameController.text.trim(),
                              _packageController.text.trim(),
                              _linkController.text.trim(),
                              _descController.text.trim(),
                            );
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("App registered successfully! Recruiting testers now..."),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                        }
                      : null,
                  child: const Text("Submit & Pay"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
