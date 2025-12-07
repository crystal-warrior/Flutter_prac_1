class IpLocation {
  final String country;
  final String countryCode;
  final String region;
  final String regionName;
  final String city;
  final double latitude;
  final double longitude;
  final String timezone;

  IpLocation({
    required this.country,
    required this.countryCode,
    required this.region,
    required this.regionName,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  String get fullLocation => '$city, $regionName, $country';
}





