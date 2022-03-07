import 'package:barber_app/core.dart';

class MainDummyApi implements DummyApi {
  String firestorePrefix = "bs_";
  AppConfig appConfig;
  MainDummyApi() {
    appConfig = AppConfig(
      defaultThemeIndex: 1,
      loginBackground: "https://i.ibb.co/MMHvgZ4/bg.jpg",
      logo: "https://i.ibb.co/8DBn9YD/logo-black.png",
      searchCoverBackground: "https://i.ibb.co/sp4f1zd/beard-cover.jpg",
      orderButtonText: "Book Now",
      vendorString: "Barber Shop",
      staffString: "Barber",
      productString: "Services",
      fieldConfig: {
        "execution_time": {
          "enabled": true,
        },
        "gender": {
          "enabled": false,
        },
      },
      collectionNames: CollectionNames(
        adminCollection: firestorePrefix + "admin",
        adminSettingCollection: firestorePrefix + "admin_setting",
        vendorCollection: firestorePrefix + "vendor",
        bookingCollection: firestorePrefix + "booking",
        bookingListCollection: firestorePrefix + "booking_list",
        userDataCollection: firestorePrefix + "user_data",
        chatCollection: firestorePrefix + "chat",
        chatListCollection: firestorePrefix + "chat_list",
        ratingCollection: firestorePrefix + "rating",
        userRatingCollection: firestorePrefix + "user_rating",
      ),
      useAlternativeLogin: false,
      appDictionary: AppDictionary.base(),
      multipleProducts: false,
      linkProductToStaff: false,
      setDuration: false,
    );
  }

  Map<String, dynamic> onGenerateSingleDummy() {
    return {
      "vendor_name": AppSession.dummyApi.vendorNames.random(),
      "address": "Dallas, 4426  Ersel Street, Texas",
      "photo_url": AppSession.dummyApi.photos.random(),
      "latitude": 44.08476666029554,
      "longitude": 70.22286432261072,
      "phone": "+62821884488864",
      "website": "https://codekaze.com/",
      "products": AppSession.dummyApi.products,
      "galleries": AppSession.dummyApi.galleries,
      "reviews": AppSession.dummyApi.reviews,
      "rate": 0.0,
      "rate_count": 0,
      "about_us":
          "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.",
      "status": AppSession.isAdmin ? "Approved" : "Pending",
    };
  }

  List<Map<String, dynamic>> vendors = [
    {
      "vendor_name": "Empire Cuts",
      "address": "Dallas, 4426  Ersel Street, Texas",
      "photo_url": "https://i.ibb.co/fqTRCMN/b0.jpg",
      "latitude": 44.08476666029554,
      "longitude": 70.22286432261072,
      "phone": "+62821884488864",
      "website": "https://codekaze.com/",
      "rate": 4.0,
      "rate_count": 5,
      "about_us":
          "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.",
      "status": "Approved"
    },
    {
      "vendor_name": "Fellow Barber",
      "address": "Dallas, 4416  Ersel Street, Texas",
      "photo_url": "https://i.ibb.co/MMfBj6B/b1.jpg",
      "latitude": 44.08476666029554,
      "longitude": 70.22286432261072,
      "phone": "+62821884488334",
      "website": "https://codekaze.com/",
      "rate": 4.0,
      "rate_count": 5,
      "about_us":
          "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.",
      "status": "Approved"
    },
    {
      "vendor_name": "The Classic Cut",
      "address": "Dallas, 3256  Ersel Street, Texas",
      "photo_url": "https://i.ibb.co/PN6Gkv2/b2.jpg",
      "latitude": 44.08476666029554,
      "longitude": 70.22286432261072,
      "phone": "+63821884656564",
      "website": "https://codekaze.com/",
      "rate": 5.0,
      "rate_count": 5,
      "about_us":
          "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.",
      "status": "Approved"
    },
    {
      "vendor_name": "Gentlemen's Grooming",
      "address": "Dallas, 6626  Ersel Street, Texas",
      "photo_url": "https://i.ibb.co/GFbRSZS/b4.jpg",
      "latitude": 44.08476666029554,
      "longitude": 70.22286432261072,
      "phone": "+67821884100200",
      "website": "https://codekaze.com/",
      "rate": 2.0,
      "rate_count": 5,
      "about_us":
          "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.",
      "status": "Approved"
    },
  ];

  List vendorNames = [
    "Butch",
    "Mohican",
    "Dapper",
    "Lionico",
    "Game Day Barber",
    "Straight Razors",
    "Muscle Cuts",
    "Bulls & Barbers",
    "Rebel Rebel",
    "Rusty Blade",
    "Dark Barber",
    "Hi-Rollers Barber",
    "The Fade Shop",
    "Illicit Barbering (not legally permitted)",
    "Razor King",
    "Razor Cuts",
    "Lads Lounge",
    "Sideburns",
    "Urban Shave",
    "Backyard Barbers",
    "Silver Bullet Barbers",
    "Baseline Barbers",
    "Empire Cuts",
    "Barber Bomb",
    "Mug & Brush",
    "The Legend Room",
    "The Barber",
    "Dope Barber",
    "Bolt Barbers",
    "The Loft",
    "Barber Loco",
    "Comb Club",
    "Lucky Barbers",
    "Noir",
    "Style Street Barber",
    "Smoke & Mirrors",
    "Gents",
    "The Pope",
  ];

