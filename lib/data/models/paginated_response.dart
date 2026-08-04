class PaginatedResponse<T> {
  const PaginatedResponse({required this.data, required this.meta});

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemParser,
  ) {
    final raw = json["data"] as List<dynamic>;
    return PaginatedResponse(
      data: raw.map((e) => itemParser(e as Map<String, dynamic>)).toList(),
      meta: PaginationMeta.fromJson(json["meta"] as Map<String, dynamic>),
    );
  }

  final List<T> data;
  final PaginationMeta meta;
}

class PaginationMeta {
  const PaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json["current_page"] as int,
      perPage: json["per_page"] as int,
      total: json["total"] as int,
      lastPage: json["last_page"] as int,
    );
  }

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  bool get hasNextPage => currentPage < lastPage;
}
