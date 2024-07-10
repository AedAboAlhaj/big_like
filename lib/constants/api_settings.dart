class ApiSettings {
  static const String _baseUrl = 'https://ba.biglike.app/api/v1/';
  static const String requirements = '${_baseUrl}workers/requirements';
  static const String services = '${_baseUrl}customers/services';
  static const String schedule = '${_baseUrl}customers/schedule';
  static const String workers = '${_baseUrl}customers/workers';
  static const String register = '${_baseUrl}customers/auth/signup';
  static const String login = '${_baseUrl}auth/login';
  static const String checkOtp = '${_baseUrl}auth/check';
  static const String settings = '${_baseUrl}customers/settings';
  static const String orders = '${_baseUrl}customers/orders';
  static const String ordersService = '$orders/service';
  static const String ordersProducts = '$orders/products';
  static const String cards = '${_baseUrl}customers/payments/cards';
  static const String payments = '${_baseUrl}customers/payments/store';
  static const String paymentsInfo = '${_baseUrl}customers/payments/info';
  static const String companyProfilePages = '${_baseUrl}customers/definitions';
  static const String products = '${_baseUrl}customers/products';
  static const String banners = '${_baseUrl}customers/banners';
  static const String workersSchedule = '${_baseUrl}workers/schedule';
  static const String workersOrders = '${_baseUrl}workers/orders';
  static const String workersOrdersStatus = '${_baseUrl}workers/orders/status';
}
