part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

// State ketika data sedang dimuat dari Hive

// State ketika data berhasil dimuat, membawa daftar order
// class OrderLoaded extends OrderState {
//   final List<OrderModel> orders;

//   const OrderLoaded(this.orders);

//   @override
//   List<Object> get props => [orders];
// }
class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {}

// State ketika terjadi error saat memuat data
class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

// Create Order
class OrderCreateLoading extends OrderState {}

class OrderCreated extends OrderState {}

class OrderCreateError extends OrderState {
  final String message;
  const OrderCreateError(this.message);

  @override
  List<Object> get props => [message];
}
