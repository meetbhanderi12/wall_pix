
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
 import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaper/database/database_helper.dart';
import 'package:wallpaper/database/wallpaper_model.dart';
import 'package:wallpaper/main.dart';
import 'package:wallpaper/main_page.dart';
import 'package:wallpaper/repo/repository.dart';
import 'modal/addmodel.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PreviewPage extends StatefulWidget {
  final String imageUrl;
  final int imageId;
  const PreviewPage({
    super.key,
    required this.imageId,
    required this.imageUrl,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  Repository repo = Repository();
  InterstitialAd? interstitialAd;
  late AddModel addModel;
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    addModel = context.read<AddModel>();
    addModel.initializaation.then((value) {
      loadInterstitialAd();
    });
    fetchData();
    super.initState();
  }
  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd(); // Load a new ad after the current one is dismissed
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          print("InterstitialAd failed to show: $error");
        },
      );
      interstitialAd!.show();
      interstitialAd = null; // Reset the ad after showing it
    } else {
      print("InterstitialAd is not ready yet.");
    }
  }
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: addModel.InterstitialId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            interstitialAd = null;
          });
          print("InterstitialAd failed to load: $error");
        },
      ),
    );
  }

  bool isFavorite = false;
  List<WallpaperModel>? wallData;
  fetchData()async{
    wallData = await databaseHelper.fetchFavoriteImage();
    for(int i = 0 ; i< wallData!.length;i++){

      if(wallData![i].id == widget.imageId){
        setState(() {
          isFavorite = true;
        });
      }

    }
  }

  Future<void> deleteData()async{
    await databaseHelper.deleteFavoriteImages(widget.imageId);
    print("Delete Data Successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:10.0),
            child: InkWell(
              onTap: () {
                if(isFavorite == false) {
                  WallpaperModel wallData = WallpaperModel(
                      id: widget.imageId,
                      name: "WallImage${widget.imageId}",
                      imgUrl: widget.imageUrl
                  );
                  databaseHelper.insertFavoriteImage(wallData);
                  setState(() {
                    isFavorite = true;
                    Fluttertoast.showToast(
                        msg: "Save wallpaper successfully",
                        toastLength: Toast.LENGTH_LONG

                    );
                  });
                }
                else if(isFavorite == true){
                  deleteData();
                  setState(() {
                    isFavorite = false;
                  });
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage(),), (route) => false,);

                }







              },
              child: Container(
                height: 50,
                  width: 50,
                  color: Colors.transparent,
                  child: Icon(isFavorite ? CupertinoIcons.heart_solid:CupertinoIcons.heart)),
            ),
          )
        ],
      ),
      body: CachedNetworkImage(
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        imageUrl: widget.imageUrl,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: const Color.fromRGBO(11, 89, 46,1),
              foregroundColor: const Color.fromRGBO(255, 255, 255, 10),
              // shape: const CircleBorder(),
              onPressed: () {



                showInterstitialAd();



                // bool istrue= await funForCkeckLogin();
                // if(istrue==false){
                //   return;
                // }
                repo.downloadImage(
                    imageUrl: widget.imageUrl,
                    imageId: widget.imageId,
                    context: context);

                AlertDialog  ssd= AlertDialog(
                  backgroundColor: Colors.transparent,
                  actions: [],
                  content: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // TextButton(onPressed: () async {
                          //
                          //   int location = WallpaperManager.HOME_SCREEN;
                          //   var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
                          //   bool result =
                          //   (await WallpaperManager.setWallpaperFromFile(file.path, location));
                          //   Navigator.pop(context);
                          //
                          //
                          // }, child: Text("Home Screen",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),)),
                          // Divider(color: Colors.black,),
                          // TextButton(onPressed: () async {
                          //
                          //   int location = WallpaperManager.LOCK_SCREEN;
                          //   var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
                          //   bool result =
                          //   (await WallpaperManager.setWallpaperFromFile(file.path, location));
                          //   Navigator.pop(context);
                          //
                          //
                          // }, child: Text("Lock Screen",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),)),
                          // Divider(color: Colors.black,),
                          TextButton(onPressed: () async {

                            // int location = WallpaperManager.BOTH_SCREEN;
                            // var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
                            // bool result =
                            // (await WallpaperManager.setWallpaperFromFile(file.path, location));
                            // Navigator.pop(context);


                          }, child: Text("The Picture is Downloaded to Your Gallary",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),)),
                          Divider(color: Colors.black,),

                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: Text("Ok",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),))
                        ],
                      ),
                    ),
                  ),
                );
                showDialog(context: context, builder: (context) => ssd,);

                // final msg=SnackBar(content: Text("Saved To Gallary"),backgroundColor: Colors.red,);
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: msg,));
              },
              child: const Icon(Icons.save),
            ),
            SizedBox(width: 9,),
            FloatingActionButton(
              backgroundColor: const Color.fromRGBO(228, 90, 0,1),
              foregroundColor: const Color.fromRGBO(255, 255, 255, 10),
              // shape: const CircleBorder(),
              onPressed: ()  {
                showInterstitialAd();

                // bool istrue= await funForCkeckLogin();
                // if(istrue==false){
                //   return;
                // }
                AlertDialog  ssd= AlertDialog(
                  backgroundColor: Colors.transparent,
                  actions: [],
                  content: Container(
                    height: 256,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextButton(onPressed: () async {

                            // int location = WallpaperManager.HOME_SCREEN;
                            // var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
                            // bool result =
                            // (await WallpaperManager.setWallpaperFromFile(file.path, location));
                            // Navigator.pop(context);
                            //

                          }, child: Text("Home Screen",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),)),
                          Divider(color: Colors.black,),
                          TextButton(onPressed: () async {
                            //
                            // int location = WallpaperManager.LOCK_SCREEN;
                            // var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
                            // bool result =
                            // (await WallpaperManager.setWallpaperFromFile(file.path, location));
                            // Navigator.pop(context);


                          }, child: Text("Lock Screen",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),)),
                          Divider(color: Colors.black,),
                          TextButton(onPressed: () async {

                            // int location = WallpaperManager.BOTH_SCREEN;
                            // var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
                            // bool result =
                            // (await WallpaperManager.setWallpaperFromFile(file.path, location));
                            // Navigator.pop(context);


                          }, child: Text("Home & Lock Both",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),)),
                          Divider(color: Colors.black,),

                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: Text("Cancel",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),))
                        ],
                      ),
                    ),
                  ),
                );
                showDialog(context: context, builder: (context) => ssd,);



                // int location = WallpaperManager.BOTH_SCREEN;
                // var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
                // String result =
                // (await WallpaperManager.setWallpaperFromFile(file.path, location))
                // as String;

              },
              child: const Icon(Icons.settings_applications,),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  // Future<bool> funForCkeckLogin()async{
  //   sp=await SharedPreferences.getInstance();
  //   bool isGoogleLogin= sp.getBool("IsGooglelogdIn")??false;
  //   if(isGoogleLogin){
  //     return true;
  //   }
  //
  //   isGuestAvaliable=false;
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPageForMail(),));
  //   return false;
  // }
}

//appid
//ca-app-pub-3512709996463712~6480107504
//ca-app-pub-3512709996463712~6480107504

//Banner Ad
//ca-app-pub-3512709996463712/3722583230


//instrial ad
//ca-app-pub-3512709996463712/8945955912



//dd
//ca-app-pub-3512709996463712/2764724788