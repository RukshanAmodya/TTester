import 'package:flutter_test/flutter_test.dart';
import 'package:ttesters/app_state.dart';

void main() {
  group('AppState Tests', () {
    test('Initial state parameters', () {
      final state = AppState();
      expect(state.isLoggedIn, false);
      expect(state.coins, 0);
      expect(state.dailyStreak, 0);
    });

    test('Google Login and Welcome Bonus', () {
      final state = AppState();
      state.loginWithGoogle();
      expect(state.isLoggedIn, true);
      expect(state.coins, 150);
      expect(state.userName, "Willie Schulist");
    });

    test('Daily Checkin rewards coins', () {
      final state = AppState();
      state.loginWithGoogle(); // Starts with 50 coins, day 1 checked-in
      
      // Try to check in again on same day
      final checkinSuccess = state.checkInDaily();
      expect(checkinSuccess, false); // Already checked in today on login
    });
  });
}
