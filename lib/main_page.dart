import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper/modal/modal.dart';
import 'package:wallpaper/preview_page.dart';
import 'package:wallpaper/repo/colors.dart';
import 'package:wallpaper/repo/repository.dart';
import 'package:wallpaper/screens/favorite_image_screen.dart';

import 'login_page.dart';
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

 Future<void> sendMessage(String message,String email)async{
String time=DateTime.now().millisecondsSinceEpoch.toString();
print("${userDetails?.email.toString()}"+"dfsdjkfnaosihoasijfdnffdnv");
final ref=firebaseFirestore.collection("${userDetails?.email.toString()}");
await ref.doc(time).set({"$email":"$message"});
}

bool isThereIsAd=false;
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Repository repo = Repository();
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  late Future<List<Images>> imagesList;
  int pageNumber = 1;
  final List<String> categories = [
    'Nature',
    'Abstract',
    'Technology',
    'Mountains',
    'Cars',
    'Bikes',
    'People',
  ];
  final listForImg=[
    "https://images.pexels.com/photos/28826546/pexels-photo-28826546.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
    "https://images.pexels.com/photos/28775008/pexels-photo-28775008.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
    "https://images.pexels.com/photos/28683066/pexels-photo-28683066.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
    "https://images.pexels.com/photos/28821822/pexels-photo-28821822.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
    "https://www.pixelstalk.net/wp-content/uploads/2016/06/Pictures-Download-HD-Car-Wallpapers.jpg",
    "https://wallpaperaccess.com/full/226908.jpg",
    "https://images.pexels.com/photos/28839821/pexels-photo-28839821.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
    "https://images.pexels.com/photos/28200075/pexels-photo-28200075.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
  ];
  List<bool> forTheAni = List.generate(
    7,
    (ind) => false,
  );

  void getImagesBySearch({required String query}) {
    imagesList = repo.getImagesBySearch(query: query);
    setState(() {});
  }
  void sendMessageOnline()async{
    sp=await SharedPreferences.getInstance();
    String email=sp.getString("gmail")??"UnKnown";
    if(sp.getBool("IsGooglelogdIn")??false){
      String time="";
      time=DateTime.now().day.toString()+":";
      time=time+DateTime.now().month.toString()+":";
      time=time+DateTime.now().year.toString()+":"+DateTime.now().toString();
      print(time);
      sendMessage(time,email);
    }
    print("objectfdsfdfdfgffg");
    return;
  }

  @override
  void initState() {
    imagesList = repo.getImagesList(pageNumber: pageNumber);
    sendMessageOnline();

    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () async{
      //   var r=await FirebaseMessaging.instance.getToken();
      //   print(r);
      //   print("oko");
      // },),
      backgroundColor: ColorConstant.cwGradient2,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        // centerTitle: true,
        toolbarHeight: 70,
        actions: [
           InkWell(
             onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteImageScreen(),));
             },
             child: Padding(
               padding: const EdgeInsets.all(10.0),
               child: Container(
                 height: 40,
                   width: 40,
                   alignment: Alignment.center,
                   decoration: BoxDecoration(
                     color: Colors.red,
                     shape: BoxShape.circle
                   ),
                   child: Icon(CupertinoIcons.heart_circle_fill , color: Colors.white,size: 30,)),
             ),
           )
        ],
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Wall Pix",
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                cursorColor: Colors.black,
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Get Wallpaper By Text",
                  fillColor: Colors.white,
                  hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                  filled: true,
                  contentPadding: const EdgeInsets.only(left: 25),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: IconButton(
                      onPressed: () {
                        getImagesBySearch(query: textEditingController.text);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-Z0-9]'),
                  ),
                ],
                onSubmitted: (value) {
                  getImagesBySearch(query: value);
                },
              ),
            ),
            // if(isThereIsAd)
              SizedBox(
              height: 70,
              child: BannerAdWidget(),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        forTheAni = List.generate(
                          categories.length,
                          (ind) => false,
                        );
                        forTheAni[index] = true;
                        setState(() {});
                        getImagesBySearch(query: categories[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(listForImg[index],),
                              fit: BoxFit.fill
                            ),
                            color: forTheAni[index]
                                ? Colors.white24
                                : Colors.white12,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            child: Center(
                              child: Text(
                                categories[index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: imagesList,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: MasonryGridView.count(
                          controller: scrollController,
                          itemCount: snapshot.data?.length,
                          shrinkWrap: true,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            double height = (index % 10 + 1) * 100;
                            // print("Image NBAme ----> ${snapshot.data![index].imagePotraitPath}");
                            return GestureDetector(
                              onTap: () {

                                //interatial  ad


                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PreviewPage(
                                      imageId: snapshot.data![index].imageID,
                                      imageUrl: snapshot
                                          .data![index].imagePotraitPath,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: height > 300 ? 300 : height,
                                  imageUrl:
                                      snapshot.data![index].imagePotraitPath,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          pageNumber++;
                          imagesList =
                              repo.getImagesList(pageNumber: pageNumber);
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
                      )
                    ],
                  );
                } else {
                  return MasonryGridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: EdgeInsets.all(10),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.white12,
                        highlightColor: Colors.white24,
                        child: Container(
                          height: (index + 1) *
                              100.0, // Varying height for masonry effect
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      );
                    },
                  );
                }
              }),
            ),

          ],
        ),
      ),
    );
  }
}

 // https://images.pexels.com/photos/28826546/pexels-photo-28826546.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800
class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId:
      'ca-app-pub-3512709996463712/4684254614',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            print("dgkijjsdogmsdlkfmsdlkvm");
            isThereIsAd=true;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
          setState(() {
            print("5468465461341");
            isThereIsAd=false;
            _isAdLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? Container(
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
    )
        : Text('');
  }
}
