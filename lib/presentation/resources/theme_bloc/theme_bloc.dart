import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  Color seedColor=ColorManager.primary;
  String colorName = "0xFF3A5A75";
  ThemeBloc() : super(ThemeInitial()) {

    on<ThemeEvent>((event, emit) {


      if(event is ChangeThemeColorEvent){
        seedColor=event.newColor;
        colorName=event.colorName;
        print("objectss");
        emit(ThemeChangedState(event.newColor)); // تحديث اللون
      }

    });
  }
}
