import 'package:todo_app_pln/atoms/body_atom.dart';
import 'package:todo_app_pln/atoms/empty_atom.dart';
import 'package:todo_app_pln/atoms/not_found_atom.dart';
import 'package:todo_app_pln/atoms/scrolling_vertical_atom.dart';
import 'package:todo_app_pln/components/cardnote_comp.dart';
import 'package:todo_app_pln/components/snackbar_comp.dart';
import 'package:todo_app_pln/const/public_const.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = [];
  bool isSearching = false;

  @override
  void initState() {
    read();
    super.initState();
  }

  read() async {
    var response = await http.get(Uri.parse("$url/notes"));

    List<Map<String, dynamic>> data = List.from(
      json.decode(response.body) as List,
    );

    data.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date'] as String);
      DateTime dateB = DateTime.parse(b['date'] as String);
      return dateB.compareTo(dateA);
    });

    setState(() {
      notes = data;
      filteredNotes = data;
    });
  }

  delete(id) async {
    var response = await http.delete(Uri.parse("$url/notes/$id"));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbarComp(
          message: 'Catatan berhasil dihapus',
          severity: 'success',
        ),
      );
      read();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbarComp(message: 'Catatan gagal dihapus', severity: 'error'),
      );
    }
  }

  void searchNotes(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredNotes = notes;
        isSearching = false;
      });
      return;
    }

    final results =
        notes.where((note) {
          final title = note['title']?.toString().toLowerCase() ?? '';
          final body = note['body']?.toString().toLowerCase() ?? '';
          return title.contains(value.toLowerCase()) ||
              body.contains(value.toLowerCase());
        }).toList();

    setState(() {
      filteredNotes = results;
      isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget bodyContent;

    if (isSearching && filteredNotes.isEmpty) {
      bodyContent = const NotFoundAtomWidget();
    } else if (notes.isEmpty) {
      bodyContent = const EmptyAtomWidget();
    } else {
      bodyContent = ScrollingAtomWidget(
        list: ListView.builder(
          shrinkWrap: true,
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            var note = filteredNotes[index];

            return CardnoteComp(
              id: note['id'] ?? '',
              title: note['title'] ?? '',
              note: note['body'] ?? '',
              date: note['date'],
              onDismissed: (id) {
                delete(id);
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: myGrey,
      floatingActionButton:
          (isSearching || notes.isNotEmpty)
              ? FloatingActionButton(
                backgroundColor: Colors.cyan,
                onPressed: () {
                  Get.toNamed('/form');
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
      body: SafeArea(
        child: Center(
          child: BodyAtomWidget(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Catatan',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: screenWidth - 112,
                    height: 45,
                    child: TextFormField(
                      onChanged: searchNotes,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 192, 192, 192),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        isDense: true,
                        suffixIcon: Icon(size: 25, Icons.search_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              bodyContent,
            ],
          ),
        ),
      ),
    );
  }
}
