String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return "صباح الخير 👋";
  } else {

    return "مساء الخير 👋";
  }
}
