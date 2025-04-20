import 'package:flutter/material.dart';
import 'package:vintiora/core/theme/app_colors.dart';

class CartCouponSection extends StatefulWidget {
  final Function(String) onApplyCoupon;
  final VoidCallback onRemoveCoupon;
  final bool hasDiscount;

  const CartCouponSection({
    super.key,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
    required this.hasDiscount,
  });

  @override
  State<CartCouponSection> createState() => _CartCouponSectionState();
}

class _CartCouponSectionState extends State<CartCouponSection> {
  final _couponController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isExpanded = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasDiscount) {
      return _buildAppliedCouponView();
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.discount_outlined, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Apply Coupon Code',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _couponController,
                        decoration: InputDecoration(
                          hintText: 'Enter coupon code',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a coupon code';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _applyCoupon,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppliedCouponView() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coupon Applied',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Discount has been applied to your order',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: widget.onRemoveCoupon,
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade400,
              ),
              child: const Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }

  void _applyCoupon() {
    if (_formKey.currentState!.validate()) {
      widget.onApplyCoupon(_couponController.text.trim());
      _couponController.clear();
    }
  }
}
