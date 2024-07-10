import 'package:findovio_business/screens/main_menu/pulpit_screen/screens/add_details_screen.dart';

class GetSalonImage {
  final int? photoId;
  final int? salonId;
  final String? image;
  final PhotoType? imageType;
  final String? imageUrl;

  GetSalonImage({
    this.photoId,
    this.salonId,
    this.image,
    this.imageType,
    this.imageUrl,
  });

  factory GetSalonImage.fromJson(Map<String, dynamic> json) {
    var photoType = json['image_type'] as String?;
    return GetSalonImage(
      photoId: json['id'] as int?,
      salonId: json['salon_id'] as int?,
      image: json['image'] as String?,
      imageType: photoType == 'avatar' ? PhotoType.avatar : PhotoType.gallery,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salon_id': salonId,
      'image': image,
      'image_type': imageType,
      'image_url': imageUrl,
    };
  }
}
