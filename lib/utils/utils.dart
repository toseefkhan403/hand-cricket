import 'package:flutter/foundation.dart';

String prefixAssetName(String assetName) =>
    kIsWeb ? assetName : "assets/$assetName";
