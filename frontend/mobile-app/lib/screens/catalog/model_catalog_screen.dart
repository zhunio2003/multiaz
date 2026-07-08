import 'package:flutter/material.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/models/ai_model.dart';
import 'package:mobile_app/services/model_service.dart';

class ModelCatalogScreen extends StatefulWidget{

  const ModelCatalogScreen({super.key});

  @override
  State<ModelCatalogScreen> createState() => _ModelCatalogScreenState();

}

class _ModelCatalogScreenState extends State<ModelCatalogScreen> {

  late Future<List<AiModel>> _modelsFuture;

  @override
  void initState() {
    
    super.initState();

    _modelsFuture = ModelService(ApiClient(null)).getActiveModels();

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: FutureBuilder<List<AiModel>>(
        future: _modelsFuture,
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError) {
            return const Center(child: Text('Error'),);
          }

          final models = snapshot.data!;

          if(models.isEmpty) {
            return Center(child: Text("No hay modelos disponibles"),);
          }

          return ListView.builder(
            itemCount: models.length,
            itemBuilder: (context, index) {

              final model = models[index];

              return ListTile(
                title: Text(model.name),
                subtitle: Text(model.description),
                trailing: Text(model.type),
                onTap: () {
                  Navigator.pushNamed(context, '/predict', arguments: model);
                },
              );
              
            },
          );

        }
      ),
    );
    
  }
  
}