  List photos = [
    "https://i.ibb.co/WsMyFKL/1.jpg",
    "https://i.ibb.co/Jxy78tq/2.png",
    "https://i.ibb.co/3scFNd0/3.jpg",
    "https://i.ibb.co/Lxh6VMT/4.jpg",
    "https://i.ibb.co/dfQjFs1/5.jpg",
    "https://i.ibb.co/yY7hBXK/6.jpg",
    "https://i.ibb.co/hyxHW9f/7.jpg",
    "https://i.ibb.co/v1ww6dL/8.jpg",
    "https://i.ibb.co/tBd97tP/9.jpg",
    "https://i.ibb.co/L8TPg5G/10.jpg",
    "https://i.ibb.co/fMmqM00/11.jpg",
    "https://i.ibb.co/72PTMqr/12.jpg",
  ];

  List products = [
    {
      'image': 'https://i.ibb.co/FWK0mmv/Young-man-at-barber-trimming-hair.jpg',
      'title': 'Hair Cut',
      'description': 'Traditional men’s haircut. Using clippers and scissors',
      'price': '8',
      'gender': 'All',
      'execution_time': '10 Min',
    },
    {
      'image':
          'https://i.ibb.co/FH7Pfg7/Handsome-man-at-barber-shaving-beard.jpg',
      'title': 'Beard',
      'description':
          'A service for longer and more styled beards – sculpt the beard, neckline foiled, finished with hot towel and cheekbones razored',
      'price': '5',
      'gender': 'All',
      'execution_time': '10 Min',
    },
    {
      'image': 'https://i.ibb.co/2MwL540/Young-man-at-barber-trimming-hair.jpg',
      'title': 'Hair Cut and Beard',
      'description':
          'Traditional men’s haircut and A service for longer and more styled beards',
      'price': '12',
      'gender': 'All',
      'execution_time': '10 Min',
    },
    {
      'image': 'https://i.ibb.co/0qhmcNw/Young-man-at-barber-trimming-hair.jpg',
      'title': 'Full Service',
      'description':
          'Traditional men’s haircut and A service for longer and more styled beards with hot / cold towels and moisturising',
      'price': '15',
      'gender': 'All',
      'execution_time': '10 Min',
    },
  ];

  List staffs = [
    {
      'photo': 'https://i.ibb.co/nnnHgdk/a3.png',
      'staff_name': 'Deeb',
      'description':
          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem.',
    },
    {
      'photo': 'https://i.ibb.co/MNmvnc6/a2.png',
      'staff_name': 'Jane Roe',
      'description':
          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem.',
    },
    {
      'photo': 'https://i.ibb.co/0Yz0WVK/a1.png',
      'staff_name': 'Rikaa',
      'description':
          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem.',
    },
    {
      'photo': 'https://i.ibb.co/LrXzgy5/a4.png',
      'staff_name': 'Violina',
      'description':
          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem.',
    },
  ];

  List galleries = [
    {
      'image':
          'https://i.ibb.co/FXhJ4Nv/Handsome-man-shaving-beard-at-barber.jpg',
    },
    {
      'image': 'https://i.ibb.co/k2scPrL/Young-man-at-barber-trimming-hair.jpg',
    },
    {
      'image':
          'https://i.ibb.co/yPqtvgB/Man-with-a-beard-Hairdresser-with-a-client.jpg',
    },
    {
      'image': 'https://i.ibb.co/hy55Rd6/gallery-5.jpg',
    },
    {
      'image': 'https://i.ibb.co/cTPD7tg/gallery-6.jpg',
    },
    {
      'image':
          'https://i.ibb.co/yPqtvgB/Man-with-a-beard-Hairdresser-with-a-client.jpg',
    },
  ];

  List reviews = [
    {
      "photo_url":
          "https://i.ibb.co/zsPJdWT/photo-1523898052899-241108586cf8-crop-entropy-cs-tinysrgb-fit-max-fm-jpg-ixid-Mnwy-ODA4-ODh8-MHwxf-H.jpg"
              "",
      "name": "Ryan Rotwaiss",
      "date": DateTime.now(),
      "comment": "At vero eos et accusamus et iusto odio dignissimos ducimus"
    },
    {
      "photo_url":
          "https://i.ibb.co/zsPJdWT/photo-1523898052899-241108586cf8-crop-entropy-cs-tinysrgb-fit-max-fm-jpg-ixid-Mnwy-ODA4-ODh8-MHwxf-H.jpg",
      "name": "Jack Lieber",
      "date": DateTime.now(),
      "comment": "Great services! I highly recommend!!",
      "rate": 5.0,
    },
    {
      "photo_url":
          "https://i.ibb.co/zsPJdWT/photo-1523898052899-241108586cf8-crop-entropy-cs-tinysrgb-fit-max-fm-jpg-ixid-Mnwy-ODA4-ODh8-MHwxf-H.jpg",
      "name": "G. Jewell",
      "date": DateTime.now(),
      "comment":
          "The staffs are friendly, highly skilled, and professional. 5 STARS!",
      "rate": 5.0,
    },
    {
      "photo_url":
          "https://i.ibb.co/zsPJdWT/photo-1523898052899-241108586cf8-crop-entropy-cs-tinysrgb-fit-max-fm-jpg-ixid-Mnwy-ODA4-ODh8-MHwxf-H.jpg",
      "name": "Flore Titania",
      "date": DateTime.now(),
      "comment": "Luvvv it❤",
      "rate": 5.0,
    },
    {
      "photo_url":
          "https://i.ibb.co/zsPJdWT/photo-1523898052899-241108586cf8-crop-entropy-cs-tinysrgb-fit-max-fm-jpg-ixid-Mnwy-ODA4-ODh8-MHwxf-H.jpg",
      "name": "Hannah Davis",
      "date": DateTime.now(),
      "comment":
          "Their attention to every little detail just never fails to amaze me.",
      "rate": 5.0,
    },
  ];
}
