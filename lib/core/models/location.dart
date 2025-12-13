class Location {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? region;

  const Location({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.region,
  });

  Location copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? region,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
    );
  }
}











