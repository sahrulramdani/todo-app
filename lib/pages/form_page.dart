import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/route_manager.dart';
import 'package:todo_app_pln/atoms/body_atom.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:todo_app_pln/components/snackbar_comp.dart';
import 'package:todo_app_pln/const/public_const.dart';

class FormPageWidget extends StatefulWidget {
  const FormPageWidget({super.key});

  @override
  State<FormPageWidget> createState() => _FormPageWidgetState();
}

class _FormPageWidgetState extends State<FormPageWidget> {
  final id = Get.parameters['id'];
  final formKey = GlobalKey<FormState>();

  bool loading = false;
  final TextEditingController titleController = TextEditingController();
  final QuillController quillController = QuillController.basic();

  read(id) async {
    var response = await http.get(Uri.parse("$url/notes/$id"));

    var body = json.decode(response.body);

    setState(() {
      title = body['title'];
      titleController.text = body['title'];

      final delta = Delta.fromJson(jsonDecode(body['body']));
      quillController.document = Document.fromDelta(delta);
    });
  }

  save() async {
    var now = DateTime.now();
    var formattedDate = DateFormat('yyyy-MM-dd').format(now);

    var params = {
      'title': titleController.text,
      'body': jsonEncode(quillController.document.toDelta().toJson()),
      'date': formattedDate,
    };

    http.Response response;

    if (id != null) {
      response = await http.put(
        Uri.parse("$url/notes/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params),
      );
    } else {
      response = await http.post(
        Uri.parse("$url/notes"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params),
      );
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbarComp(
          message: 'Catatan berhasil disimpan',
          severity: 'success',
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Get.toNamed('/');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbarComp(
          message: 'Catatan gagal disimpan',
          severity: 'error',
        ),
      );
    }
  }

  @override
  void initState() {
    if (id != null) {
      read(id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myGrey,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: BodyAtomWidget(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed('/');
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() && !loading) {
                        save();
                      } else {
                        return;
                      }
                    },
                    icon: Icon(Icons.save_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: TextFormField(
                  controller: titleController,
                  onChanged: (value) {
                    title = value;
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'Judul Harus Diisi';
                    }

                    return null;
                  },
                  readOnly: loading,
                  decoration: InputDecoration(
                    hintText: 'Judul Catatan',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.all(0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: QuillEditor.basic(
                  controller: quillController,
                  focusNode: FocusNode(),
                  scrollController: ScrollController(),
                  config: QuillEditorConfig(
                    placeholder: 'Tulis sesuatu...',
                    disableClipboard: loading,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: QuillSimpleToolbar(
                    controller: quillController,
                    config: QuillSimpleToolbarConfig(
                      toolbarIconAlignment: WrapAlignment.start,
                      axis: Axis.horizontal,
                      showClipboardCopy: false,
                      showClipboardPaste: false,
                      showLink: false,
                      showSearchButton: false,
                      toolbarSectionSpacing: 0,
                      toolbarRunSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
