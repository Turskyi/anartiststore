/// [Currency] is an `enum` object that contains all supported currencies by
/// project.
enum Currency {
  eur(
    name: 'Euro',
    code: 'EUR',
    symbol: '€',
  ),
  pln(
    name: 'Polish Zloty',
    code: 'PLN',
    symbol: 'zł',
  ),
  uah(
    name: 'Ukrainian Hryvnia',
    code: 'UAH',
    symbol: '₴',
  ),
  cad(
    name: 'Canadian Dollar',
    code: 'CAD',
    symbol: '\$',
  );

  const Currency({
    required this.name,
    required this.code,
    required this.symbol,
  });

  final String name;
  final String code;
  final String symbol;

  static Currency fromCode(String code) {
    return Currency.values.firstWhere(
      (Currency c) => c.code == code,
      orElse: () => Currency.eur,
    );
  }
}
