bool firstOpening = true; // to prevent UI crashed during fetching Tasks from API while transition between pages made too fast

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