import 'package:Tosell/core/api/client/BaseClient.dart';

class ImageUrlService {
  static String imageUrl = imageUrl;
  
  static String buildFullImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    } else if (imagePath.startsWith('/')) {
      return '$imageUrl${imagePath.substring(1)}'; 
    } else {
      return '$imageUrl$imagePath';
    }
  }
}