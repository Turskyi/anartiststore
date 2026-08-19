enum ProductAvailability {
  available,
  reserved,
  sold;

  static ProductAvailability fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'AVAILABLE':
        return ProductAvailability.available;
      case 'RESERVED':
        return ProductAvailability.reserved;
      case 'SOLD':
        return ProductAvailability.sold;
      default:
        return ProductAvailability.available;
    }
  }

  String toBackendString() => name.toUpperCase();
}
