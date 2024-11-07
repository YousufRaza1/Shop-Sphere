import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/checkout_view_model.dart';

class AddressInputScreen extends StatefulWidget {
  @override
  _AddressInputScreenState createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final CheckoutController viewModel = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    _nameController.text = viewModel.address.value?.recipientsName ?? '';
    _phoneController.text = viewModel.address.value?.phoneNumber ?? '';
    _regionController.text = viewModel.address.value?.district ?? '';
    _addressController.text = viewModel.address.value?.address ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Address"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient's Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Recipient's Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the recipient's name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Phone Number Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a phone number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Region/City/District Field
              TextFormField(
                controller: _regionController,
                decoration: InputDecoration(
                  labelText: "Region/City/District",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the region/city/district";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Address Field
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Save Button
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      viewModel.updateAddressOfUser(_nameController.text,_phoneController.text,_regionController.text,_addressController.text);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Address saved successfully!")),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
