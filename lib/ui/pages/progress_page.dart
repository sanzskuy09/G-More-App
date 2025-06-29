import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmore/blocs/bloc/order_bloc.dart';
import 'package:gmore/models/order_model.dart';
import 'package:gmore/ui/pages/detail_progress_page.dart';
import 'package:hive_flutter/adapters.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<OrderModel>('orders');

    return Scaffold(
      appBar: AppBar(
        title: const Text('DAFTAR ORDER'),
        automaticallyImplyLeading: false,
        actions: [
          // Tambahkan tombol refresh untuk memicu sinkronisasi manual
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              // Tampilkan icon loading saat sedang sinkronisasi
              if (state is OrderLoading) {
                return const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<OrderBloc>().add(FetchOrdersFromAPI());
                },
              );
            },
          ),
        ],
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is OrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data berhasil diperbarui.'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Gagal sinkronisasi. Menampilkan data offline. Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<OrderModel> box, _) {
            final orders = box.values.toList(); // Ambil semua data sebagai list

            if (orders.isEmpty) {
              // Jika box kosong, cek state BLoC
              return BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  // Tampilkan loading besar jika sedang sinkronisasi pertama kali
                  if (state is OrderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Tampilkan pesan jika tidak ada data sama sekali
                  return const Center(child: Text('Belum ada data order.'));
                },
              );
            }

            // UI ListView Anda yang sudah ada, gunakan `orders` dari hive
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailProgressPage(order: order),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: order.fotoktp != null
                                  ? MemoryImage(order.fotoktp!)
                                  : null,
                              child: order.fotoktp == null
                                  ? const Icon(Icons.person, size: 28)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.nama ?? 'Tanpa Nama',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('NIK: ${order.nik ?? '-'}'),
                                  Text('Alamat: ${order.alamat ?? '-'}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  if (order.statusslik != null)
                                    _buildStatusBadge(order.statusslik!)
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'BERSIH':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        label = 'Success';
        break;
      case 'PENDING':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = 'On Progress';
        break;
      case 'REJECT':
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        label = 'Reject';
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
