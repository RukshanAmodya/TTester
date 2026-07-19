import 'package:flutter/material.dart';

class TesterProgress {
  final String testerName;
  final String testerEmail;
  final List<bool> checkinDays; // Length 14

  TesterProgress({
    required this.testerName,
    required this.testerEmail,
    required this.checkinDays,
  });
}

class BugReport {
  final String testerName;
  final String description;
  final DateTime date;

  BugReport({
    required this.testerName,
    required this.description,
    required this.date,
  });
}

class AppModel {
  final String id;
  final String name;
  final String packageName;
  final String playStoreLink;
  final String description;
  final String developerName;
  final String developerEmail;
  String status; // 'Recruiting', 'Testing', 'Completed'
  int testersCount;
  int daysElapsed;
  final List<TesterProgress> testers;
  final List<BugReport> bugReports;

  AppModel({
    required this.id,
    required this.name,
    required this.packageName,
    required this.playStoreLink,
    required this.description,
    required this.developerName,
    required this.developerEmail,
    this.status = 'Recruiting',
    this.testersCount = 0,
    this.daysElapsed = 0,
    required this.testers,
    required this.bugReports,
  });

  bool get isJoinedByCurrentUser => testers.any((t) => t.testerEmail == "current_user@gmail.com");
}

class CoinTransaction {
  final String title;
  final int coins;
  final DateTime date;
  final bool isCredit;

  CoinTransaction({
    required this.title,
    required this.coins,
    required this.date,
    required this.isCredit,
  });
}

class AppState extends ChangeNotifier {
  // Auth State
  bool _isLoggedIn = false;
  String _userName = "Guest User";
  String _userEmail = "";
  int _coins = 0;
  
  // Daily Streak
  int _dailyStreak = 0;
  List<bool> _attendanceList = List.generate(14, (index) => false);
  DateTime? _lastCheckIn;

  // Apps Databases
  final List<AppModel> _allApps = [];
  final List<CoinTransaction> _transactions = [];

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  int get coins => _coins;
  int get dailyStreak => _dailyStreak;
  List<bool> get attendanceList => _attendanceList;
  List<AppModel> get allApps => _allApps;
  List<CoinTransaction> get transactions => _transactions;

  // Filter lists
  List<AppModel> get availableApps => _allApps
      .where((app) => app.developerEmail != _userEmail && app.status == 'Recruiting')
      .toList();

  List<AppModel> get myTestingApps => _allApps
      .where((app) => app.testers.any((t) => t.testerEmail == _userEmail))
      .toList();

  List<AppModel> get myDeveloperApps => _allApps
      .where((app) => app.developerEmail == _userEmail)
      .toList();

  AppState() {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Populate with some dummy apps
    _allApps.addAll([
      AppModel(
        id: "1",
        name: "Fitness Tracker Pro",
        packageName: "com.fitpro.tracker",
        playStoreLink: "https://play.google.com/store/apps/details?id=com.fitpro.tracker",
        description: "A tracking application for gym enthusiasts.",
        developerName: "Janith Silva",
        developerEmail: "janith@gmail.com",
        status: "Recruiting",
        testersCount: 8,
        testers: List.generate(8, (i) => TesterProgress(
          testerName: "Tester $i",
          testerEmail: "tester$i@gmail.com",
          checkinDays: List.generate(14, (d) => d < 3),
        )),
        bugReports: [],
      ),
      AppModel(
        id: "2",
        name: "Grocery Shop App",
        packageName: "com.grocerystore.app",
        playStoreLink: "https://play.google.com/store/apps/details?id=com.grocerystore.app",
        description: "Direct order and home delivery for fresh greens.",
        developerName: "Priyantha Perera",
        developerEmail: "priyantha@gmail.com",
        status: "Testing",
        testersCount: 12,
        daysElapsed: 6,
        testers: List.generate(12, (i) => TesterProgress(
          testerName: "Tester $i",
          testerEmail: "tester$i@gmail.com",
          checkinDays: List.generate(14, (d) => d < 6),
        )),
        bugReports: [
          BugReport(testerName: "Tester 2", description: "App crashes when clicking Checkout", date: DateTime.now().subtract(const Duration(days: 2))),
          BugReport(testerName: "Tester 5", description: "Visual issue with dark mode theme", date: DateTime.now().subtract(const Duration(days: 1))),
        ],
      ),
      AppModel(
        id: "3",
        name: "Quick Invoice PDF",
        packageName: "com.questrax.invoicepdf",
        playStoreLink: "https://play.google.com/store/apps/details?id=com.questrax.invoicepdf",
        description: "Instantly create invoices on the go.",
        developerName: "Ruwan Fernando",
        developerEmail: "ruwan@gmail.com",
        status: "Completed",
        testersCount: 12,
        daysElapsed: 14,
        testers: List.generate(12, (i) => TesterProgress(
          testerName: "Tester $i",
          testerEmail: "tester$i@gmail.com",
          checkinDays: List.generate(14, (d) => true),
        )),
        bugReports: [],
      ),
    ]);
  }

  // Auth Operations
  void loginWithGoogle() {
    _isLoggedIn = true;
    _userName = "Willie Schulist";
    _userEmail = "current_user@gmail.com";
    _coins = 50; // Welcome bonus
    _dailyStreak = 1;
    _attendanceList[0] = true;
    _lastCheckIn = DateTime.now();

    _transactions.add(CoinTransaction(
      title: "Welcome Bonus",
      coins: 50,
      date: DateTime.now(),
      isCredit: true,
    ));

    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = "Guest User";
    _userEmail = "";
    _coins = 0;
    _dailyStreak = 0;
    _attendanceList = List.generate(14, (index) => false);
    _lastCheckIn = null;
    notifyListeners();
  }

