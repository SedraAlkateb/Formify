import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/presentation/question/page/view_Question.dart';
import 'package:formify/web_form/answer_mapper.dart';
import 'package:formify/web_form/web_form_api.dart';

class WebFormPage extends StatefulWidget {
  final String token;
  const WebFormPage({super.key, required this.token});

  @override
  State<WebFormPage> createState() => _WebFormPageState();
}

class _WebFormPageState extends State<WebFormPage> {
  final _api = WebFormApi();
  final _formKey = GlobalKey<FormBuilderState>();
  late Future<WebFormData> _future;
  bool _sending = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchForm(widget.token);
  }

  Future<void> _submit(WebFormData data) async {
    final fs = _formKey.currentState!;
    if (!fs.saveAndValidate()) return;
    final answers = [
      for (final q in data.questions)
        MapEntry(q, mapToAnswers(q, fs.value['q_${q.order}'])),
    ];
    final payload = _api.buildPayload(widget.token, {
      'fullname': '${fs.value['respondent_name'] ?? ''}'.trim(),
      'phone': '${fs.value['respondent_phone'] ?? ''}'.trim(),
    }, answers);

    setState(() => _sending = true);
    try {
      await _api.submit(widget.token, payload);
      if (!mounted) return;
      setState(() => _done = true);
      if (WebFormApi.isDemo(widget.token)) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('وضع تجريبي - البيانات التي ستُرسل'),
            content: SingleChildScrollView(
              child: SelectableText(
                const JsonEncoder.withIndent('  ').convert(payload),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر الإرسال، حاول مرة أخرى')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WebFormData>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return const Center(child: Text('الرابط غير صالح أو منتهي'));
          }
          if (_done) {
            return const Center(
              child: Text('شكراً لك، تم إرسال إجاباتك',
                  style: TextStyle(fontSize: 22)),
            );
          }
          final data = snap.data!;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: FormBuilder(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(data.title,
                        style: Theme.of(context).textTheme.headlineSmall),
                    if (data.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(data.description),
                      ),
                    const SizedBox(height: 20),
                    FormBuilderTextField(
                      name: 'respondent_name',
                      decoration: const InputDecoration(
                          labelText: 'الاسم الكامل',
                          border: OutlineInputBorder()),
                      validator: FormBuilderValidators.required(
                          errorText: 'هذا الحقل مطلوب'),
                    ),
                    const SizedBox(height: 12),
                    FormBuilderTextField(
                      name: 'respondent_phone',
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          border: OutlineInputBorder()),
                    ),
                    for (final q in data.questions)
                      if (q.type != QuestionType.generic)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (q.type != QuestionType.switchField)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    q.isRequired ? '${q.title} *' : q.title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              QuestionPreviewBuilder(question: q),
                            ],
                          ),
                        ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _sending ? null : () => _submit(data),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(_sending ? '...' : 'إرسال'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
