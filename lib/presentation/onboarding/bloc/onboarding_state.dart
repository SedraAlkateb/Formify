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
