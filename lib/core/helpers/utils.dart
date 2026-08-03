class Utils {
  static List<T> getRandomElements<T>(List<T> list, int count) {
    // 1. Copy the list to avoid modifying the original data
    final copy = List<T>.from(list)
      // 2. Randomly shuffle the copy
      ..shuffle();

    // 3. Take the requested number of elements
    return copy.take(count).toList();
  }
}
