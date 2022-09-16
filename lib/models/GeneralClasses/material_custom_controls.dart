import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomControls {
  List<int> selectedItems;
  CustomControls(this.selectedItems);
  textFormFieldWithoutValidation(TextEditingController t, String hint,
      IconData iconData, String initialvalue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: TextFormField(
        controller: t,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: hint,
            //hintText:  hint,
            //labelText: 'Text',

            prefixIcon: Icon(Icons.text_fields),
            // hintText: label,
            //  border: OutlineInputBorder()
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(8))),
      ),
    );
  }

  textFormField(TextEditingController t, String hint, IconData iconData,
      String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'الرجاء ملأ هذا الحقل';
          }
        },
        controller: t,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: hint,
            //hintText:  hint,
            //labelText: 'Text',

            prefixIcon: Icon(Icons.text_fields),
            // hintText: label,
            //  border: OutlineInputBorder()
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(8))),
      ),
    );
  }

  numberFormField(TextEditingController t, String hint, IconData iconData,
      String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'الرجاء ملأ هذا الحقل';
          }
        },
        controller: t,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: hint,
            //hintText:  hint,
            //labelText: 'Text',

            prefixIcon: Icon(Icons.filter_1),
            // hintText: label,
            //  border: OutlineInputBorder()
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  multiLineTextFormField(TextEditingController t, String hint,
      IconData iconData, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'الرجاء ملأ هذا الحقل';
          }
        },
        controller: t,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
            labelText: hint,
            //hintText:  hint,
            //labelText: 'Text',

            prefixIcon: Icon(Icons.text_fields),
            // hintText: label,
            //  border: OutlineInputBorder()
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(8))),
      ),
    );
  }

  dropDonwField(int index, List<DropItems> fillingArray, String hint,
      IconData iconData, String initialValue,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: new Container(
        child: new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                  icon: const Icon(Icons.arrow_drop_down_circle),
                  labelText: hint,
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              isEmpty: selectedItems[index] == '',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton(
                  value: selectedItems[index],
                  isDense: true,
                  onChanged: enabled
                      ? (val2) {
                          selectedItems[index] = val2;
                          state.didChange(val2);
                        }
                      : null,
                  isExpanded: true,
                  items: fillingArray.length > 0
                      ? fillingArray.map((DropItems drp) {
                          return new DropdownMenuItem(
                            value: drp.id,
                            child: new Text(drp.name),
                          );
                        }).toList()
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  dropDonwFieldWithOnChange(int index, List<DropItems> fillingArray,
      String hint, IconData iconData, String initialValue, onchangeFnc) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: new Container(
        child: new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                  icon: const Icon(Icons.arrow_drop_down_circle),
                  labelText: hint,
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              isEmpty: selectedItems[index] == '',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton(
                  value: selectedItems[index],
                  isDense: true,
                  onChanged: (val2) => onchangeFnc(val2),
                  isExpanded: true,
                  items: fillingArray.length > 0
                      ? fillingArray.map((DropItems drp) {
                          return new DropdownMenuItem(
                            value: drp.id,
                            child: new Text(drp.name),
                          );
                        }).toList()
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  dateTimePicker(BuildContext context, String dateController,
      String controlLabel, onchangeDate) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 15,
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: Text(
                    controlLabel,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2021, 1, 1),
                      maxTime: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      onConfirm: (date) => onchangeDate(date),
                      currentTime: DateTime.now(),
                      locale: LocaleType.ar);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $dateController",
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        " تغير",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ));
  }
}

class DropItems {
  int id;
  String name;
  DropItems(this.id, this.name);
}
