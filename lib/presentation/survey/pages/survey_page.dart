
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _HomePageState();
}

class _HomePageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic FormBuilder Example'),
        backgroundColor: colors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              // Text Field
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  fillColor: colors.surface,
                  filled: true,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ]),
              ),
              const SizedBox(height: 16),

              // Dropdown
              FormBuilderDropdown<String>(
                name: 'gender',
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  fillColor: colors.surface,
                  filled: true,
                ),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
                    .toList(),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),

              // Radio
              FormBuilderRadioGroup<String>(
                name: 'color',
                decoration: const InputDecoration(
                  labelText: 'Favorite Color',
                ),
                options: ['Red', 'Green', 'Blue']
                    .map((color) => FormBuilderFieldOption(value: color))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Checkbox
              FormBuilderCheckboxGroup<String>(
                name: 'hobbies',
                decoration: const InputDecoration(
                  labelText: 'Hobbies',
                ),
                options: ['Reading', 'Travel', 'Gaming']
                    .map((hobby) => FormBuilderFieldOption(value: hobby))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Date
              FormBuilderDateTimePicker(
                name: 'birthdate',
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: 'Birthdate',
                  border: OutlineInputBorder(),
                  fillColor: colors.surface,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),

              // Slider
              FormBuilderSlider(
                name: 'age',
                min: 0,
                max: 100,
                divisions: 100,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ), initialValue: 3,
              ),
              const SizedBox(height: 16),

              // Switch
              FormBuilderSwitch(
                name: 'subscribe',
                title: const Text('Subscribe to newsletter'),
                initialValue: false,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final data = _formKey.currentState?.value;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Form Data'),
                        content: Text(data.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
