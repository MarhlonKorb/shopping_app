import 'package:flutter/material.dart';

class CounterState {
  int _value = 0;
// Sempre que for preciso notificar a mudança de um estado, deve ser feito dentro de um setState
  void inc() => _value++;
  void dec() => _value--;
  int get value => _value;

/// Notifica quando o estado da variável mudar para notificar o provider da mundança
  bool diff(CounterState old) {
    return old._value != _value;
  }
}

class CounterProvider extends InheritedWidget {
  final CounterState state = CounterState();

  CounterProvider({Key? key, required Widget child})
      : super(key: key, child: child);

/// Devolve uma instância do Provider de Counter em qualquer lugar do aplicativo
  static CounterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  @override
  bool updateShouldNotify(covariant CounterProvider oldWidget) {
    throw oldWidget.state.diff(state);
  }
}
