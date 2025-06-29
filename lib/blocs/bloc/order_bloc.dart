import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gmore/models/order_model.dart';
import 'package:gmore/services/order_services.dart';
import 'package:hive/hive.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  // 1. Tambahkan kembali service sebagai dependency
  final OrderServices _orderServices;

  // 2. Perbaiki constructor untuk menerima service
  OrderBloc(this._orderServices) : super(OrderInitial()) {
    // 3. Gunakan event handler yang lebih spesifik
    on<FetchOrdersFromAPI>(_onFetchOrdersFromAPI);
  }

  Future<void> _onFetchOrdersFromAPI(
    FetchOrdersFromAPI event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      // 1. Panggil service untuk mendapatkan SEMUA data dari API
      final List<OrderModel> res = await _orderServices.getData();

      // 2. LANGKAH BARU: Filter data, hanya ambil yang 'statusslik' tidak null
      final List<OrderModel> filteredOrders = res
          .where((order) => order.statusslik != null)
          .toList(); // .toList() penting untuk mengubah hasil filter menjadi List baru

      final List<OrderModel> syncedOrders = filteredOrders
          .map((order) => order.copyWith(isSynced: true))
          .toList();

      // 3. Buka box Hive
      final box = await Hive.openBox<OrderModel>('orders');
      await box.clear();

      // 4. Simpan HANYA data yang sudah difilter ke Hive
      for (var order in syncedOrders) {
        await box.add(order);
      }

      // 5. Emit state sukses
      emit(OrderSuccess());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}

// class OrderBloc extends Bloc<OrderEvent, OrderState> {
//   OrderBloc() : super(OrderInitial()) {
//     on<OrderEvent>((event, emit) async {
//       try {
//         if (event is FetchOrdersFromAPI) {
//           emit(OrderLoading());

//           final List<OrderModel> res = await OrderServices().getData();

//           final box = await Hive.openBox<OrderModel>('orders');
//           // 4. Hapus data lama dan simpan data baru dari API.
//           // Gunakan putAll untuk efisiensi, dengan key dari NIK/ID unik.
//           await box.clear(); // Hapus semua data lama
//           // final Map<String, OrderModel> ordersMap = {
//           //   for (var order in res) order.nik!: order // Asumsikan NIK unik
//           // };
//           // await box.putAll(ordersMap);
//           for (var order in res) {
//             await box.add(order);
//           }
//           // 5. Beri tahu UI bahwa sinkronisasi berhasil
//           emit(OrderSuccess());

//           // emit(OrderLoaded(res));
//         }
//       } catch (e) {
//         emit(OrderError(e.toString()));
//       }
//     });
//   }
// }
