import 'package:flutter/material.dart';
import 'package:google_maps_services_dart/google_maps_services_dart.dart';

class GoogleMapsPlaces {
  final String apiKey;

  GoogleMapsPlaces(this.apiKey);

  Future<List<Prediction>> getPlaceSuggestions(String query) async {
    final placesClient = GoogleMapsPlacesClient(apiKey);
    final predictions = await placesClient.autocomplete(query, types: ['geocode']);
    return predictions;
  }
}

class DeliveryLocation {
  List<Prediction> predictions;

  DeliveryLocation(this.predictions);
}

class DeliveryLocationDropDown extends StatefulWidget {
  final DeliveryLocation deliveryLocation;

  const DeliveryLocationDropDown({Key? key, required this.deliveryLocation}) : super(key: key);

  @override
  _DeliveryLocationDropDownState createState() => _DeliveryLocationDropDownState();
}

class _DeliveryLocationDropDownState extends State<DeliveryLocationDropDown> {
  final GoogleMapsPlaces _googleMapsPlaces = GoogleMapsPlaces('AIzaSyC6peV2tSrAFIWVTEeHxJ2GvESfN_DmTto');

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Prediction>(
      value: widget.deliveryLocation.predictions.first,
      items: widget.deliveryLocation.predictions.map((prediction) => DropdownMenuItem(
        value: prediction,
        child: Text(prediction.description),
      )).toList(),
      onChanged: (prediction) {
        setState(() {
          widget.deliveryLocation.predictions.insert(0, prediction);
        });
      },
      decoration: const InputDecoration(
        labelText: 'Delivery Location',
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deliveryLocation = DeliveryLocation([]);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter App'),
        ),
        body: Column(
          children: [
            DeliveryLocationDropDown(deliveryLocation: deliveryLocation),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Direct the user to a map if their location is not in the suggestion.
              },
              child: Text('Other'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
