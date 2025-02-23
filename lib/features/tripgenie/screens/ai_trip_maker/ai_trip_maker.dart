import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/common/widgets/custome_shapes/containers/primary_hader_container.dart';
import 'package:airsolo/features/tripgenie/controllers/ai_trip_maker_controller.dart';
import 'package:airsolo/features/tripgenie/screens/ai_trip_maker/ai_trip_results.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class AITripMakerScreen extends StatefulWidget {
  const AITripMakerScreen({super.key});

  @override
  _AITripMakerScreenState createState() => _AITripMakerScreenState();
}

class _AITripMakerScreenState extends State<AITripMakerScreen> {
  final TripMakerController _controller = TripMakerController();

  Future<void> _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _controller.updateDateRange(picked.start, picked.end);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [


            //Header Section
          
              APrimaryHeaderContainer(
                
                child: Column(
                children: [
          
                  /// Appbar
                  const AAppBar(showBackArrow: true,),
                  AAppBar(
                    title: Center(child: Text(ATexts.aiTripMakerTitle, style: Theme.of(context).textTheme.headlineMedium!.apply(color: AColors.white),)),),

                  const SizedBox(height: ASizes.spaceBtwSections *2,),
          
                ],
              )),









            // Content
            Padding(
              padding: const EdgeInsets.all(ASizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Enter Place To Travel
                  TextFormField(
                    controller: _controller.destinationController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.location),
                      labelText: ATexts.aiTripMakePlaceEnter,
                    ),
                  ),
                 
                  const SizedBox(height: ASizes.lg),



                  // Date Select 

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                       const Text("Select Date Range", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: _selectDateRange,
                          child: Text(_controller.startDate == null || _controller.endDate == null 
                              ? "Choose Dates"
                              : "${DateFormat.yMMMd().format(_controller.startDate!)} - ${DateFormat.yMMMd().format(_controller.endDate!)}"),
                        ),

                    ],
                  ),
                  const SizedBox(height: ASizes.md),


                   // Number of Guests

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                       const Text("Number of Guests", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Iconsax.minus), onPressed: () { setState(() => _controller.decreaseGuests()); }),
                          Text("${_controller.guests}", style: const TextStyle(fontSize: 18)),
                          IconButton(icon: const Icon(Iconsax.add), onPressed: () { setState(() => _controller.increaseGuests()); }),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: ASizes.md),





                  // Travel Preference

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                       const Text("Travel Preference", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: _controller.travelPreference,
                          onChanged: (value) => setState(() => _controller.updatePreference(value!)),
                          items: _controller.preferences.map((pref) => DropdownMenuItem(value: pref, child: Text(pref,style: Theme.of(context).textTheme.titleLarge,))).toList(),
                        ),
                    ],
                  ),

                  const SizedBox(height: ASizes.md *2),
              
                  
                  SizedBox( width:double.infinity, child: ElevatedButton(
                    onPressed: () => Get.to(()=> const TripResultsScreen()),//_controller.generateTrip, 
                    child: const Text(ATexts.aiTripMakeButton),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}