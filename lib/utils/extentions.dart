extension StringExtension on String {
  /// Append the svg location to the string
  String asAssetSvg() => 'assets/svgs/$this.svg';

  /// Append the image location to the string
  String asAssetImg() => 'assets/images/$this.png';

  /// Append the gif location to the string
  String asAssetGif() => 'assets/gifs/$this';
}
