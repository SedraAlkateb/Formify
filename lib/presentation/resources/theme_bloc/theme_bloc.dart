import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  Color seedColor=Colors.black26;
  ThemeBloc() : super(ThemeInitial()) {

    on<ThemeEvent>((event, emit) {


      if(event is ChangeThemeColorEvent){
        seedColor=event.newColor;
        print("objectss");
        emit(ThemeChangedState(event.newColor)); // تحديث اللون
      }

    });
  }
}
