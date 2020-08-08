import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Todos.dart';
import 'Main_Drawer.dart';
import 'Reader.dart';

class MyTodos extends StatefulWidget {
  @override
  _MyTodosState createState() => _MyTodosState();
}

class _MyTodosState extends State<MyTodos> {
  @override

  Reader r = new Reader();

//  List<Todos> todos = [
//  new Todos(text:"Wonderland"),
//  new Todos(text:"Promised Neverland"),
//  new Todos(text:"Eutopia"),
//  new Todos(text:"Supereme"),
//  new Todos(text:"Never Give Up"),
//  new Todos(text:"Complete Hypnosis"),
//  new Todos(text:"Getsuga Tensou"),
//
//  ];
  List<Todos> todos = [];


  String storeData(List<Todos> t){
    String s="";
    int n=t.length;
    for(int i=0;i<n; i++){
      s = s+t[i].text+"%${t[i].checked}";
      if(i<n-1) s = s+"\n";
    }
    //print("done");
    //print(s);
    return s;
  }

  List<String> choices = [
    "Remove Marked",
    "Remove All",
    "Save As Template"
  ];

  final TextEditingController controller = new TextEditingController();
  final TextEditingController controller1 = new TextEditingController();

  Widget fileName(){
    String val;
    return Container(
      height:100,
      width: 50,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "File Name",
              ),
              onChanged: (String v){
                setState(() {
                  val = v;
                });
              },
              onSubmitted: (String s) async{
                int a=0;
                Navigator.of(context).pop();
                String data = storeString(todos);
                String f = await r.readData('Templates');
                f = (f==null) ? "" : f;
                List<String> l = f.split('\n');
                for(String x in l){
                  if(x.compareTo(s)==0) a=1;
                }
                if(a==0) {
                  f = "$f$s\n";
                  r.writeData('Templates', f);
                  r.writeData(s, data);
                }
                //print(f);
                //print(s);
                setState(() {
                  controller1.text = "";
                });
              },
              controller: controller1,
            ),
          ),
          SizedBox(height: 5,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FlatButton(
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                onPressed: () async {
                  int a=0;
                  Navigator.of(context).pop();
                  String data = storeString(todos);
                  String f = await r.readData('Templates');
                  f = (f==null) ? "" : f;
                  List<String> l = f.split('\n');
                  for(String x in l){
                    if(x.compareTo(val)==0){
                      a=1;
                      break;
                    }
                  }
                  if(a==0) {
                    f = "$f$val\n";
                    r.writeData('Templates', f);
                    r.writeData(val, data);
                  }
                  //print(f);
                  //print(s);
                  setState(() {
                    controller1.text = "";
                  });
                },
              ),
            ),
          ),

        ],
      ),
    );
  }

  String storeString(List<Todos> t) {
    String s="";
    int n=t.length;
    for(int i=0; i<n; i++){
      s = s+t[i].text+"\n";
    }
    //print(s);
    return s;
  }

  void updateData(){
    String s = storeData(todos);
    r.writeData("InitialState", s);
    //print("updated");
    //print(s);
  }


  void setInitialValues() async{
    String s = await r.readData("InitialState");
    //print(s);
    List<Todos> to=[];
    try {
      List<String> l = s.split("\n");
      for (int i = 0; i < l.length; i++) {
        List<String> t = l[i].split("%");
        //print(t[0] + " - " + t[1]);
        if (t[1] == "true")
          to.add(new Todos(text: t[0], checked: true));
        else if (t[1] == "false")
          to.add(new Todos(text: t[0], checked: false));
      }
    }
    catch(e){
      print(e.toString());
    }

//    print(to);
    setState(() {
      todos = to;
      c=1;
    });
  }

  int c=0;

  void gotData(List<Todos> data){
    //print("Yes data");
    setState(() {
      todos.addAll(data);
      data = null;
    });
  }

  void initState(){
    //print(c);
    setInitialValues();
  }

  Widget build(BuildContext context) {
    //if(todos.length==0) setInitialValues();
    Map result = ModalRoute.of(context).settings.arguments;

    if(c!=0) updateData();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[600]),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: SizedBox(width: double.infinity)),
            Text(
              'TO DO',
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
                if(s=="Remove All"){
                  r.writeData("InitialState", " ");
                  setState(() {
                    todos=[];
                  });
                }

                else if(s=="Remove Marked"){
                  List<Todos> tmp=[];
                  for(int i=0; i<todos.length; i++){
                    if(todos[i].checked) tmp.add(todos[i]);
                  }
                  for(int i=0; i<tmp.length; i++){
                    todos.remove(tmp[i]);
                  }
                  setState(() {
                    todos;
                  });
                }

                else{
                  showDialog(
                      context: context,
                      child: Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: fileName(),
                      )
                  );
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0.0,

      ),
      drawer: Main_Drawer(gotData: gotData),

      body: Container(

        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15),
              child: TextField(

                focusNode: FocusNode(),
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  hintText: "Enter a Todo",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue[900],
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
                            icon: Icon(Icons.check_box),
                            color: (todos[index].checked)?Colors.blue[900]:Colors.grey,
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
