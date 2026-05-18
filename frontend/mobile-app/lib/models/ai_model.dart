class AiModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final String status;

  const AiModel({
    required this.id, 
    required this.name, 
    required this.description, 
    required this.type, 
    required this.status
  });
  

  factory AiModel.fromJson(Map<String, dynamic> json) {
    return AiModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      status: json['status']
    );
  } 
}