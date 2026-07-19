import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';

class CoinStoreScreen extends StatelessWidget {
  const CoinStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    final List<Map<String, dynamic>> coinPacks = [
      {"coins": 500, "price": 4.99, "badge": "Popular"},
      {"coins": 1200, "price": 9.99, "badge": "Best Value"},
      {"coins": 3000, "price": 19.99, "badge": "Dev Choice"},
    ];

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Coin Store",
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
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
            // Current Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: PremiumCardDecoration.gradientHeader.copyWith(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Balance",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "🪙 ${appState.coins} Coins",
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Icon(Icons.stars_rounded, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Select Coin Package",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              "Too busy to test others' apps? Purchase coin packs to recruit testers instantly.",
              style: TextStyle(color: AppColors.textLight, fontSize: 12),
            ),
            const SizedBox(height: 16),
            // Packs list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coinPacks.length,
              itemBuilder: (context, index) {
                final pack = coinPacks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: PremiumCardDecoration.outlineCard,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "🪙 ${pack['coins']} Coins",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentOrange,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  pack['badge'],
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Instant delivery to your wallet",
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () {
                          _launchPaymentGateway(context, appState, pack['coins'], pack['price']);
                        },
                        child: Text(
                          "\$${pack['price']}",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _launchPaymentGateway(BuildContext context, AppState state, int coins, double price) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Secure Checkout",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              "Purchasing ${coins} Coins for \$${price}",
              style: const TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
            const Divider(height: 32),
            // Payment fields simulation
            const Row(
              children: [
                Icon(Icons.payment, color: AppColors.primary),
                SizedBox(width: 12),
                Text(
                  "Visa / MasterCard / Stripe Launcher",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: "•••• •••• •••• 4242",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  state.buyCoins(coins, price);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Payment successful! Added 🪙 $coins Coins to your wallet."),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text("Pay & Credit Coins"),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
