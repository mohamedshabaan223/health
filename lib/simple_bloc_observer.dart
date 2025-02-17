import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} state changed: $change');

    if (change.nextState is AuthInitial) {
      print('${bloc.runtimeType} has been reset');
    }
  }
}
