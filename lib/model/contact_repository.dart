abstract interface class ContactRepository {
  const ContactRepository();

  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String message,
    required String currencyCode,
  });
}
