import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wine_delivery_app/bloc/shipment/shipment_bloc.dart';
import 'package:wine_delivery_app/utils/form_state.dart';

import '../../../bloc/shipping_address/shipping_address_bloc.dart';

class ShippingAddressForm extends StatefulWidget {
  const ShippingAddressForm({super.key});

  @override
  State<ShippingAddressForm> createState() => _ShippingAddressFormState();
}

class _ShippingAddressFormState extends State<ShippingAddressForm> {
  final _formState = ShipmentFormState();
  String selectedCountry = 'United States';
  String selectedState = 'Alabama';

  @override
  void initState() {
    super.initState();
    context.read<ShippingAddressBloc>().add(ShippingAddressStarted());
    context.read<ShipmentBloc>().add(GetShipmentDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ShipmentBloc, ShipmentState>(
            builder: (context, state) {
              if (state is ShipmentLoaded) {
                selectedCountry = state.shipment.country!.isEmpty ? 'United States' : state.shipment.country!;
                selectedState = state.shipment.state!.isEmpty ? 'Alabama' : state.shipment.state!;
                _formState.fullNameController.text = state.shipment.fullName!;
                _formState.companyController.text = state.shipment.company!;
                _formState.addressController.text = state.shipment.address!;
                _formState.apartmentController.text = state.shipment.apartment!;
                _formState.cityController.text = state.shipment.city!;
                _formState.zipCodeController.text = state.shipment.zipCode!;
                _formState.noteController.text = state.shipment.note!;
              }
              return Form(
                key: _formState.formKey, // Assign the form key from ShipmentFormState
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shipping address',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    buildCountryFormField(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _formState.fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _formState.companyController,
                      decoration: const InputDecoration(
                        labelText: 'Company (optional)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _formState.addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _formState.apartmentController,
                      decoration: const InputDecoration(
                        labelText: 'Apartment, suite, etc. (optional)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildStateFormField(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _formState.cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _formState.zipCodeController,
                      decoration: const InputDecoration(
                        labelText: 'ZIP code',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your ZIP code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _formState.noteController,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Note',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your note';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 150,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate the form using _formState.formKey.currentState!.validate()
                            if (_formState.formKey.currentState!.validate()) {
                              // Handle form submission logic here
                              // Access form data using controllers or form state methods
                              String fullName = _formState.fullNameController.text;
                              String company = _formState.companyController.text;
                              String address = _formState.addressController.text;
                              String apartment = _formState.apartmentController.text;
                              String city = _formState.cityController.text;
                              String zipCode = _formState.zipCodeController.text;
                              String note = _formState.noteController.text;
                              String country = selectedCountry;
                              String state = selectedState;

                              context.read<ShipmentBloc>().add(
                                    SaveShipmentDetails(
                                      country: country,
                                      state: state,
                                      city: city,
                                      address: address,
                                      fullName: fullName,
                                      company: company,
                                      apartment: apartment,
                                      zipCode: zipCode,
                                      note: note,
                                    ),
                                  );

                              // Example: Show a success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Shipping address submitted successfully!'),
                                ),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  BlocBuilder<ShippingAddressBloc, ShippingAddressState> buildStateFormField() {
    return BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
      builder: (context, state) {
        return switch (state) {
          ShippingAddressLoading() => const CircularProgressIndicator(),
          ShippingAddressError() => const Text('Something went wrong!'),
          ShippingAddressLoaded() => DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'State'),
              value: selectedState,
              menuMaxHeight: .9.sh,
              iconEnabledColor: colorScheme(context).secondary,
              dropdownColor: colorScheme(context).surface,
              selectedItemBuilder: (context) {
                return state.countriesState.containsKey(selectedCountry)
                    ? state.countriesState[selectedCountry]!.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        );
                      }).toList()
                    : [];
              },
              items: state.countriesState.containsKey(selectedCountry)
                  ? state.countriesState[selectedCountry]!.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Card(
                          child: ListTile(title: Text(state)),
                        ),
                      );
                    }).toList()
                  : [],
              onChanged: (value) {
                setState(() {
                  selectedState = value!;
                });
              },
            ),
        };
      },
    );
  }

  BlocBuilder<ShippingAddressBloc, ShippingAddressState> buildCountryFormField() {
    return BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
      builder: (context, state) {
        return switch (state) {
          ShippingAddressLoading() => const CircularProgressIndicator(),
          ShippingAddressError() => const Text('Something went wrong!'),
          ShippingAddressLoaded() => DropdownButtonFormField<String>(
              menuMaxHeight: .9.sh,
              iconEnabledColor: colorScheme(context).secondary,
              dropdownColor: colorScheme(context).surface,
              selectedItemBuilder: (BuildContext context) {
                return state.countriesState.keys.map((String country) {
                  return Text(country);
                }).toList();
              },
              decoration: const InputDecoration(labelText: 'Country/Region'),
              value: selectedCountry,
              items: state.countriesState.keys.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Card(
                    child: ListTile(title: Text(country)),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value!;
                  selectedState = state.countriesState[selectedCountry]![0];
                });
              },
            ),
        };
      },
    );
  }

  ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
}
