part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

final class GetOrder extends OrderEvent {
  final OrderModel data;
  const GetOrder(this.data);

  @override
  List<Object> get props => [data];
}
