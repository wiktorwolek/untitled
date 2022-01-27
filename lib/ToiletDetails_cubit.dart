import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/data/toilet.dart';

import 'data/toilet_list_data_source.dart';

class ToiletDetailsCubit extends Cubit<ToiletDetailsState> {
  ToiletDetailsCubit(
      {required ToiletListDataSource toiletListDataSource,
      required String name})
      : _toiletListDataSource = toiletListDataSource,
        name = name,
        super(const ToiletDetailsInitialState()) {
    refresh();
  }

  final ToiletListDataSource _toiletListDataSource;
  final String name;
  Future<void> refresh() async {
    Toilet toilet = await _toiletListDataSource.getToilet(name);
    emit(ToiletDetailsLoadedState(
      toilets: toilet,
    ));
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}

abstract class ToiletDetailsState {
  const ToiletDetailsState();
}

class ToiletDetailsInitialState extends ToiletDetailsState {
  const ToiletDetailsInitialState();
}

class ToiletDetailsLoadedState extends ToiletDetailsState {
  const ToiletDetailsLoadedState({
    required this.toilets,
  });

  final Toilet toilets;
}
