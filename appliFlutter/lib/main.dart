
import 'dart:convert';
import 'dart:async';
import 'package:application1/infoClient.dart';
import 'package:application1/ajouterClient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

const url = 'https://elmr.000webhostapp.com/api/php/POO/index2.php';

class Client {
  final List clients ;


  const Client({
    required this.clients,

  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        clients: json['clients'],
    );
  }
}

Future<Client> fetchClient() async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Client.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load client');
  }
}


const d_green = Color(0xFF54D3C2);
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abonnement',
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Future<Client> futureClient;

  @override
  void initState() {
    super.initState();
    futureClient = fetchClient();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Home' , 
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800
            ),
          ),
          actions: [
            IconButton(
            icon: Icon(
                Icons.add,
                color: Colors.grey[800],
                size: 20,
              ), 
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AjouterClient(),
                  )
                );
              },
            ),
          IconButton(
            icon: Icon(
                Icons.delete,
                color: Colors.grey[800],
                size: 20,
              ), 
              onPressed: null,
            ),
          ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ), 
      body:SingleChildScrollView(
        child: Column(
        children: [
          SearchSection(),
          Container(
        child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Les Clients',style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),),
                  Row(
                    children: [
                      Text('Filters',style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),),
                      IconButton(
                    onPressed: null,
                   icon: Icon(
                     Icons.filter_list_outlined,
                     color: d_green,
                   ),
                  )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children:[
                FutureBuilder<Client>(
            future: futureClient,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.clients.length,
                  itemBuilder: (context , index){
                    final item = snapshot.data?.clients[index]['nom'];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction){
                        snapshot.data?.clients.remove(snapshot.data?.clients[index]);
                        setState(() {
                          futureClient = fetchClient();
                        });
                      }, 
                      child: ListTile(
                        title: Column(
                          children: [
                            ListClient(snapshot.data?.clients[index]['nom'],snapshot.data?.clients[index]['prenom'],snapshot.data?.clients[index]['adresse'])
                          ],
                        ),
                      )
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
            ),
              ]
            ),
          ],
        ),
      ),
      ),
        ],
      ),
      ),
    );
  }
}
class SearchSection extends StatelessWidget {  


  List<String> filterdList = [];

  TextEditingController _textController = TextEditingController();
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
        height: 160,
        color: Colors.grey[300],
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0,3),
                        )
                      ],
                    ),
                    child: TextField(
                      controller: _textController,
                      onChanged: (text){
                        text = text.toLowerCase();
                      },
                      decoration: InputDecoration(
                        hintText: 'Nom',
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: Offset(0,4),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                    },
                    child: Icon(
                      Icons.search,
                      size: 25,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      primary: d_green,
                      padding: EdgeInsets.all(10)
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dernier Ajout', style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),),
                      SizedBox(height: 8,),
                      Text('12 Janv 2022',style: TextStyle(
                        color: Colors.black,
                        fontSize: 17
                      ),)
                    ],  
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dernière suppres',style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),),
                      SizedBox(height: 8,),
                      Text('12 Janv 2022', style: TextStyle(
                        color: Colors.black,
                        fontSize: 17
                      ),)
                    ],  
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
}
class ListClient extends StatelessWidget {

  final String nom;
  final String prenom;
  final String adresse;
  const ListClient(
    this.nom,
    this.prenom,
    this.adresse,
  );

  @override
  Widget build(BuildContext context) {
    return
        
        Container(
      margin: EdgeInsets.only(top: 10),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0,3),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(7))
      ),
      
      child: Row(
        children: [
            Container(
              margin: EdgeInsets.only(right: 10,left: 20),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Colors.cyan,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(nom +" "+ prenom ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    Container(
                       child: Text("Adresse : "+ adresse )
                    )
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 60),
              child: IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InfoClient()),
                  );
                },
                icon: Icon(Icons.navigate_next)
              ),
            )
        ],
      ),
    );
  }
}

