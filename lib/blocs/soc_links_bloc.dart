import 'package:flutter/cupertino.dart';

import '../models/social.dart';
import '../utils/api_service.dart';

final apiService = ApiService();

class CosLinksBloc extends ChangeNotifier {
  SocMedia _media = SocMedia(
      facebook: '', instagram: '', telegram: '', twitter: '', youtubel: '');
  SocMedia get media => _media;

  CosLinksBloc() {
    init();
  }
  Future<SocMedia> getLinks() async {
    final data = await apiService.getLinks();
    if (!data.error) {
      return data.data;
    }
    return _media;
  }

  void init() async {
    _media = await getLinks();
  }
}
