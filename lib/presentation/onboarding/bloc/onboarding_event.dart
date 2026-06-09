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
class GetSpecEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];
}
class InsertSpecEvent extends OnboardingEvent {
  final List<SpecModel> spec;
  InsertSpecEvent(this.spec);
  @override
  List<Object?> get props => [spec];
}
class GoToHomeEvent extends OnboardingEvent {
  @override

  List<Object?> get props => [];

}
