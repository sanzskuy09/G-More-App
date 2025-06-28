part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderFailed extends OrderState {
  final String err;
  const OrderFailed(this.err);

  @override
  List<Object> get props => [err];
}

final class OrderSuccess extends OrderState {
  final OrderModel data;
  const OrderSuccess(this.data);

  @override
  List<Object> get props => [data];
}
