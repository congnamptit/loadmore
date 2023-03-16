import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loadmore/results_model.dart';
import 'package:loadmore/results_vm.dart';

import 'movie_cart.dart';

final keyProvider = StateProvider<String>((ref) {
  return '';
});

final resultSearchProvider = StateProvider.autoDispose<List<Results>>((ref) {
  final resultState = ref.watch(resultVM);
  final key = ref.watch(keyProvider);

  return resultState.results
      .where((element) => element.title!.contains(key))
      .toList();
});

class HomePage extends HookConsumerWidget {
  final ScrollController _controller = ScrollController();
  int oldLength = 0;

  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      _controller.addListener(() async {
        if (_controller.position.pixels >
            _controller.position.maxScrollExtent -
                MediaQuery.of(context).size.height) {
          if (oldLength == ref.read(resultVM).results.length) {
            ref.read(resultVM.notifier).loadMoreResult();
          }
        }
      });
      return () => {_controller};
    }, ["controller"]);
    return Scaffold(
      body: Consumer(
        builder: (ctx, watch, child) {
          final isLoadMoreError = ref.watch(resultVM).isLoadMoreError;
          final isLoadMoreDone = ref.watch(resultVM).isLoadMoreDone;
          final isLoading = ref.watch(resultVM).isLoading;
          final result = ref.watch(resultSearchProvider.notifier).state;

          // sync oldLength with post.length to make sure ListView has newest
          // data, so loadMore will work correctly
          oldLength = result.length;
          // init data or error
          if (result.isEmpty) {
            // error case
            if (isLoading == false) {
              return const Center(
                child: Text('error'),
              );
            }
            return const _Loading();
          }
          return RefreshIndicator(
            onRefresh: () {
              return ref.read(resultVM.notifier).refresh();
            },
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(
                result.length,
                (index) {
                  // last element (progress bar, error or 'Done!' if reached to the last element)
                  if (index == result.length) {
                    // load more and get error
                    if (isLoadMoreError!) {
                      return const Center(
                        child: Text('Error'),
                      );
                    }
                    // load more but reached to the last element
                    if (isLoadMoreDone!) {
                      return const Center(
                        child: Text(
                          'Done!',
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                      );
                    }
                    return const LinearProgressIndicator();
                  }

                  return MovieCart(
                    title: result[index].title,
                    poster_path: result[index].posterPath,
                    vote_average: result[index].voteAverage,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
