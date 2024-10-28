enum OrderStatus {
  draft,
  pending,
  processing,
  packaging,
  shipping,
  delivered,
  cancelled,
}

enum WineCategory {
  red,
  white,
  rose,
  sparkling,
  dessert,
  fortified,
  organic,
  biodynamic,
  natural,
  kosher,
  lowSulfur,
  nonAlcoholic,
  vegan,
}

enum RequestMethod {
  get,
  post,
  put,
  delete,
}

enum ErrorType {
  route,
  network,
  timeout,
  unknown,
  authentication,
  permission,
  initialization,
}