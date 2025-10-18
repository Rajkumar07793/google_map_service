class PlacesResponse {
  PlacesResponse({required this.predictions, required this.status});

  final List<Prediction> predictions;
  final String? status;

  PlacesResponse copyWith({List<Prediction>? predictions, String? status}) {
    return PlacesResponse(
      predictions: predictions ?? this.predictions,
      status: status ?? this.status,
    );
  }

  factory PlacesResponse.fromJson(Map<String, dynamic> json) {
    return PlacesResponse(
      predictions: json["predictions"] == null
          ? []
          : List<Prediction>.from(
              json["predictions"]!.map((x) => Prediction.fromJson(x)),
            ),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "predictions": predictions.map((x) => x.toJson()).toList(),
    "status": status,
  };
}

class Prediction {
  Prediction({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  final String? description;
  final List<MatchedSubstring> matchedSubstrings;
  final String? placeId;
  final String? reference;
  final StructuredFormatting? structuredFormatting;
  final List<Term> terms;
  final List<String> types;

  Prediction copyWith({
    String? description,
    List<MatchedSubstring>? matchedSubstrings,
    String? placeId,
    String? reference,
    StructuredFormatting? structuredFormatting,
    List<Term>? terms,
    List<String>? types,
  }) {
    return Prediction(
      description: description ?? this.description,
      matchedSubstrings: matchedSubstrings ?? this.matchedSubstrings,
      placeId: placeId ?? this.placeId,
      reference: reference ?? this.reference,
      structuredFormatting: structuredFormatting ?? this.structuredFormatting,
      terms: terms ?? this.terms,
      types: types ?? this.types,
    );
  }

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json["description"],
      matchedSubstrings: json["matched_substrings"] == null
          ? []
          : List<MatchedSubstring>.from(
              json["matched_substrings"]!.map(
                (x) => MatchedSubstring.fromJson(x),
              ),
            ),
      placeId: json["place_id"],
      reference: json["reference"],
      structuredFormatting: json["structured_formatting"] == null
          ? null
          : StructuredFormatting.fromJson(json["structured_formatting"]),
      terms: json["terms"] == null
          ? []
          : List<Term>.from(json["terms"]!.map((x) => Term.fromJson(x))),
      types: json["types"] == null
          ? []
          : List<String>.from(json["types"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "description": description,
    "matched_substrings": matchedSubstrings.map((x) => x.toJson()).toList(),
    "place_id": placeId,
    "reference": reference,
    "structured_formatting": structuredFormatting?.toJson(),
    "terms": terms.map((x) => x.toJson()).toList(),
    "types": types.map((x) => x).toList(),
  };
}

class MatchedSubstring {
  MatchedSubstring({required this.length, required this.offset});

  final int? length;
  final int? offset;

  MatchedSubstring copyWith({int? length, int? offset}) {
    return MatchedSubstring(
      length: length ?? this.length,
      offset: offset ?? this.offset,
    );
  }

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(length: json["length"], offset: json["offset"]);
  }

  Map<String, dynamic> toJson() => {"length": length, "offset": offset};
}

class StructuredFormatting {
  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  final String? mainText;
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String? secondaryText;

  StructuredFormatting copyWith({
    String? mainText,
    List<MatchedSubstring>? mainTextMatchedSubstrings,
    String? secondaryText,
  }) {
    return StructuredFormatting(
      mainText: mainText ?? this.mainText,
      mainTextMatchedSubstrings:
          mainTextMatchedSubstrings ?? this.mainTextMatchedSubstrings,
      secondaryText: secondaryText ?? this.secondaryText,
    );
  }

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json["main_text"],
      mainTextMatchedSubstrings: json["main_text_matched_substrings"] == null
          ? []
          : List<MatchedSubstring>.from(
              json["main_text_matched_substrings"]!.map(
                (x) => MatchedSubstring.fromJson(x),
              ),
            ),
      secondaryText: json["secondary_text"],
    );
  }

  Map<String, dynamic> toJson() => {
    "main_text": mainText,
    "main_text_matched_substrings": mainTextMatchedSubstrings
        .map((x) => x.toJson())
        .toList(),
    "secondary_text": secondaryText,
  };
}

class Term {
  Term({required this.offset, required this.value});

  final int? offset;
  final String? value;

  Term copyWith({int? offset, String? value}) {
    return Term(offset: offset ?? this.offset, value: value ?? this.value);
  }

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(offset: json["offset"], value: json["value"]);
  }

  Map<String, dynamic> toJson() => {"offset": offset, "value": value};
}
