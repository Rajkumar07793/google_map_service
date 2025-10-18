import 'dart:async';

import 'package:example/bloc/selection_bloc/selection_event.dart';
import 'package:example/bloc/selection_bloc/selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionBloc extends Bloc<SelectionBlocEvent, SelectionBlocState> {
  SelectionBloc(super.initialState) {
    on(eventHandler);
  }

  FutureOr<void> eventHandler(
    SelectionBlocEvent event,
    Emitter<SelectionBlocState> emit,
  ) {
    if (event is SelectThemeEvent) {
      emit(SelectThemeState(event.themeMode));
    }
    if (event is SelectStringEvent) {
      emit(SelectStringState(event.value));
    }
    if (event is SelectBoolEvent) {
      emit(SelectBoolState(event.value));
    }

    if (event is SelectIntEvent) {
      emit(SelectIntState(event.value));
    }

    if (event is SelectDateRangeEvent) {
      emit(SelectDateRangeState(event.value));
    }

    if (event is SelectFileEvent) {
      emit(SelectFileState(event.value));
    }
    //
    // if (event is SelectCountryEvent) {
    //   emit(SelectCountryState(event.value));
    // }
    // if (event is SelectStEvent) {
    //   emit(SelectStStState(event.value));
    // }
    //
    if (event is DatePicked) {
      emit(DatePickerLoaded(event.selectedDate));
    }
    // if (event is SelectRide){
    //   emit (SelectedRideState(event.value));
    // }
  }
}
