import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/route_manager.dart';

class CardnoteComp extends StatefulWidget {
  dynamic id;
  String title;
  String note;
  String date;
  Function onDismissed;

  CardnoteComp({
    super.key,
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.onDismissed,
  });

  @override
  State<CardnoteComp> createState() => _CardnoteCompState();
}

class _CardnoteCompState extends State<CardnoteComp> {
  late String plainTextNote;

  @override
  void initState() {
    super.initState();
    plainTextNote = _convertDeltaToPlainText(widget.note);
  }

  String _convertDeltaToPlainText(String deltaJson) {
    try {
      final delta = Delta.fromJson(jsonDecode(deltaJson));
      final document = quill.Document.fromDelta(delta);
      return document.toPlainText().trim();
    } catch (e) {
      return "Gagal memuat catatan";
    }
  }

  String formatRelativeDate(String dateString) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.parse(dateString);

    Duration difference = now.difference(date);
    int daysDifference = difference.inDays;

    if (daysDifference == 0) {
      return "Dibuat hari ini";
    } else if (daysDifference == 1) {
      return "1 hari lalu";
    } else {
      return "$daysDifference hari lalu";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red[800],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete_forever_outlined,
          color: Colors.white,
          size: 35,
        ),
      ),
      onDismissed: (direction) {
        widget.onDismissed(widget.id);
      },
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/form/${widget.id}');
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  plainTextNote,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  formatRelativeDate(widget.date),
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