  // Daily Streak Check-in
  bool checkInDaily() {
    final now = DateTime.now();
    if (_lastCheckIn != null && 
        _lastCheckIn!.year == now.year && 
        _lastCheckIn!.month == now.month && 
        _lastCheckIn!.day == now.day) {
      return false; // Already checked in today
    }
    
    _dailyStreak = (_dailyStreak % 14) + 1;
    _attendanceList[_dailyStreak - 1] = true;
    _lastCheckIn = now;
    
    // Reward coins
    int reward = 5;
    if (_dailyStreak == 14) {
      reward = 50; // Bonus for completing streak
    }
    
    _coins += reward;
    _transactions.add(CoinTransaction(
      title: "Daily Attendance (Day $_dailyStreak)",
      coins: reward,
      date: now,
      isCredit: true,
    ));
    notifyListeners();
    return true;
  }

  // Coin Purchase
  void buyCoins(int amount, double price) {
    _coins += amount;
    _transactions.add(CoinTransaction(
      title: "Purchased $amount Coins Pack",
      coins: amount,
      date: DateTime.now(),
      isCredit: true,
    ));
    notifyListeners();
  }

  // Add Developer's App
  bool addApp(String name, String packageName, String playStoreLink, String description) {
    if (_coins < 100) return false;

    _coins -= 100;
    _transactions.add(CoinTransaction(
      title: "Registered App: $name",
      coins: 100,
      date: DateTime.now(),
      isCredit: false,
    ));

    final newApp = AppModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      packageName: packageName,
      playStoreLink: playStoreLink,
      description: description,
      developerName: _userName,
      developerEmail: _userEmail,
      status: "Recruiting",
      testersCount: 0,
      testers: [],
      bugReports: [],
    );

    _allApps.add(newApp);
    notifyListeners();
    return true;
  }

  // Tester Joins an App
  void joinTest(String appId) {
    final appIndex = _allApps.indexWhere((a) => a.id == appId);
    if (appIndex == -1) return;

    final app = _allApps[appIndex];
    if (app.testers.any((t) => t.testerEmail == _userEmail)) return;

    app.testers.add(TesterProgress(
      testerName: _userName,
      testerEmail: _userEmail,
      checkinDays: List.generate(14, (_) => false),
    ));
    app.testersCount = app.testers.length;

    // Check if the threshold of 12 testers is reached
    if (app.testersCount >= 12) {
      app.status = "Testing";
      app.daysElapsed = 1;
      // Mark initial day checkin for other testers
      for (var tester in app.testers) {
        tester.checkinDays[0] = true;
      }
    }

    notifyListeners();
  }

  // Verification & Daily check-in for an App
  bool verifyAndCheckInApp(String appId) {
    final app = _allApps.firstWhere((a) => a.id == appId);
    final tester = app.testers.firstWhere((t) => t.testerEmail == _userEmail);
    
    // Check if already checked in for the current day
    int currentDayIndex = app.daysElapsed > 0 ? app.daysElapsed - 1 : 0;
    if (tester.checkinDays[currentDayIndex]) {
      return false; 
    }

    tester.checkinDays[currentDayIndex] = true;
    _coins += 5; // Reward for checking in
    _transactions.add(CoinTransaction(
      title: "Tested App Check-in: ${app.name}",
      coins: 5,
      date: DateTime.now(),
      isCredit: true,
    ));

    notifyListeners();
    return true;
  }

  // Developer submits feedback/bug report for a tester app
  void submitBugReport(String appId, String description) {
    final app = _allApps.firstWhere((a) => a.id == appId);
    app.bugReports.add(BugReport(
      testerName: _userName,
      description: description,
      date: DateTime.now(),
    ));
    notifyListeners();
  }

  // Developer Simulation Helpers
  void simulateTesterJoining(String appId) {
    final app = _allApps.firstWhere((a) => a.id == appId);
    if (app.status != "Recruiting") return;

    int currentCount = app.testers.length;
    int needed = 12 - currentCount;
    if (needed > 0) {
      for (int i = 0; i < needed; i++) {
        app.testers.add(TesterProgress(
          testerName: "Auto Tester ${currentCount + i + 1}",
          testerEmail: "autotester${currentCount + i + 1}@testing.com",
          checkinDays: List.generate(14, (d) => false),
        ));
      }
      app.testersCount = 12;
      app.status = "Testing";
      app.daysElapsed = 1;
      // Mark day 1 checked in for all simulated testers
      for (var tester in app.testers) {
        tester.checkinDays[0] = true;
      }
    }
    notifyListeners();
  }

  void simulateTestingDays(String appId) {
    final app = _allApps.firstWhere((a) => a.id == appId);
    if (app.status != "Testing") return;

    if (app.daysElapsed < 14) {
      app.daysElapsed += 1;
      // Simulating daily attendance checkmarks for testers
      for (var tester in app.testers) {
        if (tester.testerEmail != _userEmail) {
          tester.checkinDays[app.daysElapsed - 1] = true;
        }
      }
    } else {
      app.status = "Completed";
    }
    notifyListeners();
  }

  void simulateTesterLeaving(String appId) {
    final app = _allApps.firstWhere((a) => a.id == appId);
    if (app.status != "Testing") return;

    // Remove one tester that is not the user
    final nonUserTesterIndex = app.testers.indexWhere((t) => t.testerEmail != _userEmail);
    if (nonUserTesterIndex != -1) {
      app.testers.removeAt(nonUserTesterIndex);
      app.testersCount = app.testers.length;
      app.status = "Recruiting"; // Paused, back to Recruiting
    }
    notifyListeners();
  }
}
