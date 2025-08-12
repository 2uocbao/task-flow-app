class ResponseList<T> {
  List<T>? data;
  int? status;
  Pagination? pagination;
  Sort? sort;

  ResponseList({this.data, this.status, this.pagination, this.sort});

  ResponseList.fromJson(Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonData) {
    if (json['data'] != null) {
      data = <T>[];
      json['data'].forEach((value) {
        data?.add(fromJsonData(value));
      });
      status = json['status'];
      pagination = json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null;
      sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    }
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? totalItems;
  int? totalPages;

  Pagination(
      {this.currentPage, this.perPage, this.totalItems, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    totalItems = json['total_items'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (currentPage != null) {
      data['current_page'] = currentPage;
    }
    if (perPage != null) {
      data['per_page'] = perPage;
    }
    if (totalItems != null) {
      data['total_items'] = totalItems;
    }
    if (totalPages != null) {
      data['total_pages'] = totalPages;
    }
    return data;
  }
}

class Sort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  Sort({this.sorted, this.unsorted, this.empty});

  Sort.fromJson(Map<String, dynamic> json) {
    sorted = json['sorted'];
    unsorted = json['unsorted'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (sorted != null) {
      data['sorted'] = sorted;
    }
    if (unsorted != null) {
      data['unsorted'] = unsorted;
    }
    if (empty != null) {
      data['empty'] = empty;
    }
    return data;
  }
}
