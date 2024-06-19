class MetrixAttribution {
  String? acquisitionAd;
  String? acquisitionAdSet;
  String? acquisitionCampaign;
  String? acquisitionSource;
  String? acquisitionSubId;
  String attributionStatus = "NOT_ATTRIBUTED_YET";

  static MetrixAttribution fromMap(dynamic map) {
    MetrixAttribution attribution = new MetrixAttribution();
    try {
      attribution.acquisitionAd = map['acquisitionAd'];
      attribution.acquisitionAdSet = map['acquisitionAdSet'];
      attribution.acquisitionCampaign = map['acquisitionCampaign'];
      attribution.acquisitionSource = map['acquisitionSource'];
      attribution.acquisitionSubId = map['acquisitionSubId'];
      attribution.attributionStatus = map['attributionStatus'];
    } catch (e) {
      print('[MetrixFlutter]: Failed to create MetrixAttribution object from given map object. Details: ' + e.toString());
    }
    return attribution;
  }
}