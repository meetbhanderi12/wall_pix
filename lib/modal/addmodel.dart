import 'package:google_mobile_ads/google_mobile_ads.dart';

class AddModel{
  Future<InitializationStatus> initializaation;

  AddModel({required this.initializaation});

  // final String banners="ca-app-pub-3512709996463712/2314616920";
  // final String Interstitial="ca-app-pub-3512709996463712/8832494632";
  // final String Rewarded ="ca-app-pub-3512709996463712/6206331298";




  String get bannreAdUnitId=>"ca-app-pub-3940256099942544/6300978111";
  String get InterstitialId=>"ca-app-pub-3512709996463712/2764724788";
  // String get RewardedId=>"ca-app-pub-3940256099942544/5224354917";


  BannerAdListener get adListner=>adListener;

  BannerAdListener adListener=BannerAdListener(
    onAdLoaded: (ad) => print("ad Loaded:${ad.adUnitId}"),
    onAdClicked: (ad) => print("ad Clicked${ad.adUnitId}"),
    onAdClosed: (ad) => print("ad Clicked${ad.adUnitId}"),
  );

}