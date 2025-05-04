import 'package:flutter/material.dart';
import 'package:lettutor/data/model/user/learn_topic.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:multiselect/multiselect.dart';

class FilterComponent extends StatefulWidget {
  final Function(String, List<String>, Map<String, bool>) onSearch;
  final List<LearnTopic> specialities;

  const FilterComponent({
    super.key,
    required this.onSearch,
    required this.specialities,
  });

  @override
  State<FilterComponent> createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  TextEditingController tutorNameController = TextEditingController();
  List<String> selectedNationalities = [];
  String selectedSpeciality = 'All'; // Mặc định là 'All'

  List<String> nationalities = [
    'Foreign Tutor',
    'Vietnamese Tutor',
    'Native English Tutor',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.findATutor,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              children: [
                TextField(
                  controller: tutorNameController,
                  onChanged: (text) {
                    widget.onSearch(text, [
                      selectedSpeciality,
                    ], convertNation(selectedNationalities));
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    hintText: AppLocalizations.of(context)!.enterTutorName,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(height: 12),
                DropDownMultiSelect(
                  isDense: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                  ),
                  onChanged: (List<String> selected) {
                    setState(() {
                      selectedNationalities = selected;
                      widget.onSearch(tutorNameController.text, [
                        selectedSpeciality,
                      ], convertNation(selected));
                    });
                  },
                  options: nationalities,
                  selectedValues: selectedNationalities,
                  whenEmpty: AppLocalizations.of(context)!.selectNationality,
                ),
              ],
            ),
          ),
          if (widget.specialities.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8.0,
                children: [
                  // Hiển thị "All" như là tùy chọn mặc định
                  FilterChip(
                    backgroundColor: Colors.grey.shade100,
                    label: Text(
                      'All',
                      style: TextStyle(
                        color:
                            selectedSpeciality == 'All'
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                    selected: selectedSpeciality == 'All',
                    onSelected: (isSelected) {
                      setState(() {
                        selectedSpeciality = isSelected ? 'All' : 'All';
                        widget.onSearch(
                          tutorNameController.text,
                          [selectedSpeciality],
                          convertNation(selectedNationalities),
                        );
                      });
                    },
                    selectedColor: Colors.blue.shade500,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  // Hiển thị các chuyên ngành khác
                  ...widget.specialities.map((learnTopic) {
                    final isSelected = selectedSpeciality == learnTopic.key;
                    return FilterChip(
                      backgroundColor: Colors.grey.shade100,
                      label: Text(
                        learnTopic.name ?? 'N/A',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (isSelected) {
                        setState(() {
                          selectedSpeciality =
                              isSelected ? (learnTopic.key ?? 'All') : 'All';
                          widget.onSearch(
                            tutorNameController.text,
                            [selectedSpeciality],
                            convertNation(selectedNationalities),
                          );
                        });
                      },
                      selectedColor: Colors.blue.shade500,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }),
                ],
              ),
            ),
          Container(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  tutorNameController.clear();
                  selectedSpeciality = 'All';
                  selectedNationalities.clear();
                });
                widget.onSearch('', [], {});
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
              child: Text(
                AppLocalizations.of(context)!.resetFilter,
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, bool> convertNation(List<String> selectedNationalities) {
    final result = <String, bool>{};
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
}
