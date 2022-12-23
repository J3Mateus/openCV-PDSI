import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_cv/src/core/utils/filter.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final picker  = ImagePicker();
  File? file  ;
  Image? image ;

  List<FilterData> filters=[
    FilterData(name: "Hot", function: FilterUtils.applyHot),
    FilterData(name: "Ocean", function: FilterUtils.applyOcean),
    FilterData(name: "2D", function: FilterUtils.applyFilter2D),
    FilterData(name: "Linhas", function: FilterUtils.applyLines),
    FilterData(name: "Twilight", function: FilterUtils.applyTwilight),
    FilterData(name: "Preto/Branco", function: FilterUtils.applyThreshold),
  ];

  getImageApi() async {
    var url = Uri.https("https://api.lorem.space/image/face?w=450&h=450");
    print(url);
    var response = await http.get(url);
    if(response.statusCode ==200){
      print(response.request?.url);
    }
  }


  getImagePicker() async {

   var pickedfile = await  picker.pickImage(source: ImageSource.gallery,);
   String? path ;
   path = pickedfile?.path;
   var tempFile = File(path!);
   setState(() {
      file = tempFile;
      image = Image.file(file!);
   });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text("Retrica 2.0"),
        backgroundColor:  Colors.grey[850]
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey[850] ,
              width: double.infinity  ,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(  onPressed: getImagePicker,icon: const Icon(Icons.photo_library_outlined), label:const Text("Adicionar")),
                  const SizedBox(width: 20,),
                  ElevatedButton.icon( onPressed: getImageApi,icon: const Icon(Icons.photo_camera), label:const Text("Retirar")),
                  const SizedBox(width: 20,),
                  ElevatedButton.icon( onPressed: ()=>{},icon: const Icon(Icons.satellite), label:const Text("Buscar")),
                  const SizedBox(width: 20,),
          ],
              ),
            ),
            Expanded(child:
              Container(
                alignment: Alignment.center,
                color:  Colors.grey[850] ,
                width: double.infinity  ,
                height: 90,
                child: image,
              ),),
            Container(
              color: Colors.grey[850] ,
              width: double.infinity  ,
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding:const EdgeInsets.all(10.0),
                children: filters.map((filtro) {
                  return GestureDetector(
                    onTap:() async{
                      if(file==null) return;
                      var res = await filtro.function(file!);
                      setState(() {
                        image = res ;
                      });
                    },
                    child:  Container(
                        height: 80,
                        width: 90,
                        margin: const EdgeInsets.only(right: 7.0),
                        decoration: BoxDecoration(
                            border: Border.all(color:Colors.white)
                        ),
                        child: Center(child:Text(filtro.name!,style: const TextStyle(color:Colors.white),))),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      )
    );
  }

}
