int calculateReadingTime(String text) {
  final wordCount = text.split(RegExp(r'\s+')).length;
  final time = (wordCount / 200).ceil();
  return time;
}
