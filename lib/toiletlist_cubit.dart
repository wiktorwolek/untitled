import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/data/toilet.dart';

import 'data/toilet_list_data_source.dart';

class ToiletListCubit extends Cubit<ToiletListState> {
  ToiletListCubit({required ToiletListDataSource toiletListDataSource})
      : _toiletListDataSource = toiletListDataSource,
        super(const ToiletListInitialState()) {
    _sub = _toiletListDataSource.toiletStream.listen(
        (toilets) => emit(ToiletListLoadedState(toilets: toilets.toList())));
  }

  final ToiletListDataSource _toiletListDataSource;
  late final StreamSubscription _sub;

  Future<void> refresh() async {
    final toilets = await _toiletListDataSource.getToilets();
    emit(ToiletListLoadedState(
      toilets: toilets.toList(),
    ));
  }

  void addToilet(Toilet toilet) {
    _toiletListDataSource.sendToilet(toilet);
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}

abstract class ToiletListState {
  const ToiletListState();
}

class ToiletListInitialState extends ToiletListState {
  const ToiletListInitialState();
}

class ToiletListLoadedState extends ToiletListState {
  const ToiletListLoadedState({
    required this.toilets,
  });

  final List<Toilet> toilets;
}
