import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService{
  static Future getData() async{
    var client = http.Client();
    var uri=Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=500&offset=0");
    var response= await client.get(uri);
    final poke_Data =await jsonDecode(response.body)['results'];
    return poke_Data;
  }

  static Future getPokemonData(int id) async{
     var client = http.Client();
    var uri=Uri.parse("https://pokeapi.co/api/v2/pokemon/$id");
    var response= await client.get(uri);
    final poke_Data =await jsonDecode(response.body);
    return poke_Data;
  }
}