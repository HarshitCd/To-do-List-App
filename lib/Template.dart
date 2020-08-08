import 'package:flutter/material.dart';
import 'Todos.dart';
import 'Main_Drawer.dart';
import 'Reader.dart';

class Template extends StatefulWidget {
  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template> {

  @override
  List<Todos> todos = [];
  List<String> tmp = [];
  Reader r = new Reader();

  List<String> choices = [
    "Use Template",
    "Remove Marked",
    "Remove All"
  ];
  final TextEditingController controller = new TextEditingController();

  Map data = {};

  void readData() async{
    String s= await r.readData(data['name']);
    tmp = s.split("\n");
    setState(() {
      for(int i=0; i<tmp.length-1; i++){
        todos.add(new Todos(text:tmp[i]));
      }
    });
  }

  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    if(tmp.length==0){
      readData();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[600]),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: SizedBox(width: double.infinity)),
            Text(
              data['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),

            ),
            Expanded(child: SizedBox(width: double.infinity)),
            PopupMenuButton<String>(
              color: Colors.grey[200],
              itemBuilder: (context){
                return choices.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                    textStyle: TextStyle(

                      color: Colors.black,
                    ),
                  );
                }).toList();
              },
              onSelected: (String s){
                if(s=="Use Template"){
                  List<Todos> to = [];
                  for(int i=0; i<todos.length; i++){
                    if(!todos[i].checked) to.add(todos[i]);
                  }
                  Navigator.pop(context, {
                    'list': to,
                  });
                }
                else if(s=="Remove All"){
                  setState(() {
                    todos=[];
                  });
                }
                else {
                  List<Todos> tmp=[];
                  for(int i=0; i<todos.length; i++){
                    if(todos[i].checked) tmp.add(todos[i]);
                  }

                  setState(() {
                    for(int i=0; i<tmp.length; i++){
                      todos.remove(tmp[i]);
                    }
                    todos;
                  });
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0.0,

      ),
      drawer: Main_Drawer(),

      body: Container(

        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 0,),

            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15),
              child: TextField(
                focusNode: FocusNode(),
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  hintText: "Enter a Todo",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey[900],
                      style: BorderStyle.solid,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[700],
                      style: BorderStyle.solid,
                      width: 2.0,
                    ),
                  ),
                ),
                onSubmitted: (String s){
                  setState(() {
                    todos.add(new Todos(text:s));
                    controller.text = "";
                  });
                },
                controller: controller,
              ),
            ),
            SizedBox(height: 25,),

            Expanded(
              child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: Card(
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.indeterminate_check_box),
                            color: (todos[index].checked)?Colors.blueGrey[900]:Colors.grey,
                            onPressed: (){
                              setState(() {
                                todos[index].checked = !todos[index].checked;
                              });
                            },
                          ),
                          title: Text(
                            todos[index].text,
                          ),
                          trailing: IconButton(
                            onPressed: (){
                              setState((){
                                todos.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.remove),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),

          ],
        ),

      ),
    );
  }
}
