# generic_requester
Provides a generic mechanism for making API requests using the Dio HTTP client, with built-in support for automatic data serialization and mocking. It leverages interceptors for debugging and logging, allowing for flexible handling of various HTTP methods while ensuring that responses are decoded into specified model types.

## Features

- **Generic API Requests**: Easily perform GET, POST, PUT, DELETE, and PATCH requests.
- **Automatic Data Serialization**: Automatically decode responses into specified model types.
- **Mocking Support**: Easily mock responses for testing purposes.
- **Debugging and Logging**: Built-in support for logging requests and responses for easier debugging.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  jch_requester:
    git:
      url: https://github.com/Jewelch/generic_requester.git
```

## Example Usage

Here's an example of how to use the `performDecodingRequest` method:

```dart
FutureRequestResult<FavoriteProductsModel> getFavoriteProducts(
  String? userId, {
  required bool isHistory,
}) async {
  try {
    return Right(
      await performDecodingRequest(
        baseUrl: AppConfig.currentEnvironment.firebaseUrl,
        path:  "api/products/favorite",
        method: RestfullMethods.get,
        extraHeaders: {
          'Authorization': 'Bearer ${AppConfig.currentEnvironment.firebaseBearerToken}',
        },
        body: {
          "userId": userId,
        },
        decodableModel: FavoriteProductsModel(),
      ),
    );
  } on DioException catch (e) {
    return Left(e);
  }
}
```

## Author

**Jewel Cheriaa**  
Email: [jewelcheriaa@gmail.com](mailto:jewelcheriaa@gmail.com)
LinkedIn: [Jewel Cheriaa](https://www.linkedin.com/in/jewel-cheriaa/)
Mobile: +216 24 226 712  
WhatsApp: +33 7 43 10 44 25  

## Contributor

**Elarbi Chraiet**
- Email: elarbi.chraiet@gmail.com
- LinkedIn: [Elarbi Chraiet](https://www.linkedin.com/in/chraiet-elarbi-606b92138/)
- Mobile (WhatsApp): +33 7 66 06 31 2

## License
This package is licensed under the MIT License. See the LICENSE file for more details.
