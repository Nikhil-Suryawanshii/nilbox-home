import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/splash/nilbox_logo.png');
  final image = img.decodeImage(file.readAsBytesSync())!;
  print('Width: ${image.width}, Height: ${image.height}');
  
  // Make a square canvas based on the largest dimension
  final size = image.width > image.height ? image.width : image.height;
  // Actually, for Android 12 splash screen, it's best to have a square with extra padding
  // Let's make the canvas 2x the width so it's safely in the center and square
  final canvasSize = (size * 1.5).toInt();
  
  final canvas = img.Image(width: canvasSize, height: canvasSize);
  
  // Fill with white or transparent (Android 12 icon is usually transparent background and we set window background to white)
  // Transparent fill:
  img.fill(canvas, color: img.ColorRgba8(255, 255, 255, 0));
  
  // Draw the original image in the center
  final dstX = (canvasSize - image.width) ~/ 2;
  final dstY = (canvasSize - image.height) ~/ 2;
  
  img.compositeImage(canvas, image, dstX: dstX, dstY: dstY);
  
  File('assets/splash/nilbox_logo_padded.png').writeAsBytesSync(img.encodePng(canvas));
  print('Padded image created!');
}
