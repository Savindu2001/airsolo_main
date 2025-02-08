import 'package:flutter/material.dart';

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('AirSolo',style: Theme.of(context).textTheme.headlineMedium,), 
        leading: const Icon(Icons.air),
        backgroundColor: Colors.amber,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
             Text('This is Solo Travelers ', style: Theme.of(context).textTheme.headlineLarge,),
             Text('Welcome to Sri Lanka',style: Theme.of(context).textTheme.headlineMedium,),
             Text('This App Helps to Tourists',style: Theme.of(context).textTheme.headlineSmall,),
             
            ElevatedButton(onPressed: (){}, child: const Text('Book My Hotel')),
            ElevatedButton(onPressed: (){}, child: const Text('Book My Taxi'))
          ],
        ),
        ),
    );
  }
}