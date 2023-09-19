import 'dart:convert';




import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String url = "https://www.pqstec.com/InvoiceApps";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var data;
  Future<void> getProductApi()  async
  {
    final response = await http.get(Uri.parse(
        'https://www.pqstec.com/InvoiceApps/Values/GetProductList?pageNo=1&pageSize=100&searchquery=boys'),
      headers: {
        'Authorization': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiI0MTMiLCJDdXJyZW50Q29tSWQiOiIxIiwibmJmIjoxNjk0ODQ0MTg2LCJleHAiOjE2OTU0NDg5ODYsImlhdCI6MTY5NDg0NDE4Nn0.VKZ3-Nj1xKqvFSVaLPKCxbplFxW374hTwdKtd6aah_o',
        'Content-Type': 'application/json',
        // Optional: Set the content type if needed
      },


    );



    if(response.statusCode==200)
    {

      data= jsonDecode(response.body.toString());
      print(data);
      print(data['ProductList'][1]['Name']);
      print(data.toString().length);


    }

    else
    {


      print("failure");

    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appbar"),),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(
              future: getProductApi(),
              builder: (context,snapshot)
              {
                if(snapshot.connectionState==ConnectionState.waiting)
                {

                  return Text("Loading");
                }
                else {
                  //return Text(data['ProductList'][0]['Name']);
                  return ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context,index){
                        return Container(

                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name: "+data['ProductList'][index]['Name']),
                              SizedBox(height: 10,),
                              Text("Size: "+data['ProductList'][index]['VariantName']),
                              SizedBox(height: 10,),
                              Text("Code: "+data['ProductList'][index]['Code']),

                              FadeInImage(
                                image:NetworkImage(url+data['ProductList'][index]['ImagePath'].toString()),
                                placeholder: const AssetImage("assets/img.png"),
                                imageErrorBuilder:(context, error, stackTrace) {
                                  return Image.network('https://cdni.iconscout.com/illustration/premium/thumb/no-data-found-8867280-7265556.png',
                                      fit: BoxFit.fitWidth
                                  );
                                },
                                fit: BoxFit.fitWidth,
                              ),

                              SizedBox(height: 30,),
                            ],
                          ),
                        );
                      });
                }

              })
          )
        ],
      ),

    );
  }
}

