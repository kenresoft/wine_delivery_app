import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/utils/asset_handler.dart';
import 'package:vintiora/shared/components/svg_wrapper.dart';

class CustomTextField<T> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final bool isPassword;
  final bool isRequired;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onPrefixIconTap;
  final VoidCallback? onSuffixIconTap;
  final double? width;
  final double? height;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final Color? focusColor;
  final Color? borderColor;
  final double borderWidth;
  final double? focusBorderWidth;
  final BorderRadius? focusBorderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final String? helperText;
  final int? helperMaxLines;

  // Dropdown-specific properties
  final List<DropdownMenuItem<T>>? items;
  final T? dropdownValue;
  final Function(T?)? onDropdownChanged;
  final bool showDropdownIcon;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.isPassword = false,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.onPrefixIconTap,
    this.onSuffixIconTap,
    this.width,
    this.height,
    this.maxLines = 1,
    this.maxLength,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.onSaved,
    this.decoration,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.borderRadius,
    this.fillColor,
    this.focusColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.focusBorderWidth,
    this.focusBorderRadius,
    this.contentPadding,
    this.margin,
    this.helperText,
    this.helperMaxLines,
    // Dropdown-specific properties
    this.items,
    this.dropdownValue,
    this.onDropdownChanged,
    this.showDropdownIcon = true,
  });

  @override
  State<CustomTextField<T>> createState() => _CustomTextFieldState<T>();
}

class _CustomTextFieldState<T> extends State<CustomTextField<T>> {
  late TextEditingController _controller;
  late ValueNotifier<bool> _obscureTextNotifier;
  late ValueNotifier<bool> _isFocusedNotifier;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _obscureTextNotifier = ValueNotifier(widget.isPassword);
    _isFocusedNotifier = ValueNotifier(false);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    _isFocusedNotifier.value = _focusNode.hasFocus;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _obscureTextNotifier.dispose();
    _isFocusedNotifier.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return widget.decoration ??
        InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          labelStyle: widget.labelStyle != null
              ? theme.textTheme.titleMedium?.merge(widget.labelStyle)
              : theme.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.darkInputText : AppColors.lightInputText,
                ),
          hintStyle: widget.hintStyle != null
              ? theme.textTheme.titleMedium?.merge(widget.hintStyle)
              : theme.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.grey5 : AppColors.white5,
                ),
          helperMaxLines: widget.helperMaxLines,
          filled: true,
          fillColor: widget.fillColor ?? (isDark ? AppColors.darkOutlinedBg : AppColors.lightOutlinedBg),
          contentPadding: widget.contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 14,
                vertical: (widget.height != null) ? (widget.height! - 16) / 2 : 14,
              ),
          border: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.borderColor ?? (isDark ? AppColors.darkEnabledBorder : AppColors.lightEnabledBorder),
              width: widget.borderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.borderColor ?? (isDark ? AppColors.darkEnabledBorder : AppColors.lightEnabledBorder),
              width: widget.borderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: widget.focusBorderRadius ?? widget.borderRadius ?? BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.focusColor ?? (isDark ? AppColors.darkFocusedBorder : AppColors.lightFocusedBorder),
              width: widget.focusBorderWidth ?? 2,
            ),
          ),
          prefixIcon: widget.prefixIcon != null
              ? GestureDetector(
                  onTap: widget.onPrefixIconTap,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: widget.prefixIcon,
                  ),
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: widget.onSuffixIconTap,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    child: widget.suffixIcon,
                  ),
                )
              : (widget.isPassword
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: IconButton(
                        icon: SvgWrapper(
                          _obscureTextNotifier.value ? Assets.passwordVisibilityOn : Assets.passwordVisibilityOn,
                          color: _isFocusedNotifier.value ? widget.focusColor ?? theme.primaryColor : Colors.grey,
                        ),
                        onPressed: () {
                          _obscureTextNotifier.value = !_obscureTextNotifier.value;
                        },
                      ),
                    )
                  : null),
          errorStyle: const TextStyle(height: 0.5),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: widget.width,
      margin: widget.margin,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.height ?? 48,
        ),
        child: widget.items != null
            ? DropdownButtonFormField<T>(
                value: widget.dropdownValue,
                items: widget.items,
                dropdownColor: theme.scaffoldBackgroundColor,
                onChanged: widget.onDropdownChanged,
                decoration: _buildDecoration(context),
                icon: widget.showDropdownIcon ? null : SizedBox(),
                style: widget.textStyle != null
                    ? theme.textTheme.displayMedium?.merge(widget.textStyle)
                    : theme.textTheme.displayMedium?.copyWith(
                        color: isDark ? AppColors.darkInputText : AppColors.lightInputText,
                      ),
                isExpanded: true,
                hint: Text(
                  widget.hintText ?? '',
                  style: widget.hintStyle != null
                      ? theme.textTheme.titleMedium?.merge(widget.hintStyle)
                      : theme.textTheme.titleMedium?.copyWith(
                          color: isDark ? AppColors.darkInputText : AppColors.lightInputText,
                          // color: isDark ? AppColors.grey5 : AppColors.white4,
                        ),
                ),
                validator: (value) {
                  if (widget.isRequired && (value == null)) {
                    return 'This field is required';
                  }
                  return widget.validator?.call(value?.toString());
                },
              )
            : ValueListenableBuilder<bool>(
                valueListenable: _obscureTextNotifier,
                builder: (context, obscureText, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isFocusedNotifier,
                    builder: (context, isFocused, _) {
                      return TextFormField(
                        controller: _controller,
                        focusNode: _focusNode,
                        obscureText: obscureText,
                        enabled: widget.enabled,
                        readOnly: widget.readOnly,
                        onTap: widget.onTap,
                        maxLines: widget.maxLines,
                        maxLength: widget.maxLength,
                        keyboardType: widget.keyboardType,
                        inputFormatters: widget.inputFormatters,
                        style: widget.textStyle != null
                            ? theme.textTheme.displayMedium?.merge(widget.textStyle)
                            : theme.textTheme.displayMedium?.copyWith(
                                color: isDark ? AppColors.darkInputText : AppColors.lightInputText,
                              ),
                        onChanged: widget.onChanged,
                        onFieldSubmitted: widget.onSubmitted,
                        validator: widget.validator,
                        onSaved: widget.onSaved,
                        decoration: _buildDecoration(context),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
