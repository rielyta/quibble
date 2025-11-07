class LevelSystem {
  static const List<LevelData> levels = [
    LevelData(level: 1, title: "Beginner", minXP: 0, maxXP: 100, color: 0xFF8F9ABA),
    LevelData(level: 2, title: "Learner", minXP: 100, maxXP: 250, color: 0xFF59A855),
    LevelData(level: 3, title: "Student", minXP: 250, maxXP: 450, color: 0xFFFFB74D),
    LevelData(level: 4, title: "Scholar", minXP: 450, maxXP: 700, color: 0xFFEE7C9E),
    LevelData(level: 5, title: "Expert", minXP: 700, maxXP: 1000, color: 0xFFB65E6A),
    LevelData(level: 6, title: "Master", minXP: 1000, maxXP: 1400, color: 0xFF9C27B0),
    LevelData(level: 7, title: "Sage", minXP: 1400, maxXP: 1900, color: 0xFF7B1FA2),
    LevelData(level: 8, title: "Legend", minXP: 1900, maxXP: 2500, color: 0xFFFF6F00),
    LevelData(level: 9, title: "Champion", minXP: 2500, maxXP: 3300, color: 0xFFD84315),
    LevelData(level: 10, title: "Bible Master", minXP: 3300, maxXP: 9999999, color: 0xFFFFD700),
  ];


  static LevelData getCurrentLevel(int totalXP) {
    for (int i = levels.length - 1; i >= 0; i--) {
      if (totalXP >= levels[i].minXP) {
        return levels[i];
      }
    }
    return levels[0];
  }


  static int getXPToNextLevel(int totalXP) {
    final currentLevel = getCurrentLevel(totalXP);
    if (currentLevel.level == levels.last.level) {
      return 0;
    }
    return currentLevel.maxXP - totalXP;
  }


  static double getProgressToNextLevel(int totalXP) {
    final currentLevel = getCurrentLevel(totalXP);
    if (currentLevel.level == levels.last.level) {
      return 1.0; // Max level
    }

    final xpInCurrentLevel = totalXP - currentLevel.minXP;
    final xpNeededForLevel = currentLevel.maxXP - currentLevel.minXP;

    return (xpInCurrentLevel / xpNeededForLevel).clamp(0.0, 1.0);
  }


  static LevelData? getNextLevel(int totalXP) {
    final currentLevel = getCurrentLevel(totalXP);
    if (currentLevel.level == levels.last.level) {
      return null; // Already at max level
    }

    final nextLevelIndex = levels.indexWhere((l) => l.level == currentLevel.level) + 1;
    return levels[nextLevelIndex];
  }


  static bool checkLevelUp(int oldXP, int newXP) {
    final oldLevel = getCurrentLevel(oldXP);
    final newLevel = getCurrentLevel(newXP);
    return newLevel.level > oldLevel.level;
  }
}

class LevelData {
  final int level;
  final String title;
  final int minXP;
  final int maxXP;
  final int color;

  const LevelData({
    required this.level,
    required this.title,
    required this.minXP,
    required this.maxXP,
    required this.color,
  });


  int get xpRequired => maxXP - minXP;
}