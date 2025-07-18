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
  generic_requester:
    git:
      url: https://github.com/Jewelch/generic_requester.git
```

## Model Requirements

All models used with `generic_requester` must implement the `ModelingProtocol` interface to ensure proper deserialization. Here's an example:

```dart
class TodoModel extends ModelingProtocol {
  final int? id;
  final String? title;
  final bool? isCompleted;
  final int? userId;

  TodoModel({this.id, this.title, this.isCompleted, this.userId});

  @override
  fromJson(json) => TodoModel(
    id: json['id'] as int?,
    title: json['todo'] as String?,
    isCompleted: json['completed'] as bool?,
    userId: json['userId'] as int?,
  );
}
```

## Example Usage

Here's an example of how to use the `performDecodingRequest` method:

```dart
FutureRequestResult<TodoModel> getTodoById(int id) async {
  try {
    return Right(
      await performDecodingRequest(
        baseUrl: "https://dummyjson.com/",
        path:  "todos/$id",
        method: RestfullMethods.get,
        extraHeaders: {
          'Authorization': 'Bearer ${AppConfig.currentEnvironment.firebaseBearerToken}',
        },
        queryParemeters: {
          'url_key': 'value',
        },
        body: {
          "body_key": "value",
        },
        decodableModel: TodoModel(),
      ),
    );
  } on DioException catch (e) {
    return Left(e);
  }
}
```

## Author

**Jewel Cheriaa**  
- Email: [jewelcheriaa@gmail.com](mailto:jewelcheriaa@gmail.com)
- LinkedIn: [Jewel Cheriaa](https://www.linkedin.com/in/jewel-cheriaa/)
- Mobile: +216 24 226 712  
- WhatsApp: +33 7 43 10 44 25  

## Contributor

**Elarbi Chraiet**
- Email: elarbi.chraiet@gmail.com
- LinkedIn: [Elarbi Chraiet](https://www.linkedin.com/in/chraiet-elarbi-606b92138/)
- Mobile (WhatsApp): +33 7 66 06 31 2

## License
This package is licensed under the MIT License. See the LICENSE file for more details.
