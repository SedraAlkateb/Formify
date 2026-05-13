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
class GetUserEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];
}
class InsertUserEvent extends OnboardingEvent {
 final List<UserModel> users;
  InsertUserEvent(this.users);
  @override
  List<Object?> get props => [users];
}

class GoToHomeEvent extends OnboardingEvent {
  @override

  List<Object?> get props => [];

}
