import 'package:airsolo/common/widgets/search_bar/a_result.dart';
import 'package:flutter/material.dart';

class SearchPopup extends StatefulWidget {
  const SearchPopup({super.key});

  @override
  _SearchPopupState createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _placeController = TextEditingController();
  DateTime? _selectedDate;
  int _guests = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _goToNextTab() {
    if (_tabController.index < 2) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void _search() {
    Navigator.pop(context); // Close the popup
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(
          place: _placeController.text,
          date: _selectedDate,
          guests: _guests,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const[
                Tab(text: "Location"),
                Tab(text: "Date"),
                Tab(text: "Guests"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Enter Place
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _placeController,
                          decoration: const InputDecoration(labelText: "Enter destination"),
                          onSubmitted: (value) => _goToNextTab(),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(onPressed: _goToNextTab, child: const Text("Next")),
                      ],
                    ),
                  ),
        
                  // Tab 2: Enter Date
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() => _selectedDate = pickedDate);
                              _goToNextTab();
                            }
                          },
                          child: Text(_selectedDate == null ? "Select Date" : "Date: ${_selectedDate!.toLocal()}".split(' ')[0]),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(onPressed: _goToNextTab, child: const Text("Next")),
                      ],
                    ),
                  ),
        
                  // Tab 3: Enter Number of Guests
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text("Number of Guests"),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(icon: const Icon(Icons.remove), onPressed: () {
                              if (_guests > 1) setState(() => _guests--);
                            }),
                            Text("$_guests", style: const TextStyle(fontSize: 18)),
                            IconButton(icon: const Icon(Icons.add), onPressed: () {
                              setState(() => _guests++);
                            }),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(onPressed: _search, child: const Text("Search")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





/* 

1. Design Popup Search Page
2. MAke default Calendar (check in , checkout)
3. number of guests
4.result page
5. data save to cashe memory for use next ,   show results

*/