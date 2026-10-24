enum UserRole {
  producer,
  consumer;

  static UserRole fromStorage(String? value) =>
      value == 'consumer' ? UserRole.consumer : UserRole.producer;

  bool get isProducer => this == UserRole.producer;
  String get label => isProducer ? 'Üretici' : 'Tüketici';
}
