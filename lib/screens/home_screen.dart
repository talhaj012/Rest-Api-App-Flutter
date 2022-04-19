import 'package:flutter/material.dart';
import 'package:rest_api_app/controller/todo_controller.dart';
import 'package:rest_api_app/models/todo.dart';
import 'package:rest_api_app/repository/todo_repository.dart';

class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //dependency injection
    var todoController = TodoController(TodoRepository());

    // test
    // todoController.fetchTodoList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Rest Api App'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: todoController.fetchTodoList(),
        builder: (context,snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError){
            return Center(
              child: Text('Error Occoured'),
            );
          }

          return buildBodyContent(snapshot, todoController);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Todo todo = Todo(userId: 3, title: 'Sample Post', completed: false);
          todoController.postTodo(todo);
          },
        child: Icon(Icons.add),
      ),
    );
  }

  SafeArea buildBodyContent(AsyncSnapshot<List<Todo>> snapshot, TodoController todoController) {
    return SafeArea(
          child: ListView.separated(
              itemBuilder: (context, index){
                var todo = snapshot.data![index];
                return Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(flex:1 ,child: Text('${todo.id}')),
                      Expanded(flex:3 ,child: Text('${todo.title}')),
                      Expanded(
                          flex:3 ,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                child: buildCallContainer('patch', Colors.orange),
                                onTap: (){
                                  todoController.updatePatchCompleted(todo)
                                      .then((value) =>
                                      ScaffoldMessenger
                                          .of(context)
                                          .showSnackBar(
                                          SnackBar(content: Text('$value'),)));
                                },
                              ),
                              InkWell(
                                  child: buildCallContainer('put', Colors.blue),
                                  onTap: (){
                                    todoController.updatePutCompleted(todo);
                                  },
                              ),
                              InkWell(
                                  child: buildCallContainer('delete', Colors.red),
                                  onTap: (){
                                    todoController.deleteTodo(todo) .then((value) =>
                                        ScaffoldMessenger
                                            .of(context)
                                            .showSnackBar(
                                            SnackBar(content: Text('$value'),)));
                                  },
                              ),
                            ],
                          )),
                    ],
                  ),
                );
              },
              separatorBuilder: (context,index){
                return Divider(thickness: .5, height: .5,);
              },
              itemCount: snapshot.data?.length ?? 0),
        );
  }

  Container buildCallContainer(String title, Color color) {
    return Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: Text('$title')),
        );
  }
}
