import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loadmore/api.dart';
import 'package:loadmore/results_state.dart';

final resultVM = StateNotifierProvider.autoDispose<ResultVM, ResultState>(
  (ref) => ResultVM(),
);

class ResultVM extends StateNotifier<ResultState> {
  ResultVM() : super(ResultState.initial()) {
    _initData();
  }

  _initData([int? initPage]) async {
    final page = initPage ?? state.page;
    final results = await getData(page);

    if (results.isEmpty) {
      state = state.copyWith(page: page, isLoading: false);
      return;
    }
    print('get post is ${results.length}');
    state = state.copyWith(page: page, isLoading: false, results: results);
  }

  loadMoreResult() async {
    StringBuffer bf = StringBuffer();

    bf.write('try to request loading ${state.isLoading} at ${state.page + 1}');
    if (state.isLoading!) {
      bf.write(' fail');
      return;
    }
    bf.write(' success');
    state = state.copyWith(
        isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);

    final results = await getData(state.page + 1);

    if (results.isEmpty) {
      // error
      state = state.copyWith(isLoadMoreError: true, isLoading: false);
      return;
    }

    print('load more ${results.length} posts at page ${state.page + 1}');
    if (results.isNotEmpty) {
      state = state.copyWith(
        page: state.page + 1,
        isLoading: false,
        isLoadMoreDone: results.isEmpty,
        results: [...state.results, ...results],
      );
    } else {
      // not increment page
      state = state.copyWith(
        isLoading: false,
        isLoadMoreDone: results.isEmpty,
      );
    }
  }

  Future<void> refresh() async {
    _initData(1);
  }

  void reset() {
    state = ResultState.initial();
  }
}
