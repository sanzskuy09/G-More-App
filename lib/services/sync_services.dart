import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gmore/models/order_model.dart';
import 'package:hive/hive.dart';

class SyncService {
  static final Connectivity _connectivity = Connectivity();
  static bool _isSyncing = false;
  static Function(String message)? _onStatusCallback;

  static void init({Function(String message)? onStatus}) {
    _onStatusCallback = onStatus;

    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _onStatusCallback?.call("Terhubung ke internet, mulai sinkronisasi...");
        syncPendingOrders();
      } else {
        _onStatusCallback?.call("Tidak ada koneksi internet.");
      }
    });
  }

  static Future<void> syncPendingOrders() async {
    if (_isSyncing) return;
    _isSyncing = true;

    final box = Hive.box<OrderModel>('orders');
    final pending = box.values.where((o) => o.isSynced!).toList();

    for (final order in pending) {
      try {
        final success = await sendOrderToBackend(order);
        if (success) {
          order.isSynced = true;
          await order.save();
        }
      } catch (e) {
        _onStatusCallback?.call("Gagal sinkronisasi: ${order.nama}");
      }
    }

    if (pending.isNotEmpty) {
      _onStatusCallback?.call("Berhasil sinkronisasi ${pending.length} order.");
    }

    _isSyncing = false;
  }

  static Future<bool> sendOrderToBackend(OrderModel order) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulasi delay
    return true; // asumsi sukses
  }
}
