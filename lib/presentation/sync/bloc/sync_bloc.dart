import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {

  SyncBloc() : super(SyncInitial()) {
    on<SyncEvent>((event, emit) {

    });
  }
}
