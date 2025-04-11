enum Routes {
  // Intro
  splash('/splash'),
  onBoarding('/onBoarding'),
  error('/error'),

  // Auth
  register('/register'),
  login('/login'),

  // Main Navigation
  main('/main'),
  favorites('/favorites'),
  products('/products'),
  productDetails('/productDetails'),
  orderConfirmation('/orderConfirmation'),
  orderHistory('/orderHistory'),
  orderTracking('/orderTracking'),
  cart('/cart'),
  checkout('/checkout'),
  address('/address'),
  profile('/profile'),
  settings('/settings'),
  notifications('/notifications');

  //

  final String path;

  const Routes(this.path);

  /// Enhanced route parsing and validation
  static Routes? fromPath(String path) {
    try {
      return Routes.values.firstWhere((route) => route.path == path);
    } catch (e) {
      return null;
    }
  }
}
