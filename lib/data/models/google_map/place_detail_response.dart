class PlaceDetailResponse {
  PlaceDetailResponse({this.htmlAttributions, this.result, this.status});

  final List<dynamic>? htmlAttributions;
  final PlaceDetails? result;
  final String? status;

  PlaceDetailResponse copyWith({
    List<dynamic>? htmlAttributions,
    PlaceDetails? result,
    String? status,
  }) {
    return PlaceDetailResponse(
      htmlAttributions: htmlAttributions ?? this.htmlAttributions,
      result: result ?? this.result,
      status: status ?? this.status,
    );
  }

  factory PlaceDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailResponse(
      htmlAttributions: json["html_attributions"] == null
          ? []
          : List<dynamic>.from(json["html_attributions"]!.map((x) => x)),
      result: json["result"] == null
          ? null
          : PlaceDetails.fromJson(json["result"]),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "html_attributions": htmlAttributions?.map((x) => x).toList(),
    "result": result?.toJson(),
    "status": status,
  };
}

class PlaceDetails {
  PlaceDetails({
    this.addressComponents,
    this.adrAddress,
    this.businessStatus,
    this.currentOpeningHours,
    this.editorialSummary,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.plusCode,
    this.rating,
    this.reference,
    this.reviews,
    this.types,
    this.url,
    this.userRatingsTotal,
    this.utcOffset,
    this.vicinity,
    this.website,
    this.wheelchairAccessibleEntrance,
  });

  final List<AddressComponent>? addressComponents;
  final String? adrAddress;
  final String? businessStatus;
  final CurrentOpeningHours? currentOpeningHours;
  final EditorialSummary? editorialSummary;
  final String? formattedAddress;
  final Geometry? geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String? name;
  final OpeningHours? openingHours;
  final List<Photo>? photos;
  final String? placeId;
  final PlusCode? plusCode;
  final double? rating;
  final String? reference;
  final List<Review>? reviews;
  final List<String>? types;
  final String? url;
  final int? userRatingsTotal;
  final int? utcOffset;
  final String? vicinity;
  final String? website;
  final bool? wheelchairAccessibleEntrance;

