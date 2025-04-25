import 'package:flutter/material.dart';
import 'package:lettutor/common/dateSelection.dart';
import 'package:lettutor/common/timeRange.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';

class FakeTutorProvider extends ChangeNotifier {
  List<String> specialities = ['Math', 'Science', 'English', 'History'];
  List<String> nationalities = [
    'Foreign Tutor',
    'Vietnamese Tutor',
    'Native English Tutor',
  ];

  // Fake method for the search functionality
  void fakeSearch(
    String name,
    List<String> specialities,
    Map<String, bool> nationality,
  ) {
    print("Search parameters:");
    print("Name: $name");
    print("Specialities: $specialities");
    print("Nationalities: $nationality");
    // Just notify listeners to simulate a change
    notifyListeners();
  }
}

class FilterComponent extends StatefulWidget {
  final Function(String, List<String>, Map<String, bool>) onSearch;

  const FilterComponent({super.key, required this.onSearch});

  @override
  State<FilterComponent> createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  TextEditingController tutorNameController = TextEditingController();

  late List<String> specialities;
  List<String> nationalities = [
    'Foreign Tutor',
    'Vietnamese Tutor',
    'Native English Tutor',
  ];

  List<String> selectedNationalities = [];
  String selectedSpeciality = 'All';

  @override
  void initState() {
    super.initState();
    specialities = ['All', 'Math', 'Science', 'English', 'History'];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FakeTutorProvider(),
      child: Consumer<FakeTutorProvider>(
        builder: (context, tutorProvider, _) {
          return Container(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.findATutor,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Column(
                    children: [
                      Container(
                        child: TextField(
                          controller: tutorNameController,
                          onChanged: (text) {
                            widget.onSearch(
                              text,
                              convertSpeciality(selectedSpeciality),
                              convertNation(selectedNationalities),
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            hintText:
                                AppLocalizations.of(context)!.enterTutorName,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 36,
                        alignment: Alignment.center,
                        child: DropDownMultiSelect(
                          isDense: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          onChanged: (List<String> selected) {
                            setState(() {
                              widget.onSearch(
                                tutorNameController.text,
                                convertSpeciality(selectedSpeciality),
                                convertNation(selected),
                              );
                            });
                          },
                          options: nationalities,
                          selectedValues: selectedNationalities,
                          whenEmpty:
                              AppLocalizations.of(context)!.selectNationality,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.selectAvailableTime,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: DateSelectionWidget(),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TimeRangeSelector(),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      // Wrap(
                      //   spacing: 8.0,
                      //   children:
                      //       specialities.map((option) {
                      //         final isSelected = selectedSpeciality == option;
                      //         return FilterChip(
                      //           backgroundColor: Colors.grey.shade300,
                      //           label: Text(
                      //             option,
                      //             style: TextStyle(
                      //               color:
                      //                   isSelected
                      //                       ? Colors.white
                      //                       : Colors.black,
                      //               fontWeight: FontWeight.normal,
                      //             ),
                      //           ),
                      //           selected: isSelected,
                      //           onSelected: (isSelected) {
                      //             setState(() {
                      //               if (isSelected) {
                      //                 selectedSpeciality = option;
                      //                 widget.onSearch(
                      //                   tutorNameController.text,
                      //                   convertSpeciality(selectedSpeciality),
                      //                   convertNation(selectedNationalities),
                      //                 );
                      //               } else {
                      //                 selectedSpeciality = 'All';
                      //                 widget.onSearch(
                      //                   tutorNameController.text,
                      //                   [],
                      //                   convertNation(selectedNationalities),
                      //                 );
                      //               }
                      //             });
                      //           },
                      //           selectedColor: Colors.blue.shade500,
                      //           checkmarkColor: Colors.white,
                      //         );
                      //       }).toList(),
                      // ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      tutorNameController.text = '';
                      selectedSpeciality = 'All';
                      selectedNationalities = [];
                      widget.onSearch(
                        '',
                        convertSpeciality(selectedSpeciality),
                        convertNation(selectedNationalities),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Reset Filters',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, bool> convertNation(List<String> selectedNationalities) {
    Map<String, bool> result = {};
    for (var element in selectedNationalities) {
      if (element == 'Foreign Tutor') {
        result['isForeign'] = true;
      } else if (element == 'Vietnamese Tutor') {
        result['isVietnamese'] = true;
      } else if (element == 'Native English Tutor') {
        result['isNative'] = true;
      }
    }
    return result;
  }

  List<String> convertSpeciality(String selectedSpeciality) {
    List<String> result = [];
    if (selectedSpeciality == 'All') {
      return result;
    } else {
      result.add(selectedSpeciality.toLowerCase().replaceAll(' ', '-'));
      return result;
    }
  }
}
