import 'package:flutter/material.dart';

import 'package:spflite/data/local/db_helper.dart';

class MyhomePage extends StatefulWidget {
  const MyhomePage({super.key});

  @override
  State<MyhomePage> createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  DBHelper? mainDb;
  List<Map<String, dynamic>> allNotes = [];
  TextEditingController titleContoller = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mainDb = DBHelper.getInstance;
    getIntialNotes();
  }

  void getIntialNotes() async {
    allNotes = await mainDb!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    leading: Text('${allNotes[index][DBHelper.coloumnNoteSNo]}'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textColor: Colors.black,
                    tileColor: Colors.grey.shade300,
                    title: Text(allNotes[index][DBHelper.coloumnNoteTitle]),
                    subtitle: Text(allNotes[index][DBHelper.coloumnNoteDesc]),
                    trailing: SizedBox(
                      width: 50,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: ()  {
                                 mainDb!.updateNote(
                                    title: 'Updated Note',
                                    desc: 'This is Updated Note',
                                    sno: allNotes[index]
                                        [DBHelper.coloumnNoteSNo]);
                                getIntialNotes();
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              )),
                          SizedBox(
                            width: 2,
                          ),
                          InkWell(
                              onTap: () {
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('No Notes Found'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //await  mainDb!.addNote(title: 'main Note', desc: 'what am i going to do today');
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(22),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'Add Note',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      TextField(
                        controller: titleContoller,
                        decoration: InputDecoration(
                            label: Text('Title'),
                            hintText: 'Enter Title Here',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            )),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      TextField(
                        controller: descController,
                        maxLines: 3,
                        decoration: InputDecoration(
                            label: Text('Desc'),
                            hintText: 'Enter Description Here',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            )),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                addNoteinDb();
                                titleContoller.clear();
                                descController.clear();
                                Navigator.pop(context);
                              },
                              child: Text('Add')),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                        ],
                      )
                    ],
                  ),
                );
              });
          getIntialNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  addNoteinDb() async {
    var mtitle = titleContoller.text.toString();
    var mdesc = descController.text.toString();
    bool check = await mainDb!.addNote(title: mtitle, desc: mdesc);
    String msg = 'Note adding Failed';
    if (check) {
      msg = 'Note Added Succesfully';
      getIntialNotes();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

}
