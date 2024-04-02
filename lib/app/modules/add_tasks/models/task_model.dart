import 'dart:convert';

class TaskModel {
  TaskModel({
    required this.name,
    required this.description,
    this.completed,
    required this.time,
    this.id,
  });

  final String name;
  final String description;
  int? completed;
  final String time;
  final String? id;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "description": description,
      "completed": completed,
      "time": time,
      "id": id,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      name: map['name'],
      description: map['description'],
      completed: map['completed'],
      time: map['time'],
      id: map['id'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddTaskModel(name: $name, description: $description completed: $completed time: $time, id: $id)';
  }
}
