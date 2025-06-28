import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gmore/models/order_model.dart';
import 'package:gmore/services/order_services.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<OrderEvent>((event, emit) async {
      if (event is GetOrder) {
        emit(OrderLoading());

        final res = await OrderServices().getData(event.data);

        emit(OrderSuccess(res));
      }
    });
  }
}
