extension DurationFormatter on int {
  String toFormattedDuration() {
    if (this <= 0) return "0min";

    final hours = this ~/ 60;
    final minutes = this % 60;

    if (hours == 0) return "${minutes}min";
    if (minutes == 0) return "${hours}h";

    final formattedMinutes = minutes.toString().padLeft(2, "0");
    return "${hours}h${formattedMinutes}min";
  }
}
