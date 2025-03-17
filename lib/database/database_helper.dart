import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallpaper/database/wallpaper_model.dart';

class DatabaseHelper {

  final String dbName = "wall_pix";
  final String tbName = "save_wallpaper";
  final String id = "id";
  final String imgUrl = "imgUrl";
  final String name = "name";



  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;

  }
  Future<Database> _initDatabase()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath ,dbName );
    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate
    );
  }




  Future<void>  _onCreate(Database db , int version)async{

    await  db.execute(
        '''
       CREATE TABLE $tbName(
       $id INTEGER PRIMARY KEY ,
       $imgUrl TEXT ,
       $name TEXT
       ) 
       '''
    );
    print("Database Create successfully");

  }

  Future<int> insertFavoriteImage (WallpaperModel wall)async{
    Database db  = await instance.database;
    print("imahe hh ---> ${wall.imgUrl}");
    return await db.insert(tbName, wall.toMap());
  }

  Future<List<WallpaperModel>> fetchFavoriteImage()async{
    Database db = await instance.database;
    final List<Map<String , dynamic>> wall = await db.query(tbName);
    return wall.map((e) => WallpaperModel.fromJson(e),).toList();

  }

  Future<int> deleteFavoriteImages(int imageId)async{
    Database db = await instance.database;
    return db.delete(tbName , where: 'id = ?' , whereArgs: [imageId] );
  }


}