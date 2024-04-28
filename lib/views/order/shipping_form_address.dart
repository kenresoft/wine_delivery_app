import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/shipping_address/shipping_address_bloc.dart';

class ShippingAddressForm extends StatefulWidget {
  const ShippingAddressForm({super.key});

  @override
  State<ShippingAddressForm> createState() => _ShippingAddressFormState();
}

class _ShippingAddressFormState extends State<ShippingAddressForm> {
  String selectedCountry = 'United States';
  String selectedState = 'Alabama';

  @override
  void initState() {
    super.initState();
    context.read<ShippingAddressBloc>().add(ShippingAddressStarted());
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipping address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
                builder: (context, state) {
                  return switch (state) {
                    ShippingAddressLoading() => const CircularProgressIndicator(),
                    ShippingAddressError() => const Text('Something went wrong!'),
                    ShippingAddressLoaded() => DropdownButtonFormField<String>(
                        menuMaxHeight: .9.sh,
                        iconEnabledColor: colorScheme(context).secondary,
                        dropdownColor: colorScheme(context).background,
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
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Company (optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                decoration: const InputDecoration(
                  labelText: 'Apartment, suite, etc. (optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
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
              BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
                builder: (context, state) {
                  return switch (state) {
                    ShippingAddressLoading() => const CircularProgressIndicator(),
                    ShippingAddressError() => const Text('Something went wrong!'),
                    ShippingAddressLoaded() => DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'State'),
                        value: selectedState,
                        menuMaxHeight: .9.sh,
                        iconEnabledColor: colorScheme(context).secondary,
                        dropdownColor: colorScheme(context).background,
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
              ),
              const SizedBox(height: 16),
              TextFormField(
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
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 150,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle form submission
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
}
