import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/usecase/get_all_user_for_app_usecase.dart';
import 'package:formify/domain/usecase/insert_all_user_app_usecase.dart';
import 'package:formify/domain/usecase/login_usecase.dart';
import 'package:meta/meta.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final PageController controller = PageController();
  bool isLastPage = false;
  LoginUsecase loginUsecase;
  GetAllUserForAppUsecase getAllUserForAppUsecase;
  InsertAllUserAppUsecase insertAllUserAppUsecase;

//  GetAllSpecUsecase getAllSpecUsecase;

  bool isLastPageFun(int index) => isLastPage = index == 2;
  OnboardingBloc(
    this.loginUsecase,
    this.getAllUserForAppUsecase,
    this.insertAllUserAppUsecase,
    //  this.getAllSpecUsecase
  ) : super(OnboardingInitial()) {
    on<OnboardingEvent>((event, emit) async {
      if (event is LoginRequestEvent) {
        emit(LoginLoadingState());

        (await loginUsecase.execute(
          LoginRequest(event.username, event.password),
        )).fold(
          (failure) {
            emit(LoginErrorState(failure: failure));
          },
          (data) async {
            emit(LoginSuccessState());
          },
        );
      }
      if (event is GetUserEvent) {
        (await getAllUserForAppUsecase.execute()).fold(
          (failure) {
            emit(GetAllUserErrorState(failure: failure));
          },
          (data) async {
            emit(GetAllUserSuccessState(data));
          },
        );
      }
      if (event is InsertUserEvent) {
        (await insertAllUserAppUsecase.execute(event.users)).fold(
          (failure) {
            emit(InsertUserErrorState(failure: failure));
          },
          (data) async {
            emit(InsertUserSuccessState());
          },
        );
      } else if (event is GoToHomeEvent) {
        emit(GoToHomeState());
      }
    });
  }
}
