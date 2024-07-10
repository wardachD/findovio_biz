import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../provider/salon_provider/get_salon_provider.dart';
import '../../../../provider/salon_provider/get_salon_builder_provider.dart';
import '../../widgets/loading_popup.dart';
import '../widgets/go_back_arrow.dart';

enum PhotoType {
  avatar,
  gallery,
}

class AddDetailsScreen extends StatefulWidget {
  bool isNavigatedFromSettings = false;
  AddDetailsScreen({super.key, required this.isNavigatedFromSettings});

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  /// [getSalonProvider] Is used to get id from salon object - needed for api request
  GetSalonProvider getSalonProvider = GetSalonProvider();

  /// [isDisabled] Corresponds with button, only one avatar photo is required, the rest
  /// is optional
  File? _imageFileAvatar;
  final List<File> _imageFilesGallery = [];
  bool get isAvatarPathNotEmpty => avatarPath != null;
  bool get isDisabled =>
      _imageFileAvatar != null ||
      (isAvatarPathNotEmpty && _imageFilesGallery.isNotEmpty);
  final picker = ImagePicker();
  bool _isPickerActive = false;
  String? avatarPath;
  List<String> galleryPaths = [];

  Future<void> _getImage(ImageSource source, PhotoType photoType) async {
    if (_isPickerActive) {
      return; // Wyjdź z funkcji, jeśli picker jest już aktywny
    }

    _isPickerActive = true; // Ustaw flagę, że picker jest aktywny

    final pickedFile = await picker.pickImage(source: source);

    _isPickerActive =
        false; // Zresetuj flagę, gdy pobieranie obrazu zostanie zakończone

    if (pickedFile == null) {
      print('No image selected.');
      return; // Wyjdź z funkcji, jeśli nie wybrano żadnego obrazu
    }

    switch (photoType) {
      case PhotoType.avatar:
        setState(() {
          _imageFileAvatar = File(pickedFile.path);
        });
        break;
      case PhotoType.gallery:
        setState(() {
          _imageFilesGallery.add(File(pickedFile.path));
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getSalonProvider = Provider.of<GetSalonProvider>(context, listen: false);
    setState(() {
      if (getSalonProvider.salonImagesModel.isNotEmpty) {
        for (var element in getSalonProvider.salonImagesModel) {
          if (element.imageType == PhotoType.avatar) {
            avatarPath = element.imageUrl!.replaceAll(
                'https://185.180.204.182:8000', 'http://185.180.204.182');
            print(avatarPath);
          }
          if (element.imageType == PhotoType.gallery) {
            galleryPaths.add(element.imageUrl!.replaceAll(
                'https://185.180.204.182:8000', 'http://185.180.204.182'));
            print(galleryPaths);
          }
        }
      } else if (getSalonProvider.salon != null) {
        avatarPath = getSalonProvider.salon?.avatar ?? '';
        List<String> existingSalonGallery =
            getSalonProvider.salon?.salonGallery ?? [];
        for (var element in existingSalonGallery) {
          galleryPaths.add(element);
          print(galleryPaths);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (!widget.isNavigatedFromSettings)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: GoBackArrow(),
              ),
            if (widget.isNavigatedFromSettings)
              Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    child: const Text(
                      'Dodaj lub usuń zdjęcia',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            if (widget.isNavigatedFromSettings)
              const Divider(
                color: Color.fromARGB(255, 228, 228, 228),
                height: 24,
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Title with description
                      const SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dodaj zdjęcia',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Wymagane jest zdjęcie profilowe salonu, galeria jest opcjonalna i możesz dodać do niej maksymalnie 8 zdjęć.',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 87, 87, 87)),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title with description
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // 1. Dodaj zdjęcia

                          const Row(
                            children: [
                              Text(
                                '1. Dodaj zdjęcie profilowe',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Icon(
                                Icons.new_releases,
                                color: Color.fromARGB(255, 126, 126, 126),
                                size: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Wymagane',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 126, 126, 126),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _imageFileAvatar != null
                              ? Stack(
                                  children: [
                                    InkWell(
                                      onTap: () => _getImage(
                                          ImageSource.gallery,
                                          PhotoType.avatar),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Image.file(
                                          _imageFileAvatar!,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                          width: 140,
                                          height: 42,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  146, 255, 255, 255),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      199, 255, 255, 255)),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(8))),
                                          child: const Center(
                                            child: Text('Kliknij by zmienić'),
                                          )),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: InkWell(
                                        onTap: () => setState(() {
                                          _imageFileAvatar = null;
                                        }),
                                        child: Container(
                                            width: 80,
                                            height: 42,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    146, 255, 255, 255),
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        199, 255, 255, 255)),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(
                                                                8))),
                                            child: const Center(
                                              child: Icon(
                                                Icons.delete,
                                                color: Color.fromARGB(
                                                    255, 36, 36, 36),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                )
                              : avatarPath == ""
                                  ? Material(
                                      child: InkWell(
                                        onTap: () => _getImage(
                                            ImageSource.gallery,
                                            PhotoType.avatar),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 230, 230, 230),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: const Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add_a_photo_rounded),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text('Dodaj zdjęcie główne'),
                                              ],
                                            ))),
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        InkWell(
                                          onTap: () => _getImage(
                                              ImageSource.gallery,
                                              PhotoType.avatar),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Image.network(
                                              avatarPath!,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                              width: 140,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      146, 255, 255, 255),
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              199,
                                                              255,
                                                              255,
                                                              255)),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8))),
                                              child: const Center(
                                                child:
                                                    Text('Kliknij by zmienić'),
                                              )),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: InkWell(
                                            onTap: () async {
                                              var fileToDelete =
                                                  avatarPath!.split('/').last;
                                              var deleteRes = await getSalonProvider
                                                  .deleteSalonImagesFiles(getSalonProvider
                                                      .salonImagesModel[getSalonProvider
                                                          .salonImagesModel
                                                          .indexWhere((element) =>
                                                              element.imageUrl!
                                                                  .contains(
                                                                      fileToDelete))]
                                                      .photoId!);
                                              setState(() {
                                                if (deleteRes) {
                                                  avatarPath = null;
                                                }
                                              });
                                            },
                                            child: Container(
                                                width: 80,
                                                height: 42,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        146, 255, 255, 255),
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromARGB(199, 255,
                                                            255, 255)),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    8))),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Color.fromARGB(
                                                        255, 36, 36, 36),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),

                          const SizedBox(height: 16),

                          // 2. Dodaj zdjęcia do galerii
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Text(
                              '2. Dodaj zdjęcia do galerii',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: galleryPaths.length +
                                _imageFilesGallery.length +
                                1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index < galleryPaths.length) {
                                // Wyświetl obrazy z galleryPaths
                                return Stack(
                                  clipBehavior: Clip.hardEdge,
                                  children: [
                                    Positioned.fill(
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            // Do something when the image is tapped
                                          },
                                          child: Image.network(
                                            galleryPaths[index],
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: InkWell(
                                        onTap: () async {
                                          var fileToDelete = galleryPaths[index]
                                              .split('/')
                                              .last;
                                          var deleteRes = await getSalonProvider
                                              .deleteSalonImagesFiles(getSalonProvider
                                                  .salonImagesModel[getSalonProvider
                                                      .salonImagesModel
                                                      .indexWhere((element) =>
                                                          element.imageUrl!
                                                              .contains(
                                                                  fileToDelete))]
                                                  .photoId!);
                                          setState(() {
                                            if (deleteRes) {
                                              galleryPaths.removeAt(index);
                                            }
                                          });
                                          setState(() {
                                            if (galleryPaths.isNotEmpty) {
                                              galleryPaths.removeAt(index);
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                146, 255, 255, 255),
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                  199, 255, 255, 255),
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 36, 36, 36),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (index <
                                  galleryPaths.length +
                                      _imageFilesGallery.length) {
                                // Wyświetl obrazy z _imageFilesGallery
                                final int adjustedIndex =
                                    index - galleryPaths.length;
                                return Stack(
                                  clipBehavior: Clip.hardEdge,
                                  children: [
                                    Positioned.fill(
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            // Do something when the image is tapped
                                          },
                                          child: Image.file(
                                            _imageFilesGallery[adjustedIndex],
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: InkWell(
                                        onTap: () {
                                          // Remove the image from _imageFilesGallery
                                          setState(() {
                                            _imageFilesGallery
                                                .removeAt(adjustedIndex);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                146, 255, 255, 255),
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                  199, 255, 255, 255),
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 36, 36, 36),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                // Pusty placeholder dla dodawania nowego obrazu
                                return Material(
                                  child: InkWell(
                                    onTap: () => _getImage(
                                      ImageSource.gallery,
                                      PhotoType.gallery,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 230, 230, 230),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      child: const Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_a_photo_rounded),
                                            SizedBox(width: 8),
                                            Text('Dodaj zdjęcie'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// [_imageFileAvatar] Button which corresponds with avatar picture
            Consumer<GetSalonBuilderProvider>(
              builder: (context, servicesProvider, _) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: !isDisabled
                            ? MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 185, 185, 185))
                            : MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 20, 20, 20)),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    onPressed: () async {
                      showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const LoadingPopup();
                        },
                      );
                      // Send API Request to upload avatar
                      if (_imageFileAvatar != null) {
                        var res = await getSalonProvider.uploadPhoto(
                            _imageFileAvatar!,
                            PhotoType.avatar,
                            getSalonProvider.salon?.id ?? 0);
                        print(getSalonProvider.salon!.id.toString());
                        print('Upload avatar image status: $res');
                      }
                      // Send API Request to upload each element one by one
                      var resGallery = [];
                      if (_imageFilesGallery.isNotEmpty) {
                        _imageFilesGallery.forEach((element) async =>
                            resGallery.add(await getSalonProvider.uploadPhoto(
                                element,
                                PhotoType.gallery,
                                getSalonProvider.salon?.id ?? 0)));
                      }
                      getSalonProvider.getVerificationStatus(context);
                      Get.back();
                      Get.back();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            !isDisabled
                                ? 'Dodaj zdjęcie główne'
                                : ' Zapisz i wyślij',
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
