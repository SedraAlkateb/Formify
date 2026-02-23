part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingEvent  extends Equatable{}

class LoginRequestEvent extends OnboardingEvent {
  final String username;
  final String password;
  LoginRequestEvent(this.username, this.password);
  @override
  List<Object?> get props => [];
}
