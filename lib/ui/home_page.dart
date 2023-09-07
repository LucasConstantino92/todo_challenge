import 'package:flutter/material.dart';
import 'package:to_do_challenge/helper/db_helper.dart';
import 'package:to_do_challenge/model/todo_model.dart';
import 'package:to_do_challenge/ui/add_update_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: dataList,
              builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text(
                    'Sem novas tarefas',
                    style: TextStyle(fontSize: 22),
                  ));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      int todoId = snapshot.data![index].id!.toInt();
                      String todoTitle =
                          snapshot.data![index].title!.toString();
                      String todoDesc =
                          snapshot.data![index].description!.toString();
                      String todoInit =
                          snapshot.data![index].initialDate!.toString();
                      String todoFinal =
                          snapshot.data![index].enddate!.toString();
                      return Dismissible(
                        key: ValueKey<int>(todoId),
                        background: Container(
                          color: Colors.redAccent,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            dbHelper!.delete(todoId);
                            dataList = dbHelper!.getDataList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.yellow.shade300,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    spreadRadius: 1)
                              ]),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    todoTitle,
                                    style: const TextStyle(fontSize: 19),
                                  ),
                                ),
                                subtitle: Text(
                                  todoDesc,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(todoInit),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(todoFinal),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddUpdateTask(
                                                      todoId: todoId,
                                                      todoTitle: todoTitle,
                                                      todoDesc: todoDesc,
                                                      todoInit: todoInit,
                                                      todoEnd: todoFinal,
                                                      update: true,
                                                    )));
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUpdateTask(),
                ));
          },
          child: const Icon(Icons.add)),
    );
  }
}
