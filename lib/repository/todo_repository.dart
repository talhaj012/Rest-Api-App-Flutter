
import 'package:rest_api_app/models/todo.dart';
import 'package:rest_api_app/repository/repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoRepository implements Repository{
  String dataURL = 'https://jsonplaceholder.typicode.com';

  @override
  Future<String> deleteTodo(Todo todo) async{
    var url = Uri.parse('$dataURL/todos/${todo.id}');
    var result = 'false';
    await http.delete(url).then((value) {

      print(value.body);

      return result = 'true';
    }
    );
    return result;
  }


  //  GET
  @override
  Future<List<Todo>> getTodoList() async{
    List<Todo> todoList = [];
    var url = Uri.parse('$dataURL/todos');
    var response = await http.get(url);
    print('Status Code : ${response.statusCode}');
    var body = json.decode(response.body);

    for(var i=0 ; i<body.length ; i++){
      todoList.add(Todo.fromJson(body[i]));
    }

    return todoList;

  }

  // PATCH

  @override
  Future<String> patchCompleted(Todo todo) async{
    var url = Uri.parse('$dataURL/todos/${todo.id}');

    String resData = '';

    var response = await http.patch(
        url,
        body: {
      'completed': {todo.completed}.toString(),},
        headers: {'Authorization':'your_token'}
    ).then((response) {
      Map<String,dynamic> result = json.decode(response.body);
      print(result);
      return resData = result['completed'];
    });

    return resData;
  }



  @override
  Future<String> putCompleted(Todo todo) async{
    var url = Uri.parse('$dataURL/todos/${todo.id}');

    String resData = '';

    var response = await http.put(
        url,
        body: {
          'completed': {todo.completed}.toString(),},
        headers: {'Authorization':'your_token'}
    ).then((response) {
      Map<String,dynamic> result = json.decode(response.body);
      print(result);
      return resData = result['completed'];
    });

    return resData;
  }


  @override
  Future<String> postTodo(Todo todo) async{
    print('${todo.toJson()}');
    var url = Uri.parse('$dataURL/todos/');
    var result = '';
    var response = await http.post(url,body: todo.toJson());
    print(response.statusCode);
    print(response.body);
    return 'true';

  }
}