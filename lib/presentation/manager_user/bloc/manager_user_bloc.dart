import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'manager_user_event.dart';
part 'manager_user_state.dart';

class ManagerUserBloc extends Bloc<ManagerUserEvent, ManagerUserState> {
  ManagerUserBloc() : super(ManagerUserInitial()) {
    on<ManagerUserEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
