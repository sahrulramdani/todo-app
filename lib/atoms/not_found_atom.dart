import 'package:flutter/material.dart';
import 'package:todo_app_pln/const/public_const.dart';

class NotFoundAtomWidget extends StatelessWidget {
  const NotFoundAtomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Catatan tidak ditemukan.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Text(
              'Coba ubah kalimat pencaharian',
              style: TextStyle(fontSize: 15, color: textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
