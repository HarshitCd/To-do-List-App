import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Reader.dart';

class Main_Drawer extends StatefulWidget {
  @override
  Function gotData;

  Main_Drawer({this.gotData});

  _Main_DrawerState createState() => _Main_DrawerState(gotData: gotData);
}

class _Main_DrawerState extends State<Main_Drawer> {
  @override
  Function gotData;
  _Main_DrawerState({this.gotData});

  Reader r = new Reader();
  String s="";
  List<String> templates = [""];

  String storeString(List<String> temps){
    String s="";
    int n=temps.length;
    for(int i=0; i<n; i++){
      s = s+temps[i];
      if(i<n-1)s=s+"\n";
    }
    return s;
  }

  void readTemps() async{
    String f = await r.readData("Templates");
    if(f!=null){
      setState(() {
        s=f;
        templates = s.split('\n');
      });
    }
  }

  void initState(){
    readTemps();
  }



  Widget delete_confirm(int index){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      backgroundColor: Colors.grey[200],
      child: Container(
        height: 100.0,
        width: 50,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Are you sure?",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: (){
                      String s=templates[index];
                      templates.removeAt(index);
                      Navigator.of(context).pop();
                      setState((){
                        templates;
                        r.writeData("Templates", storeString(templates));
                        r.delFile(s);
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40,),
            CircleAvatar(
              //backgroundImage: AssetImage("assest/tt.jpg"),
              backgroundColor: Colors.amber,
              radius: 60,
            ),
            SizedBox(height: 25,),
            Text(
              "Template Todo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.grey[800],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
              child: Divider(
                height: 35,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: templates.length-1,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: Card(
                        child: ListTile(
                          onTap: () async{
                            dynamic result;
                            if(ModalRoute.of(context).settings.name == '/'){
                              result = await Navigator.pushNamed(context, '/template', arguments: {
                                'name': templates[index],
                              });
                            }
                            else {
                              result = await Navigator.pushReplacementNamed(
                                  context, '/template', arguments: {
                                'name': templates[index],
                              });
                            }
                            //print("Hey There");

                            if(result!=null){
                              gotData(result['list']);
                            }
                            Navigator.pop(context);
                          },
                          title: Text(
                            templates[index],
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          trailing: IconButton(
                            iconSize: 23,
                            icon: Icon(Icons.delete),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context){
                                  return delete_confirm(index);
                                }
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
