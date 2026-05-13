part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingState extends Equatable {}

final class OnboardingInitial extends OnboardingState {
  @override
  List<Object?> get props => [];
}
final class LoginErrorState extends OnboardingState {
  final Failure failure;
  LoginErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class LoginLoadingState extends OnboardingState {
  @override
  List<Object?> get props => [];
}
class LoginSuccessState extends OnboardingState {
  LoginSuccessState() ;
  @override
  List<Object?> get props => [];
}

final class InsertUserErrorState extends OnboardingState {
  final Failure failure;
  InsertUserErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class InsertUserLoadingState extends OnboardingState {
  @override
  List<Object?> get props => [];
}
class InsertUserSuccessState extends OnboardingState {
  InsertUserSuccessState() ;
  @override
  List<Object?> get props => [];
}

final class GetAllUserErrorState extends OnboardingState {
  final Failure failure;
  GetAllUserErrorState({required this.failure});
  @override
  List<Object?> get props =>[failure];
}
final class GetAllUserLoadingState extends OnboardingState {
  @override
  List<Object?> get props => [];
}
class GetAllUserSuccessState extends OnboardingState {
 final List<UserModel>users;
  GetAllUserSuccessState(this.users) ;
  @override
  List<Object?> get props => [users];
}

final class GoToHomeState extends OnboardingState {
  @override
  List<Object?> get props => [];
}