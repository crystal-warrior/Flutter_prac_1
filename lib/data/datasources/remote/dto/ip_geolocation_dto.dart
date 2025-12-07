class IpGeolocationDto {
  final String? status;
  final String? country;
  final String? countryCode;
  final String? region;
  final String? regionName;
  final String? city;
  final double? lat;
  final double? lon;
  final String? timezone;
  final String? query;

  IpGeolocationDto({
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.lat,
    this.lon,
    this.timezone,
    this.query,
  });

  factory IpGeolocationDto.fromJson(Map<String, dynamic> json) {
    return IpGeolocationDto(
      status: json['status'] as String?,
      country: json['country'] as String?,
      countryCode: json['countryCode'] as String?,
      region: json['region'] as String?,
      regionName: json['regionName'] as String?,
      city: json['city'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      timezone: json['timezone'] as String?,
      query: json['query'] as String?,
    );
  }
}





