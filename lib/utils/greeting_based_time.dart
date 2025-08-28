class GreetingBasedTime {
  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 6) {
      return "Good Night";
    } else if (hour >= 6 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }
}
