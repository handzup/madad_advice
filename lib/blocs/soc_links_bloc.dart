import 'package:flutter/cupertino.dart';
import 'package:madad_advice/models/social.dart';
import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/api_service.dart';

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
