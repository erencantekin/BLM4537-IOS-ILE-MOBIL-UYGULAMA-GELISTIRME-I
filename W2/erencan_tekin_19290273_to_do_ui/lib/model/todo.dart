class ToDo{
  String? id;
  String? todoTitle;
  String? todoDescription;
  //int todoPriority;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoTitle,
    required this.todoDescription,
    //required this.todoPriority,
    this.isDone=false,
  });
}