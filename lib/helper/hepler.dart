class Helper {
  String convertToAgo(String input) {
    final DateTime time1 = DateTime.parse("$input 00:00:00Z");
    final Duration diff = DateTime.now().difference(time1);

    if (diff.inDays >= 1) {
      return 'about ${diff.inDays} days ago';
    } else if (diff.inHours >= 1) {
      return 'about ${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 1) {
      return 'about ${diff.inMinutes} minutes ago';
    } else if (diff.inSeconds >= 1) {
      return 'about ${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }
}
