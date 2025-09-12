# Business Rules - Medical Discount System

## Overview
This document describes the business rules implemented in the Poison Store medical discount system, which allows registered medical professionals to generate automatic discounts on medication sales when the patient presents a prescription with their CRM.

## Main Features

### 1. Medical Professional Registration
- **Required fields**: Name, CRM, Specialty, Discount Percentage
- **Optional fields**: Phone, Email, Complete Address, Notes
- **Validations**:
  - CRM must be unique in the system
  - CRM must contain only numbers (2 to 10 digits)
  - Discount percentage must be between 0% and 50%
  - Email must have valid format (if provided)

### 2. Automatic Discount System
- **Activation**: Discount is automatically applied when:
  - The sale is marked as "with medical prescription"
  - The doctor's CRM is provided
  - The CRM exists in the system and is active
  - The medical professional is registered and active

- **Discount Calculation**:
  - Discount = (Original Price × Discount Percentage) ÷ 100
  - Final Price = Original Price - Discount
  - All values are rounded to 2 decimal places

### 3. Security Validations
- **Inactive CRM**: Inactive professionals cannot generate discounts
- **Prescription Required**: Discount is only applied with medical prescription
- **Valid CRM**: Only CRMs registered in the system are accepted
- **CRM Format**: Validation of numeric format (2-10 digits)

## Sales Flow with Discount

### Step by Step:
1. **Medication Selection**: Client chooses the medication
2. **Client Information**: Personal data is filled in
3. **Medical Prescription**: Check "Sold with Medical Prescription" checkbox
4. **Doctor Data**: Fill in doctor's name and CRM
5. **CRM Validation**: System automatically searches for the CRM
6. **Discount Application**: Discount is calculated and applied
7. **Confirmation**: System shows information about the applied discount
8. **Finalization**: Sale is recorded with the discounted final price

### Additional Fields in Sale:
- `discount_percentage`: Applied discount percentage
- `discount_applied`: Discount value in currency
- `original_price`: Original price (quantity × unit price)
- `final_price`: Final price after discount
- `total_price`: Total sale price (same as final_price)

## User Interface

### Sales Screen:
- **CRM Field**: With integrated search button
- **Search Result**: Shows information about the found doctor
- **Discount Information**: Displays details of the applied discount
- **Automatic Calculation**: Price is automatically recalculated

### Sales Listing:
- **Discount Column**: Shows discount percentage and value
- **Total Price**: Displays original price crossed out and final price
- **Doctor Information**: CRM and doctor's name (if applicable)

## Reports and Queries

### CRM Search:
- Endpoint: `GET /medical_professionals/search_by_crm?crm=12345`
- Returns professional information if found
- Used for real-time validation during sale

### Available Filters:
- By medical specialty
- By city
- By status (active/inactive)
- Search by name, CRM or specialty

## Specific Business Rules

### 1. Discount Application
- ✅ **Allowed**: Sale with prescription + Valid CRM + Active Professional
- ❌ **Not Allowed**: Sale without prescription
- ❌ **Not Allowed**: Unregistered CRM
- ❌ **Not Allowed**: Inactive professional

### 2. CRM Validations
- Format: Numbers only
- Size: 2 to 10 digits
- Uniqueness: CRM must be unique in the system
- Status: Professional must be active

### 3. Price Calculation
- **Original Price**: Quantity × Unit Price
- **Discount**: (Original Price × Percentage) ÷ 100
- **Final Price**: Original Price - Discount
- **Rounding**: 2 decimal places

### 4. Auditing
- All sales with discount record:
  - Doctor's CRM
  - Applied discount percentage
  - Discount value
  - Original and final price
  - Application date and time

## Practical Examples

### Example 1: 15% Discount
- **Medication**: $50.00
- **Quantity**: 2 units
- **Original Price**: $100.00
- **Discount**: 15% = $15.00
- **Final Price**: $85.00

### Example 2: 20% Discount
- **Medication**: $75.00
- **Quantity**: 1 unit
- **Original Price**: $75.00
- **Discount**: 20% = $15.00
- **Final Price**: $60.00

## Maintenance and Configuration

### Professional Management:
- **Activation/Deactivation**: Professional status control
- **Discount Editing**: Percentage changes
- **History**: Change tracking
- **Backup**: Data is preserved even when inactive

### System Configuration:
- **Discount Limit**: Maximum of 50%
- **Format Validation**: Regex for CRM
- **Cache**: Optimized professional search
- **Logs**: Recording of all operations

## Technical Considerations

### Performance:
- Database indexes for CRM and status
- Cache of active professionals
- Real-time validation via AJAX

### Security:
- Input validation for CRM
- Data sanitization
- Session-based access control

### Scalability:
- Flexible model for new fields
- REST API for future integrations
- Structure prepared for multiple pharmacies

## Conclusion

The implemented medical discount system ensures:
- **Compliance**: Only registered professionals generate discounts
- **Transparency**: Client clearly sees the applied discount
- **Control**: Complete management of professionals and discounts
- **Auditing**: Complete tracking of all operations
- **Flexibility**: Individual percentage configuration per doctor

This system meets the regulatory and commercial needs of the pharmacy, providing a transparent experience for clients and total control for management.
this is second rule
@kody-sync