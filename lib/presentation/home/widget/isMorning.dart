String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return "Good Morning 👋";
  } else {
    return "Good Evening 👋";
  }
}
