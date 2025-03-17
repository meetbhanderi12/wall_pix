import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/database/database_helper.dart';
import 'package:wallpaper/preview_page.dart';

import '../database/wallpaper_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoriteImageScreen extends StatefulWidget {
  const FavoriteImageScreen({super.key});

  @override
  State<FavoriteImageScreen> createState() => _FavoriteImageScreenState();
}

class _FavoriteImageScreenState extends State<FavoriteImageScreen> {

  ScrollController scrollController = ScrollController();
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchImageData();
  }
  Future<List<WallpaperModel>> fetchImageData(){
    return databaseHelper.fetchFavoriteImage();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: Colors.black,
   appBar: AppBar(
     backgroundColor: Colors.transparent,
     foregroundColor: Colors.white,
      title: const Row(
     mainAxisSize: MainAxisSize.min,
     children: [
       Text(
         "Favorite Picture",
         style:
         TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
       )
     ],
   ),

     elevation: 0,
   ),
   body: FutureBuilder(
       future: fetchImageData(),
       builder: (context, snapshot) {
         if(snapshot.connectionState == ConnectionState.done){
           if(snapshot.hasError) {
             return Center(child: Text("Has Error"),);
           }
           print("objectiffffffffffffff");
           return SingleChildScrollView(
               scrollDirection: Axis.vertical,
               child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               mainAxisSize: MainAxisSize.min,
               children: [
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 5),
                   child: MasonryGridView.count(
                     controller: scrollController,
                     itemCount: snapshot.data?.length,
                     // physics: BouncingScrollPh(),
                     scrollDirection: Axis.vertical,
                     shrinkWrap: true,
                     mainAxisSpacing: 5,
                     crossAxisSpacing: 5,
                     crossAxisCount: 2,
                     itemBuilder: (context, index) {
                       double height = (index % 10 + 1) * 100;
                       return GestureDetector(
                         onTap: () {

                           //interatial  ad


                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => PreviewPage(
                                 imageId: snapshot.data![index].id ?? 0,
                                 imageUrl: snapshot
                                     .data![index].imgUrl ?? "",
                               ),
                             ),
                           );
                         },
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: CachedNetworkImage(
                             fit: BoxFit.cover,
                             height: height > 300 ? 300 : height,
                             imageUrl:snapshot.data![index].imgUrl ?? "",
                             errorWidget: (context, url, error) =>
                             const Icon(Icons.error),
                           ),
                         ),
                       );
                     },
                   ),
                 ),
               /*  const SizedBox(height: 10),
                 GestureDetector(
                   onTap: () {
                     // pageNumber++;
                     // imagesList =
                     //     repo.getImagesList(pageNumber: pageNumber);
                     setState(() {});
                   },
                   child: Container(
                     width: double.infinity,
                     height: 50,
                     margin: EdgeInsets.only(left: 5, right: 5),
                     decoration: BoxDecoration(
                         color: Colors.white12,
                         borderRadius:
                         BorderRadius.all(Radius.circular(9))),
                     child: Center(
                       child: Text("Lode More",
                           style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.w500)),
                     ),
                   ),
                 ),
                 SizedBox(
                   height: 35,
                 )*/
               ],
                          ),
             );

         }
         else if(!snapshot.hasData) {
           return Center(child:
           Text(
             "data", style: TextStyle(fontSize: 50, color: Colors.black),),
           );
         }
         else{
           return Center();
         }

       },
   ),
    );
  }
}
