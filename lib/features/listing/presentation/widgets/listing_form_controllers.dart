import 'package:flutter/material.dart';

/// Bundles the create/edit form's text controllers so [ListingFormScreen] can
/// own them (keeping values across step navigation) while the step widgets
/// stay stateless. Plain UI state — not business logic (constitution
/// §Architecture).
class ListingFormControllers {
  ListingFormControllers()
      : title = TextEditingController(),
        area = TextEditingController(),
        address = TextEditingController(),
        description = TextEditingController(),
        numberOfFloors = TextEditingController(),
        floorNumber = TextEditingController(),
        minimumLeaseTerm = TextEditingController(),
        annualRent = TextEditingController(),
        securityDepositMonths = TextEditingController();

  final TextEditingController title;
  final TextEditingController area;
  final TextEditingController address;
  final TextEditingController description;
  final TextEditingController numberOfFloors;
  final TextEditingController floorNumber;
  final TextEditingController minimumLeaseTerm;
  final TextEditingController annualRent;
  final TextEditingController securityDepositMonths;

  void dispose() {
    title.dispose();
    area.dispose();
    address.dispose();
    description.dispose();
    numberOfFloors.dispose();
    floorNumber.dispose();
    minimumLeaseTerm.dispose();
    annualRent.dispose();
    securityDepositMonths.dispose();
  }
}
