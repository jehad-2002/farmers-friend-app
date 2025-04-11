import 'package:farmersfriendapp/core/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:farmersfriendapp/core/models/category.dart';
import 'package:farmersfriendapp/core/models/crop.dart';

class DatabaseTables {
  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE Users (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          Name TEXT NOT NULL,
          DateOfBirth TEXT,
          AccountStatus INTEGER NOT NULL,
          Address TEXT,
          AccountType INTEGER NOT NULL,
          ProfileImage TEXT,
          Username TEXT UNIQUE NOT NULL,
          Password TEXT NOT NULL,
          PhoneNumber TEXT UNIQUE NOT NULL,
          CreatedAt TEXT DEFAULT (datetime('now')),
          UpdatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Categories (
          CategoryID INTEGER PRIMARY KEY AUTOINCREMENT,
          CategoryName TEXT NOT NULL,
          CategoryDescription TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Crops (
          CropID INTEGER PRIMARY KEY AUTOINCREMENT,
          CropName TEXT NOT NULL,
          CropDescription TEXT,
          CropImage TEXT,
          CategoryID INTEGER NOT NULL,
          FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
      )
    ''');

    await db.execute('''
      CREATE TABLE Products (
          ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
          UserID INTEGER NOT NULL,
          Title TEXT NOT NULL,
          Description TEXT,
          Price REAL NOT NULL,
          DateAdded TEXT DEFAULT (datetime('now')),
          CropID INTEGER NOT NULL,
          FOREIGN KEY (UserID) REFERENCES Users(ID),
          FOREIGN KEY (CropID) REFERENCES Crops(CropID)
      )
    ''');

    await db.execute('''
      CREATE TABLE ProductImages (
          ImageID INTEGER PRIMARY KEY AUTOINCREMENT,
          ImagePath TEXT NOT NULL,
          ProductID INTEGER NOT NULL,
          FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
      )
    ''');

    await db.execute('''
      CREATE TABLE Evaluations (
          EvaluationID INTEGER PRIMARY KEY AUTOINCREMENT,
          Rating INTEGER,
          Comment TEXT,
          ProductID INTEGER NOT NULL,
          UserID INTEGER NOT NULL,
          FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
          FOREIGN KEY (UserID) REFERENCES Users(ID)
      )
    ''');

    await db.execute('''
      CREATE TABLE AgriculturalGuidelines (
          GuidanceID INTEGER PRIMARY KEY AUTOINCREMENT,
          UserID INTEGER NOT NULL,
          CropID INTEGER NOT NULL,
          Title TEXT NOT NULL,
          GuidanceText TEXT NOT NULL,
          PublicationDate TEXT DEFAULT (datetime('now')),
          FOREIGN KEY (UserID) REFERENCES Users(ID),
          FOREIGN KEY (CropID) REFERENCES Crops(CropID)
      )
    ''');

    await db.execute('''
      CREATE TABLE GuidelineImages (
        ImageGuidelineID INTEGER PRIMARY KEY AUTOINCREMENT,
        ImagePath TEXT NOT NULL,
        GuidanceID INTEGER NOT NULL,
        FOREIGN KEY (GuidanceID) REFERENCES AgriculturalGuidelines(GuidanceID)
      )
    ''');

    await _insertInitialData(db);
  }

  static Future<void> _insertInitialData(Database db) async {
    for (var category in categoryList) {
      await db.insert('Categories', category.toMap());
    }

    for (var users in user) {
      await db.insert('Users', users.toMap());
    }
    for (var crop in cropList) {
      await db.insert('Crops', crop.toMap());
    }
  }
}

List<Category> categoryList = [
  Category(
    categoryName: "فواكه",
    categoryDescription:
        "ثمار نباتية صالحة للأكل، تتميز بتنوعها الكبير في الألوان والأشكال والنكهات، وغالبًا ما تكون حلوة أو حامضة.",
  ),
  Category(
    categoryName: "بقوليات",
    categoryDescription:
        "بذور نباتات تنتمي إلى عائلة البقوليات، وتتميز بغناها بالبروتين النباتي عالي الجودة والألياف الغذائية.",
  ),
  Category(
    categoryName: "حبوب",
    categoryDescription:
        "بذور نباتات تنتمي إلى عائلة النجيليات، وتعتبر مصدرًا رئيسيًا للكربوهيدرات والطاقة للإنسان والحيوان.",
  ),
  Category(
    categoryName: "مكسرات",
    categoryDescription:
        "بذور نباتات ذات قشرة صلبة، وتتميز بغناها بالدهون الصحية غير المشبعة والبروتين والألياف الغذائية والفيتامينات والمعادن.",
  ),
  Category(
    categoryName: "توابل",
    categoryDescription:
        "أجزاء نباتية مجففة (مثل البذور أو الثمار أو الأوراق أو الجذور) تستخدم لإضافة نكهة ورائحة للطعام.",
  ),
  Category(
    categoryName: "محاصيل زيتية",
    categoryDescription:
        "نباتات تزرع لاستخراج الزيوت النباتية من بذورها أو ثمارها.",
  ),
  Category(
    categoryName: "محاصيل صناعية",
    categoryDescription:
        "نباتات تزرع لأغراض صناعية، مثل إنتاج الألياف أو المواد الكيميائية أو الوقود الحيوي.",
  ),
  Category(
    categoryName: "مشروبات",
    categoryDescription:
        "نباتات تزرع لاستخراج مواد تستخدم في صنع المشروبات، مثل الشاي والقهوة.",
  ),
  Category(
    categoryName: "أشجار",
    categoryDescription:
        "نباتات خشبية معمرة تنتج ثمارًا أو مواد أخرى ذات قيمة اقتصادية، مثل الأخشاب أو الزيوت أو الراتنجات.",
  ),
];
List<Crop> cropList = [
  Crop(
    cropName: "ليمون",
    cropDescription:
        "فاكهة حمضية صفراء اللون ذات نكهة منعشة وحمضية، غنية بفيتامين سي.",
    cropImage: "assets/images/crops/Lemon.jpeg",
    categoryId: 1,
  ),
  Crop(
    cropName: "جوز الهند",
    cropDescription:
        "فاكهة استوائية ذات قشرة صلبة ولُب أبيض غني بالدهون الصحية.",
    cropImage: "assets/images/crops/coconut.jpg",
    categoryId: 1,
  ),
  Crop(
    cropName: "بابايا",
    cropDescription:
        "فاكهة استوائية برتقالية اللون ذات نكهة حلوة ولُب ناعم، غنية بالفيتامينات والمعادن والألياف.",
    cropImage: "assets/images/crops/papaya.jpg",
    categoryId: 1,
  ),
  Crop(
    cropName: "حمص",
    cropDescription:
        "بقوليات صغيرة مستديرة بنية اللون، غنية بالبروتين والألياف.",
    cropImage: "assets/images/crops/gram.jpg",
    categoryId: 2,
  ),
  Crop(
    cropName: "أناناس",
    cropDescription:
        "فاكهة استوائية ذات قشرة خارجية خشنة ولُب أصفر حلو وحمضي، غنية بالفيتامينات والمعادن.",
    cropImage: "assets/images/crops/pineapple.jpg",
    categoryId: 1,
  ),
  Crop(
    cropId: 6,
    cropName: "ذرة بيضاء",
    cropDescription: "نوع من الحبوب الكاملة، غني بالألياف والبروتين.",
    cropImage: "assets/images/crops/jowar.jpeg",
    categoryId: 3,
  ),
  Crop(
    cropName: "لوز",
    cropDescription:
        "مكسرات ذات قشرة صلبة بنية اللون ولُب أبيض غني بالدهون الصحية والبروتين.",
    cropImage: "assets/images/crops/almond.png",
    categoryId: 4,
  ),
  Crop(
    cropName: "مونج (ماش)",
    cropDescription: "بقوليات خضراء صغيرة، غنية بالبروتين والألياف.",
    cropImage: "assets/images/crops/vigna-radiati(Mung).jpg",
    categoryId: 2,
  ),
  Crop(
    cropName: "فول الصويا",
    cropDescription: "بقوليات صفراء اللون، غنية بالبروتين النباتي عالي الجودة.",
    cropImage: "assets/images/crops/soyabean.jpeg",
    categoryId: 2,
  ),
  Crop(
    cropName: "دخن لؤلؤي (باجرا)",
    cropDescription: "نوع من الحبوب الكاملة، غني بالألياف والبروتين.",
    cropImage: "assets/images/crops/Pearl_millet(bajra).jpg",
    categoryId: 3,
  ),
  Crop(
    cropName: "نبات البن",
    cropDescription:
        "شجيرة استوائية تنتج حبوب البن، التي تستخدم في إعداد مشروب القهوة المنبه.",
    cropImage: "assets/images/crops/Coffee-plant.jpg",
    categoryId: 8,
  ),
  Crop(
    cropName: "قمح",
    cropDescription:
        "حبوب تستخدم لصنع الخبز والمعكرونة والحبوب الغذائية والعديد من المنتجات الأخرى.",
    cropImage: "assets/images/crops/wheat.jpg",
    categoryId: 3,
  ),
  Crop(
    cropName: "شاي",
    cropDescription:
        "أوراق نبات تستخدم لصنع مشروب الشاي المنبه، الذي يتميز بتنوعه الكبير في الأنواع والنكهات.",
    cropImage: "assets/images/crops/tea.jpeg",
    categoryId: 8,
  ),
  Crop(
    cropName: "قرنفل",
    cropDescription:
        "براعم زهرية مجففة تستخدم كتوابل، تتميز بنكهتها الحارة والدافئة.",
    cropImage: "assets/images/crops/clove.jpeg",
    categoryId: 5,
  ),
  Crop(
    cropName: "طماطم",
    cropDescription: "فاكهة حمراء تستخدم كخضروات، غنية بالفيتامينات والمعادن.",
    cropImage: "assets/images/crops/tomato.jpeg",
    categoryId: 1,
  ),
  Crop(
    cropName: "ذرة",
    cropDescription: "حبوب صفراء اللون، غنية بالكربوهيدرات والألياف.",
    cropImage: "assets/images/crops/maize.jpg",
    categoryId: 3,
  ),
  Crop(
    cropName: "عباد الشمس",
    cropDescription:
        "نبات ذو زهرة صفراء كبيرة، تستخدم بذوره في إعداد الزيوت النباتية والوجبات الخفيفة.",
    cropImage: "assets/images/crops/sunflower.jpg",
    categoryId: 6,
  ),
  Crop(
    cropName: "موز",
    cropDescription: "فاكهة صفراء منحنية الشكل، غنية بالبوتاسيوم والألياف.",
    cropImage: "assets/images/crops/banana.jpg",
    categoryId: 1,
  ),
  Crop(
    cropName: "جوت",
    cropDescription:
        "ألياف نباتية تستخدم لصنع الحبال والأكياس والمنسوجات الأخرى.",
    cropImage: "assets/images/crops/jute.jpg",
    categoryId: 7,
  ),
  Crop(
      cropName: "شجرة زيتون",
      cropDescription:
          "شجرة معمرة تنتج ثمار الزيتون، التي تستخدم في إعداد زيت الزيتون والمخللات.",
      cropImage: 'assets/images/crops/Olive-tree.jpg',
      categoryId: 9),
  Crop(
    cropName: "فلفل حار",
    cropDescription:
        "فاكهة حارة تستخدم كتوابل، تتميز بتنوعها الكبير في الأنواع والنكهات.",
    cropImage: "assets/images/crops/chilli.jpeg",
    categoryId: 5,
  ),
  Crop(
    cropName: "نبات التبغ",
    cropDescription: "نبات تستخدم أوراقه لصنع السجائر ومنتجات التبغ الأخرى.",
    cropImage: "assets/images/crops/Tobacco-plant.jpg",
    categoryId: 7,
  ),
  Crop(
    cropName: "قطن",
    cropDescription: "ألياف نباتية تستخدم لصنع الملابس والمنسوجات الأخرى.",
    cropImage: "assets/images/crops/cotton.jpg",
    categoryId: 7,
  ),
  Crop(
    cropName: "هيل",
    cropDescription: "بذور عطرية تستخدم كتوابل، تتميز بنكهتها الدافئة والحلوة.",
    cropImage: "assets/images/crops/cardamom.jpeg",
    categoryId: 5,
  ),
  Crop(
    cropName: "أرز",
    cropDescription:
        "حبوب بيضاء اللون، غنية بالكربوهيدرات، تستخدم كغذاء أساسي في العديد من البلدان.",
    cropImage: "assets/images/crops/rice.png",
    categoryId: 3,
  ),
  Crop(
    cropName: "زيت الخردل",
    cropDescription:
        "زيت نباتي يستخرج من بذور الخردل، يستخدم في الطهي والتدليك.",
    cropImage: "assets/images/crops/mustard-oil.jpg",
    categoryId: 6,
  ),
  Crop(
    cropName: "كرز",
    cropDescription:
        "فاكهة حمراء صغيرة ذات نكهة حلوة وحمضية، غنية بالفيتامينات والمعادن.",
    cropImage: "assets/images/crops/Cherry.jpg",
    categoryId: 1,
  ),
  Crop(
    cropName: "قصب السكر",
    cropDescription:
        "نبات يستخدم لاستخراج السكر، الذي يستخدم في العديد من الصناعات الغذائية.",
    cropImage: "assets/images/crops/sugarcane.jpg",
    categoryId: 7,
  ),
  Crop(
    cropName: "خيار",
    cropDescription:
        "خضروات خضراء طويلة ذات نكهة منعشة، غنية بالماء والفيتامينات.",
    cropImage: "assets/images/crops/Cucumber.jpg",
    categoryId: 1,
  ),
  Crop(
    cropName: "جوز الثعلب (ماخانا)",
    cropDescription:
        "بذور نباتية تستخدم كوجبة خفيفة، غنية بالكربوهيدرات والألياف.",
    cropImage: "assets/images/crops/Fox_nut(Makhana).jpeg",
    categoryId: 4,
  ),
];

List<User> user = [
  User(
    name: 'Jehad AlWahid',
    accountStatus: 1,
    accountType: 3,
    username: 'jehad2002',
    password: '123456',
    phoneNumber: '773818200',
    address: "",
    createdAt: '2025-27-3',
    dateOfBirth: "2002-8-12",
  ),
  User(
    name: 'Jehad AlWahid',
    accountStatus: 1,
    accountType: 3,
    username: '123456789',
    password: '123456789',
    phoneNumber: '123456789',
    address: "",
    createdAt: '2025-27-3',
    dateOfBirth: "2002-8-12",
  ),
];
