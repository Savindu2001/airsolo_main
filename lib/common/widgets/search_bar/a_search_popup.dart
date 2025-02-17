import 'package:airsolo/common/widgets/search_bar/a_result.dart';
import 'package:flutter/material.dart';

class SearchPopup extends StatefulWidget {
  @override
  _SearchPopupState createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _placeController = TextEditingController();
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
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _placeController,
                          decoration: InputDecoration(labelText: "Enter destination"),
                          onSubmitted: (value) => _goToNextTab(),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(onPressed: _goToNextTab, child: Text("Next")),
                      ],
                    ),
                  ),
        
                  // Tab 2: Enter Date
                  Padding(
                    padding: EdgeInsets.all(16),
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
                        SizedBox(height: 20),
                        ElevatedButton(onPressed: _goToNextTab, child: Text("Next")),
                      ],
                    ),
                  ),
        
                  // Tab 3: Enter Number of Guests
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text("Number of Guests"),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(icon: Icon(Icons.remove), onPressed: () {
                              if (_guests > 1) setState(() => _guests--);
                            }),
                            Text("$_guests", style: TextStyle(fontSize: 18)),
                            IconButton(icon: Icon(Icons.add), onPressed: () {
                              setState(() => _guests++);
                            }),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(onPressed: _search, child: Text("Search")),
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