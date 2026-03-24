enum UserType {
  customer,
  businessOwner;

  /// Role string sent to backend
  String get role => switch (this) {
    UserType.customer => 'customer',
    UserType.businessOwner => 'business_owner',
  };

  String get displayName => switch (this) {
    UserType.customer => 'Müşteri',
    UserType.businessOwner => 'İşletme Sahibi',
  };

  String get loginTitle => switch (this) {
    UserType.customer => 'Hoş Geldiniz!',
    UserType.businessOwner => 'İşletme Paneli',
  };

  String get loginSubtitle => switch (this) {
    UserType.customer =>
      'Hesabınıza giriş yaparak yiyecekleri kurtarmaya başlayın',
    UserType.businessOwner =>
      'İşletme hesabınıza giriş yapın ve siparişleri yönetin',
  };

  String get registerTitle => switch (this) {
    UserType.customer => 'Müşteri Hesabı Oluştur',
    UserType.businessOwner => 'İşletme Hesabı Oluştur',
  };

  String get registerSubtitle => switch (this) {
    UserType.customer =>
      'Kayıt olun, sürpriz paketleri keşfedin ve yiyecekleri kurtarın',
    UserType.businessOwner =>
      'İşletmenizi platforma ekleyin ve arta kalan yiyecekleri değerlendirin',
  };

  /// Reconstruct from backend role string
  static UserType fromRole(String role) =>
      role == 'business_owner' ? UserType.businessOwner : UserType.customer;
}
