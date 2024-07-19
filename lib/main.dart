import 'package:api_flutter/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController txt_new_name=TextEditingController();
  bool is_new_name=false;
  final ScrollController _scrollController=ScrollController();
  bool is_loading=true;
  final GlobalKey<ScaffoldState> _scaffoldKey= GlobalKey<ScaffoldState>(); 
  var poke_data=[];
   Future getData() async{
    poke_data= await ApiService.getData();
    print(poke_data.length);
    setState(() {
      is_loading=false;
    });
   }

  var listLength=20;
  @override
  void initState() {
    super.initState();
    getData();
     _scrollController.addListener(_scrollListner);   
  }

  Future _scrollListner() async{
    print("scroll listner is listening");
    if(_scrollController.offset == _scrollController.position.maxScrollExtent)
    {
      Future.delayed(Duration(seconds: 1));
      setState(() {
        listLength+=15;
        print("new state is set");
      });
    }
  }

  Future<dynamic> showpokemon(int index) async{
    final pokemon_data=await ApiService.getPokemonData(index+1);
    print(pokemon_data['height']);
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        content: Container(
          height: 400,
          child: Column(children: <Widget>[
           Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index+1}.png",fit: BoxFit.fill,height: 200,width: 200,),
            is_new_name?Column(children: <Widget>[
              TextField(controller: txt_new_name,),
              ElevatedButton(onPressed: (){
                poke_data[index]['name']=txt_new_name.text;
                setState(() {
                  Navigator.of(context).pop();
              is_new_name=false;
              txt_new_name.text=poke_data[index]['name'];
              showpokemon(index);
                });
              }, child: Text("Save")),
            ],):Row(children: <Widget>[
            Text(poke_data[index]['name'].toString(),style: TextStyle(fontSize: 30.0),),
            IconButton(onPressed: (){setState(() {
              Navigator.of(context).pop();
              is_new_name=true;
              txt_new_name.text=poke_data[index]['name'];
              showpokemon(index);
            });}, icon: Icon(Icons.edit))
            ]), 
            Text("Height: ${pokemon_data['height']}",style: TextStyle(fontSize: 25.0),)
          ],),
        ),
        actions: <Widget>[
          TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black
              ),
              child:Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("API Calling"),
        leading: IconButton(onPressed: (){_scaffoldKey.currentState?.openDrawer();}, icon: Icon(Icons.menu)),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              is_loading?Center(child: CircularProgressIndicator(),):
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listLength+1,
                itemBuilder: (BuildContext context,int index){
                  if(index==listLength){
                    return Padding(padding: const EdgeInsets.only(top:8.0,bottom: 50.0),child: Center(child: CircularProgressIndicator(),),);
                  }
                  else{
                  print(poke_data[index]);
                  return InkWell(onTap: () {
                    showpokemon(index);
                  }, child: ListTile(title:Text(poke_data[index]['name'].toString()),leading: Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index+1}.png"),));
                  }
                 
              }),
                           
            ],
          ),
      ),
      drawer: Drawer(child: SafeArea(
        child: Container(child: Column(children: <Widget>[
          CircleAvatar(backgroundImage: NetworkImage("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"),minRadius: 50,maxRadius: 75,),
          Text("Pikachu",style: TextStyle(fontSize: 30.0,color: Colors.black),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Container(margin:EdgeInsets.only(left:10.0,right:10.0,top:20.0),decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(25.0)), padding: EdgeInsets.only(top:20.0,bottom: 20.0,left:15.0,right:15.0),child: Column(children: <Widget>[
            ListTile(leading: Icon(CupertinoIcons.app), title: Text("All Pokemons"),contentPadding: EdgeInsets.only(left: 10.0,bottom:5.0,top:5.0,right:10.0)),
            Divider(),
            ListTile(leading: Icon(CupertinoIcons.drop), title: Text("Water Type"),contentPadding: EdgeInsets.only(left: 10.0,bottom:5.0,top:5.0,right:10.0)),
            Divider(),
            ListTile(leading: Icon(CupertinoIcons.flame), title: Text("Fire Type"),contentPadding: EdgeInsets.only(left: 10.0,bottom:5.0,top:5.0,right:10.0)),
            Divider(),
            ListTile(leading: Icon(CupertinoIcons.circle), title: Text("Ground Type"),contentPadding: EdgeInsets.only(left: 10.0,bottom:5.0,top:5.0,right:10.0)),
          ],),)

        ],)
       
        ),),),
    );
  }
}