  PlaceDetails copyWith({
    List<AddressComponent>? addressComponents,
    String? adrAddress,
    String? businessStatus,
    CurrentOpeningHours? currentOpeningHours,
    EditorialSummary? editorialSummary,
    String? formattedAddress,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    OpeningHours? openingHours,
    List<Photo>? photos,
    String? placeId,
    PlusCode? plusCode,
    double? rating,
    String? reference,
    List<Review>? reviews,
    List<String>? types,
    String? url,
    int? userRatingsTotal,
    int? utcOffset,
    String? vicinity,
    String? website,
    bool? wheelchairAccessibleEntrance,
  }) {
    return PlaceDetails(
      addressComponents: addressComponents ?? this.addressComponents,
      adrAddress: adrAddress ?? this.adrAddress,
      businessStatus: businessStatus ?? this.businessStatus,
      currentOpeningHours: currentOpeningHours ?? this.currentOpeningHours,
      editorialSummary: editorialSummary ?? this.editorialSummary,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      geometry: geometry ?? this.geometry,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
      name: name ?? this.name,
      openingHours: openingHours ?? this.openingHours,
      photos: photos ?? this.photos,
      placeId: placeId ?? this.placeId,
      plusCode: plusCode ?? this.plusCode,
      rating: rating ?? this.rating,
      reference: reference ?? this.reference,
      reviews: reviews ?? this.reviews,
      types: types ?? this.types,
      url: url ?? this.url,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      utcOffset: utcOffset ?? this.utcOffset,
      vicinity: vicinity ?? this.vicinity,
      website: website ?? this.website,
      wheelchairAccessibleEntrance:
          wheelchairAccessibleEntrance ?? this.wheelchairAccessibleEntrance,
    );
  }

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      addressComponents: json["address_components"] == null
          ? []
          : List<AddressComponent>.from(
              json["address_components"]!.map(
                (x) => AddressComponent.fromJson(x),
              ),
            ),
      adrAddress: json["adr_address"],
      businessStatus: json["business_status"],
      currentOpeningHours: json["current_opening_hours"] == null
          ? null
          : CurrentOpeningHours.fromJson(json["current_opening_hours"]),
      editorialSummary: json["editorial_summary"] == null
          ? null
          : EditorialSummary.fromJson(json["editorial_summary"]),
      formattedAddress: json["formatted_address"],
      geometry: json["geometry"] == null
          ? null
          : Geometry.fromJson(json["geometry"]),
      icon: json["icon"],
      iconBackgroundColor: json["icon_background_color"],
      iconMaskBaseUri: json["icon_mask_base_uri"],
      name: json["name"],
      openingHours: json["opening_hours"] == null
          ? null
          : OpeningHours.fromJson(json["opening_hours"]),
      photos: json["photos"] == null
          ? []
          : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
      placeId: json["place_id"],
      plusCode: json["plus_code"] == null
          ? null
          : PlusCode.fromJson(json["plus_code"]),
      rating: json["rating"] is int
          ? (json["rating"] as int).toDouble()
          : json["rating"],
      reference: json["reference"],
      reviews: json["reviews"] == null
          ? []
          : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
      types: json["types"] == null
          ? []
          : List<String>.from(json["types"]!.map((x) => x)),
      url: json["url"],
      userRatingsTotal: json["user_ratings_total"],
      utcOffset: json["utc_offset"],
      vicinity: json["vicinity"],
      website: json["website"],
      wheelchairAccessibleEntrance: json["wheelchair_accessible_entrance"],
    );
  }

  Map<String, dynamic> toJson() => {
    "address_components": addressComponents?.map((x) => x.toJson()).toList(),
    "adr_address": adrAddress,
    "business_status": businessStatus,
    "current_opening_hours": currentOpeningHours?.toJson(),
    "editorial_summary": editorialSummary?.toJson(),
    "formatted_address": formattedAddress,
    "geometry": geometry?.toJson(),
    "icon": icon,
    "icon_background_color": iconBackgroundColor,
    "icon_mask_base_uri": iconMaskBaseUri,
    "name": name,
    "opening_hours": openingHours?.toJson(),
    "photos": photos?.map((x) => x.toJson()).toList(),
    "place_id": placeId,
    "plus_code": plusCode?.toJson(),
    "rating": rating,
    "reference": reference,
    "reviews": reviews?.map((x) => x.toJson()).toList(),
    "types": types?.map((x) => x).toList(),
    "url": url,
    "user_ratings_total": userRatingsTotal,
    "utc_offset": utcOffset,
    "vicinity": vicinity,
    "website": website,
    "wheelchair_accessible_entrance": wheelchairAccessibleEntrance,
  };
}

class AddressComponent {
  AddressComponent({this.longName, this.shortName, this.types});

  final String? longName;
  final String? shortName;
  final List<String>? types;

  AddressComponent copyWith({
    String? longName,
    String? shortName,
    List<String>? types,
  }) {
    return AddressComponent(
      longName: longName ?? this.longName,
      shortName: shortName ?? this.shortName,
      types: types ?? this.types,
    );
  }

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longName: json["long_name"],
      shortName: json["short_name"],
      types: json["types"] == null
          ? []
          : List<String>.from(json["types"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": types?.map((x) => x).toList(),
  };
}

class CurrentOpeningHours {
  CurrentOpeningHours({this.openNow, this.periods, this.weekdayText});

  final bool? openNow;
  final List<CurrentOpeningHoursPeriod>? periods;
  final List<String>? weekdayText;

  CurrentOpeningHours copyWith({
    bool? openNow,
    List<CurrentOpeningHoursPeriod>? periods,
    List<String>? weekdayText,
  }) {
    return CurrentOpeningHours(
      openNow: openNow ?? this.openNow,
      periods: periods ?? this.periods,
      weekdayText: weekdayText ?? this.weekdayText,
    );
  }

