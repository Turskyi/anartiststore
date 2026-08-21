import 'package:anartiststore/model/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate('contact_title'))),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (BuildContext context, Widget? child, AppStateModel model) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: translate('contact_name_label'),
                    hintText: translate('contact_name_hint'),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return translate('firstNameRequired');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: translate('contact_email_label'),
                    hintText: translate('contact_email_hint'),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return translate('emailIsRequired');
                    }
                    if (!value.contains('@')) {
                      return translate('enterValidEmail');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: translate('contact_message_label'),
                    hintText: translate('contact_message_hint'),
                  ),
                  maxLines: 5,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return translate('contact_message_label');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () => _submitForm(model),
                    child: Text(translate('contact_submit_button')),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitForm(AppStateModel model) async {
    final FormState? formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await model.sendContactMessage(
          name: _nameController.text,
          email: _emailController.text,
          message: _messageController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(translate('contact_success_message'))),
          );
          formState.reset();
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(translate('contact_error_message'))),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
