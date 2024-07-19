import 'package:http/http.dart' as http;

class ApiService{
  static Future getData() async{
    var client = await http.Client();
    var uri=Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=50&offset=0");
    var response= await client.get(uri);
    print(response.body);
  }
}