  factory CurrentOpeningHours.fromJson(Map<String, dynamic> json) {
    return CurrentOpeningHours(
      openNow: json["open_now"],
      periods: json["periods"] == null
          ? []
          : List<CurrentOpeningHoursPeriod>.from(
              json["periods"]!.map(
                (x) => CurrentOpeningHoursPeriod.fromJson(x),
              ),
            ),
      weekdayText: json["weekday_text"] == null
          ? []
          : List<String>.from(json["weekday_text"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "open_now": openNow,
    "periods": periods?.map((x) => x.toJson()).toList(),
    "weekday_text": weekdayText?.map((x) => x).toList(),
  };
}

class CurrentOpeningHoursPeriod {
  CurrentOpeningHoursPeriod({this.close, this.open});

  final PurpleClose? close;
  final PurpleClose? open;

  CurrentOpeningHoursPeriod copyWith({PurpleClose? close, PurpleClose? open}) {
    return CurrentOpeningHoursPeriod(
      close: close ?? this.close,
      open: open ?? this.open,
    );
  }

  factory CurrentOpeningHoursPeriod.fromJson(Map<String, dynamic> json) {
    return CurrentOpeningHoursPeriod(
      close: json["close"] == null ? null : PurpleClose.fromJson(json["close"]),
      open: json["open"] == null ? null : PurpleClose.fromJson(json["open"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "close": close?.toJson(),
    "open": open?.toJson(),
  };
}

class PurpleClose {
  PurpleClose({this.date, this.day, this.time});

  final DateTime? date;
  final int? day;
  final String? time;

  PurpleClose copyWith({DateTime? date, int? day, String? time}) {
    return PurpleClose(
      date: date ?? this.date,
      day: day ?? this.day,
      time: time ?? this.time,
    );
  }

  factory PurpleClose.fromJson(Map<String, dynamic> json) {
    return PurpleClose(
      date: DateTime.tryParse(json["date"] ?? ""),
      day: json["day"],
      time: json["time"],
    );
  }

  Map<String, dynamic> toJson() => {
    "date":
        "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "day": day,
    "time": time,
  };
}

class EditorialSummary {
  EditorialSummary({this.language, this.overview});

  final String? language;
  final String? overview;

  EditorialSummary copyWith({String? language, String? overview}) {
    return EditorialSummary(
      language: language ?? this.language,
      overview: overview ?? this.overview,
    );
  }

  factory EditorialSummary.fromJson(Map<String, dynamic> json) {
    return EditorialSummary(
      language: json["language"],
      overview: json["overview"],
    );
  }

  Map<String, dynamic> toJson() => {"language": language, "overview": overview};
}

class Geometry {
  Geometry({this.location, this.viewport});

  final Location? location;
  final Viewport? viewport;

  Geometry copyWith({Location? location, Viewport? viewport}) {
    return Geometry(
      location: location ?? this.location,
      viewport: viewport ?? this.viewport,
    );
  }

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: json["location"] == null
          ? null
          : Location.fromJson(json["location"]),
      viewport: json["viewport"] == null
          ? null
          : Viewport.fromJson(json["viewport"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "viewport": viewport?.toJson(),
  };
}

class Location {
  Location({this.lat, this.lng});

  final double? lat;
  final double? lng;

  Location copyWith({double? lat, double? lng}) {
    return Location(lat: lat ?? this.lat, lng: lng ?? this.lng);
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(lat: json["lat"], lng: json["lng"]);
  }

  Map<String, dynamic> toJson() => {"lat": lat, "lng": lng};
}

class Viewport {
  Viewport({this.northeast, this.southwest});

  final Location? northeast;
  final Location? southwest;

  Viewport copyWith({Location? northeast, Location? southwest}) {
    return Viewport(
      northeast: northeast ?? this.northeast,
      southwest: southwest ?? this.southwest,
    );
  }

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: json["northeast"] == null
          ? null
          : Location.fromJson(json["northeast"]),
      southwest: json["southwest"] == null
          ? null
          : Location.fromJson(json["southwest"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "northeast": northeast?.toJson(),
    "southwest": southwest?.toJson(),
  };
}

class OpeningHours {
  OpeningHours({this.openNow, this.periods, this.weekdayText});

  final bool? openNow;
  final List<OpeningHoursPeriod>? periods;
  final List<String>? weekdayText;

  OpeningHours copyWith({
    bool? openNow,
    List<OpeningHoursPeriod>? periods,
    List<String>? weekdayText,
  }) {
    return OpeningHours(
      openNow: openNow ?? this.openNow,
      periods: periods ?? this.periods,
      weekdayText: weekdayText ?? this.weekdayText,
    );
  }

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      openNow: json["open_now"],
      periods: json["periods"] == null
          ? []
          : List<OpeningHoursPeriod>.from(
              json["periods"]!.map((x) => OpeningHoursPeriod.fromJson(x)),
            ),
      weekdayText: json["weekday_text"] == null
          ? []
          : List<String>.from(json["weekday_text"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "open_now": openNow,
    "periods": periods?.map((x) => x.toJson()).toList(),
    "weekday_text": weekdayText?.map((x) => x).toList(),
  };
}

class OpeningHoursPeriod {
  OpeningHoursPeriod({this.close, this.open});

  final FluffyClose? close;
  final FluffyClose? open;

  OpeningHoursPeriod copyWith({FluffyClose? close, FluffyClose? open}) {
    return OpeningHoursPeriod(
      close: close ?? this.close,
      open: open ?? this.open,
    );
  }

  factory OpeningHoursPeriod.fromJson(Map<String, dynamic> json) {
    return OpeningHoursPeriod(
      close: json["close"] == null ? null : FluffyClose.fromJson(json["close"]),
      open: json["open"] == null ? null : FluffyClose.fromJson(json["open"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "close": close?.toJson(),
    "open": open?.toJson(),
  };
}

class FluffyClose {
  FluffyClose({this.day, this.time});

  final int? day;
  final String? time;

  FluffyClose copyWith({int? day, String? time}) {
    return FluffyClose(day: day ?? this.day, time: time ?? this.time);
  }

  factory FluffyClose.fromJson(Map<String, dynamic> json) {
    return FluffyClose(day: json["day"], time: json["time"]);
  }

  Map<String, dynamic> toJson() => {"day": day, "time": time};
}

class Photo {
  Photo({this.height, this.htmlAttributions, this.photoReference, this.width});

  final int? height;
  final List<String>? htmlAttributions;
  final String? photoReference;
  final int? width;

  Photo copyWith({
    int? height,
    List<String>? htmlAttributions,
    String? photoReference,
    int? width,
  }) {
    return Photo(
      height: height ?? this.height,
      htmlAttributions: htmlAttributions ?? this.htmlAttributions,
      photoReference: photoReference ?? this.photoReference,
      width: width ?? this.width,
    );
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      height: json["height"],
      htmlAttributions: json["html_attributions"] == null
          ? []
          : List<String>.from(json["html_attributions"]!.map((x) => x)),
      photoReference: json["photo_reference"],
      width: json["width"],
    );
  }

  Map<String, dynamic> toJson() => {
    "height": height,
    "html_attributions": htmlAttributions?.map((x) => x).toList(),
    "photo_reference": photoReference,
    "width": width,
  };
}

class PlusCode {
  PlusCode({this.compoundCode, this.globalCode});

  final String? compoundCode;
  final String? globalCode;

  PlusCode copyWith({String? compoundCode, String? globalCode}) {
    return PlusCode(
      compoundCode: compoundCode ?? this.compoundCode,
      globalCode: globalCode ?? this.globalCode,
    );
  }

  factory PlusCode.fromJson(Map<String, dynamic> json) {
    return PlusCode(
      compoundCode: json["compound_code"],
      globalCode: json["global_code"],
    );
  }

  Map<String, dynamic> toJson() => {
    "compound_code": compoundCode,
    "global_code": globalCode,
  };
}

class Review {
  Review({
    this.authorName,
    this.authorUrl,
    this.language,
    this.originalLanguage,
    this.profilePhotoUrl,
    this.rating,
    this.relativeTimeDescription,
    this.text,
    this.time,
    this.translated,
  });

  final String? authorName;
  final String? authorUrl;
  final String? language;
  final String? originalLanguage;
  final String? profilePhotoUrl;
  final int? rating;
  final String? relativeTimeDescription;
  final String? text;
  final int? time;
  final bool? translated;

  Review copyWith({
    String? authorName,
    String? authorUrl,
    String? language,
    String? originalLanguage,
    String? profilePhotoUrl,
    int? rating,
    String? relativeTimeDescription,
    String? text,
    int? time,
    bool? translated,
  }) {
    return Review(
      authorName: authorName ?? this.authorName,
      authorUrl: authorUrl ?? this.authorUrl,
      language: language ?? this.language,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      rating: rating ?? this.rating,
      relativeTimeDescription:
          relativeTimeDescription ?? this.relativeTimeDescription,
      text: text ?? this.text,
      time: time ?? this.time,
      translated: translated ?? this.translated,
    );
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorName: json["author_name"],
      authorUrl: json["author_url"],
      language: json["language"],
      originalLanguage: json["original_language"],
      profilePhotoUrl: json["profile_photo_url"],
      rating: json["rating"],
      relativeTimeDescription: json["relative_time_description"],
      text: json["text"],
      time: json["time"],
      translated: json["translated"],
    );
  }

  Map<String, dynamic> toJson() => {
    "author_name": authorName,
    "author_url": authorUrl,
    "language": language,
    "original_language": originalLanguage,
    "profile_photo_url": profilePhotoUrl,
    "rating": rating,
    "relative_time_description": relativeTimeDescription,
    "text": text,
    "time": time,
    "translated": translated,
  };
}
