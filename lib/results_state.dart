import 'package:equatable/equatable.dart';

import 'results_model.dart';

class ResultState extends Equatable {
  final int page;
  List<Results> results;
  final bool? isLoading;
  final bool? isLoadMoreError;
  final bool? isLoadMoreDone;

  ResultState({
    required this.page,
    required this.results,
    this.isLoading,
    this.isLoadMoreDone,
    this.isLoadMoreError,
  });

  factory ResultState.initial() {
    return ResultState(
      page: 1,
      results: [],
      isLoading: true,
      isLoadMoreDone: false,
      isLoadMoreError: false,
    );
  }

  @override
  List<Object> get props => [
        page,
        results,
      ];

  ResultState copyWith({
    int? page,
    List<Results>? results,
    bool? isLoading,
    bool? isLoadMoreError,
    bool? isLoadMoreDone,
  }) {
    return ResultState(
      page: page ?? this.page,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      isLoadMoreError: isLoadMoreError ?? this.isLoadMoreError,
      isLoadMoreDone: isLoadMoreDone ?? this.isLoadMoreDone,
    );
  }
}
