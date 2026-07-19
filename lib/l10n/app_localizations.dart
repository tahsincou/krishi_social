import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Krishi Media'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @searchProductOrLocation.
  ///
  /// In en, this message translates to:
  /// **'Search product or location'**
  String get searchProductOrLocation;

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// No description provided for @fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// No description provided for @crops.
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get crops;

  /// No description provided for @poultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get poultry;

  /// No description provided for @eggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get eggs;

  /// No description provided for @dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get dairy;

  /// No description provided for @fish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fish;

  /// No description provided for @livestock.
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get livestock;

  /// No description provided for @honey.
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get honey;

  /// No description provided for @nursery.
  ///
  /// In en, this message translates to:
  /// **'Nursery'**
  String get nursery;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @noMatchingPosts.
  ///
  /// In en, this message translates to:
  /// **'No matching posts found'**
  String get noMatchingPosts;

  /// No description provided for @tryAnotherProductOrCategory.
  ///
  /// In en, this message translates to:
  /// **'Try another product or category.'**
  String get tryAnotherProductOrCategory;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @reviewedBuyer.
  ///
  /// In en, this message translates to:
  /// **'Reviewed Buyer'**
  String get reviewedBuyer;

  /// No description provided for @newBuyer.
  ///
  /// In en, this message translates to:
  /// **'New Buyer'**
  String get newBuyer;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @createBuyPost.
  ///
  /// In en, this message translates to:
  /// **'Create Buy Post'**
  String get createBuyPost;

  /// No description provided for @createSellPost.
  ///
  /// In en, this message translates to:
  /// **'Create Sell Post'**
  String get createSellPost;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @selectOrTypeProduct.
  ///
  /// In en, this message translates to:
  /// **'Select or type a product'**
  String get selectOrTypeProduct;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @requiredBetween.
  ///
  /// In en, this message translates to:
  /// **'Required between'**
  String get requiredBetween;

  /// No description provided for @availableBetween.
  ///
  /// In en, this message translates to:
  /// **'Available between'**
  String get availableBetween;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get selectDateRange;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @upazila.
  ///
  /// In en, this message translates to:
  /// **'Upazila'**
  String get upazila;

  /// No description provided for @targetPriceOptional.
  ///
  /// In en, this message translates to:
  /// **'Target price per unit (optional)'**
  String get targetPriceOptional;

  /// No description provided for @expectedPriceOptional.
  ///
  /// In en, this message translates to:
  /// **'Expected price per unit (optional)'**
  String get expectedPriceOptional;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @publishPost.
  ///
  /// In en, this message translates to:
  /// **'Publish Post'**
  String get publishPost;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategory;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter a product name'**
  String get enterProductName;

  /// No description provided for @enterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid quantity'**
  String get enterValidQuantity;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @postCreated.
  ///
  /// In en, this message translates to:
  /// **'Post created'**
  String get postCreated;

  /// No description provided for @moreInformationOptional.
  ///
  /// In en, this message translates to:
  /// **'More information (optional)'**
  String get moreInformationOptional;

  /// No description provided for @qualityOptional.
  ///
  /// In en, this message translates to:
  /// **'Quality or size (optional)'**
  String get qualityOptional;

  /// No description provided for @selectCategoryFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a category first'**
  String get selectCategoryFirst;

  /// No description provided for @productSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search or type a product'**
  String get productSearchHint;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @districtAndUpazila.
  ///
  /// In en, this message translates to:
  /// **'District and upazila'**
  String get districtAndUpazila;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// No description provided for @findingLocation.
  ///
  /// In en, this message translates to:
  /// **'Finding location...'**
  String get findingLocation;

  /// No description provided for @addressOrArea.
  ///
  /// In en, this message translates to:
  /// **'Address or area'**
  String get addressOrArea;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Village, market or nearby place'**
  String get addressHint;

  /// No description provided for @detectedDistrict.
  ///
  /// In en, this message translates to:
  /// **'Detected district: {district}'**
  String detectedDistrict(String district);

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not find your location'**
  String get locationUnavailable;

  /// No description provided for @locationExample.
  ///
  /// In en, this message translates to:
  /// **'Village, market, area or district'**
  String get locationExample;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the product location'**
  String get locationRequired;

  /// No description provided for @dateRangeRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a date range'**
  String get dateRangeRequired;

  /// No description provided for @couldNotLoadPosts.
  ///
  /// In en, this message translates to:
  /// **'Could not load posts'**
  String get couldNotLoadPosts;

  /// No description provided for @checkConnectionAndTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Check the server connection and try again.'**
  String get checkConnectionAndTryAgain;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @postCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the post'**
  String get postCreationFailed;

  /// No description provided for @myPosts.
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get myPosts;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPostsYet;

  /// No description provided for @createFirstPost.
  ///
  /// In en, this message translates to:
  /// **'Create a buy or sell post to see it here.'**
  String get createFirstPost;

  /// No description provided for @closePost.
  ///
  /// In en, this message translates to:
  /// **'Close Post'**
  String get closePost;

  /// No description provided for @postClosed.
  ///
  /// In en, this message translates to:
  /// **'Post closed'**
  String get postClosed;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get deletePost;

  /// No description provided for @deletePostConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this post?'**
  String get deletePostConfirmation;

  /// No description provided for @postDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post deleted'**
  String get postDeleted;

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the action'**
  String get actionFailed;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @registerAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerAccountTitle;

  /// No description provided for @registerAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your basic information to start buying or selling agricultural products.'**
  String get registerAccountMessage;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'01XXXXXXXXX'**
  String get phoneNumberHint;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Bangladeshi phone number'**
  String get enterValidPhoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @passwordMinimumLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinimumLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @mainActivity.
  ///
  /// In en, this message translates to:
  /// **'I mainly want to'**
  String get mainActivity;

  /// No description provided for @wantToBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy products'**
  String get wantToBuy;

  /// No description provided for @wantToSell.
  ///
  /// In en, this message translates to:
  /// **'Sell products'**
  String get wantToSell;

  /// No description provided for @wantToBuyAndSell.
  ///
  /// In en, this message translates to:
  /// **'Buy and sell'**
  String get wantToBuyAndSell;

  /// No description provided for @enterYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter your location'**
  String get enterYourLocation;

  /// No description provided for @accountReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account will initially remain under review. Full verification will be added later.'**
  String get accountReviewMessage;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get registrationSuccessful;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
