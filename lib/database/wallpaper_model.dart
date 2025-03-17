import 'dart:typed_data';


class WallpaperModel{

  final int? id;
  final String? imgUrl ;
  final String? name ;


  WallpaperModel({
    this.name,
    this.imgUrl,
    this.id
});

  factory WallpaperModel.fromJson(Map<String , dynamic> json){
    return WallpaperModel(
      id: json['id'],
      imgUrl: json['imgUrl'],
      name: json['name']

    );
  }


  Map<String , dynamic > toMap(){
    return {
      'id' : id,
      'imgUrl': imgUrl,
      'name':name
    };

  }


}


Uint8List convertToUint8List(List<int> bytes){
  return Uint8List.fromList(bytes);
}