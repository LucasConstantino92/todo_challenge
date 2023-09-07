import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Importe o pacote mask_text_input_formatter
import 'package:to_do_challenge/helper/db_helper.dart';
import 'package:to_do_challenge/model/todo_model.dart';
import 'package:flutter/services.dart';
import 'package:to_do_challenge/ui/home_page.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoInit;
  String? todoEnd;
  bool? update;

  AddUpdateTask({this.todoId, this.todoTitle, this.todoDesc, this.todoInit, this.todoEnd, this.update});

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  String? validateDates(String? startDate, String? finalDate) {
    if (startDate == null ||
        finalDate == null ||
        startDate.isEmpty ||
        finalDate.isEmpty) {
      return "Coloque as datas";
    }

    final dateFormat = DateFormat('dd/MM/yyyy');
    final initialDate = dateFormat.parse(startDate);
    final endDate = dateFormat.parse(finalDate);

    if (initialDate.isAfter(endDate) || initialDate.isBefore(DateTime.now())) {
      return "A data inicial não pode ser maior que a data final";
    }

    if (endDate.isBefore(initialDate)) {
      return "A data final não pode ser menor que a data inicial";
    }

    return null;
  }

  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descriptionController = TextEditingController(text: widget.todoDesc);
    final initialDateController = TextEditingController(text: widget.todoInit);
    final finalDateController = TextEditingController(text: widget.todoEnd);
    String appTitle;

    if((widget.update) == true) {
      appTitle = "Atualizar Tarefa";
    } else {
      appTitle = "Adicionar Tarefa";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _fromKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nome da Tarefa',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Coloque um nome";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 5,
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Descrição',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Insira uma descrição";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: initialDateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Data de início',
                        ),
                        validator: (value) =>
                            validateDates(value, finalDateController.text),
                        inputFormatters: [maskFormatter],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: finalDateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Data final',
                        ),
                        validator: (value) =>
                            validateDates(initialDateController.text, value),
                        inputFormatters: [maskFormatter],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          if (_fromKey.currentState!.validate()) {
                            dbHelper!.insert(TodoModel(
                                title: titleController.text,
                                description: descriptionController.text,
                                initialDate: initialDateController.text,
                                endDate: finalDateController.text,
                                startdate: ''));

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                            titleController.clear();
                            descriptionController.clear();
                            initialDateController.clear();
                            finalDateController.clear();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 55,
                          width: 120,
                          child: const Text(
                            "Enviar",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            titleController.clear();
                            descriptionController.clear();
                            initialDateController.clear();
                            finalDateController.clear();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 55,
                          width: 120,
                          child: const Text(
                            "Limpar",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
