import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todo_app_pln/const/public_const.dart';

class EmptyAtomWidget extends StatelessWidget {
  const EmptyAtomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: const Image(
                image: AssetImage('assets/images/undraw-note-add.png'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum Ada Catatan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Text(
              'Buat catatan pertamamu sekarang, yuk!',
              style: TextStyle(fontSize: 15, color: textGrey),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/form');
              },
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Buat Catatan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
