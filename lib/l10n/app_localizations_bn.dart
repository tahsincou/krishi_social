// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'কৃষি মিডিয়া';

  @override
  String get login => 'লগইন';

  @override
  String get dashboard => 'হোম';

  @override
  String get settings => 'সেটিংস';

  @override
  String get logout => 'লগআউট';

  @override
  String get save => 'সেভ করুন';

  @override
  String get cancel => 'ক্যানসেল';

  @override
  String get theme => 'থিম';

  @override
  String get system => 'সিস্টেম';

  @override
  String get light => 'লাইট';

  @override
  String get dark => 'ডার্ক';

  @override
  String get language => 'ভাষা';

  @override
  String get buy => 'কিনতে চাই';

  @override
  String get sell => 'বিক্রি করব';

  @override
  String get all => 'সব';

  @override
  String get searchProductOrLocation => 'পণ্য বা এলাকার নাম লিখে সার্চ করুন';

  @override
  String get vegetables => 'শাকসবজি';

  @override
  String get fruits => 'ফলমূল';

  @override
  String get crops => 'ধান ও ফসল';

  @override
  String get poultry => 'মুরগি ও হাঁস';

  @override
  String get eggs => 'ডিম';

  @override
  String get dairy => 'দুধ';

  @override
  String get fish => 'মাছ';

  @override
  String get livestock => 'গরু-ছাগল';

  @override
  String get honey => 'মধু';

  @override
  String get nursery => 'চারা ও নার্সারি';

  @override
  String get other => 'অন্যান্য';

  @override
  String get noMatchingPosts => 'কোনো পোস্ট পাওয়া যায়নি';

  @override
  String get tryAnotherProductOrCategory => 'অন্য পণ্য বা ক্যাটাগরি দিয়ে সার্চ করুন';

  @override
  String get quantity => 'পরিমাণ';

  @override
  String get required => 'কবে দরকার';

  @override
  String get available => 'কবে পাওয়া যাবে';

  @override
  String get price => 'দাম';

  @override
  String get quality => 'পণ্যের মান';

  @override
  String get contact => 'ফোন করুন';

  @override
  String get reviewedBuyer => 'যাচাই করা ক্রেতা';

  @override
  String get newBuyer => 'নতুন ক্রেতা';

  @override
  String get createPost => 'পোস্ট করুন';

  @override
  String get createBuyPost => 'কেনার পোস্ট করুন';

  @override
  String get createSellPost => 'বিক্রির পোস্ট করুন';

  @override
  String get category => 'ক্যাটাগরি';

  @override
  String get productName => 'পণ্যের নাম';

  @override
  String get selectOrTypeProduct => 'পণ্য বাছাই করুন বা নাম লিখুন';

  @override
  String get unit => 'একক';

  @override
  String get requiredBetween => 'কোন তারিখের মধ্যে দরকার';

  @override
  String get availableBetween => 'কোন তারিখের মধ্যে পাওয়া যাবে';

  @override
  String get selectDateRange => 'তারিখ বাছাই করুন';

  @override
  String get district => 'জেলা';

  @override
  String get upazila => 'উপজেলা';

  @override
  String get targetPriceOptional => 'কত দামে কিনতে চান (না দিলেও হবে)';

  @override
  String get expectedPriceOptional => 'কত দাম আশা করেন (না দিলেও হবে)';

  @override
  String get descriptionOptional => 'আরও কিছু লিখুন (না দিলেও হবে)';

  @override
  String get publishPost => 'পোস্ট করুন';

  @override
  String get selectCategory => 'একটি ক্যাটাগরি বাছাই করুন';

  @override
  String get enterProductName => 'পণ্যের নাম লিখুন';

  @override
  String get enterValidQuantity => 'সঠিক পরিমাণ লিখুন';

  @override
  String get fieldRequired => 'এই তথ্যটি দিতে হবে';

  @override
  String get postCreated => 'পোস্ট তৈরি হয়েছে';

  @override
  String get moreInformationOptional => 'আরও তথ্য দিতে চাইলে';

  @override
  String get qualityOptional => 'পণ্যের মান বা সাইজ (না দিলেও হবে)';

  @override
  String get selectCategoryFirst => 'আগে ক্যাটাগরি বাছাই করুন';

  @override
  String get productSearchHint => 'পণ্য সার্চ করুন বা নাম লিখুন';

  @override
  String get location => 'পণ্যের এলাকা';

  @override
  String get districtAndUpazila => 'জেলা ও উপজেলা';

  @override
  String get useCurrentLocation => 'বর্তমান লোকেশন ব্যবহার করুন';

  @override
  String get findingLocation => 'লোকেশন খোঁজা হচ্ছে...';

  @override
  String get addressOrArea => 'এলাকা বা ঠিকানা';

  @override
  String get addressHint => 'গ্রাম, বাজার বা কাছের পরিচিত জায়গা';

  @override
  String detectedDistrict(String district) {
    return 'জেলা: $district';
  }

  @override
  String get locationUnavailable => 'লোকেশন পাওয়া যায়নি';

  @override
  String get locationExample => 'গ্রাম, বাজার, উপজেলা বা জেলার নাম';

  @override
  String get locationRequired => 'পণ্য কোথায় আছে বা লাগবে তা লিখুন';

  @override
  String get dateRangeRequired => 'তারিখ বাছাই করুন';

  @override
  String get couldNotLoadPosts => 'পোস্ট লোড করা যায়নি';

  @override
  String get checkConnectionAndTryAgain => 'সার্ভার কানেকশন দেখে আবার চেষ্টা করুন';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get postCreationFailed => 'পোস্ট তৈরি করা যায়নি';

  @override
  String get myPosts => 'আমার পোস্ট';

  @override
  String get noPostsYet => 'এখনো কোনো পোস্ট নেই';

  @override
  String get createFirstPost => 'কেনা বা বিক্রির পোস্ট করলে এখানে দেখা যাবে';

  @override
  String get closePost => 'পোস্ট বন্ধ করুন';

  @override
  String get postClosed => 'পোস্ট বন্ধ হয়েছে';

  @override
  String get delete => 'ডিলিট';

  @override
  String get deletePost => 'পোস্ট ডিলিট';

  @override
  String get deletePostConfirmation => 'পোস্টটি ডিলিট করতে চান?';

  @override
  String get postDeleted => 'পোস্ট ডিলিট হয়েছে';

  @override
  String get actionFailed => 'কাজটি করা যায়নি';

  @override
  String get active => 'চলমান';

  @override
  String get closed => 'বন্ধ';

  @override
  String get createAccount => 'অ্যাকাউন্ট খুলুন';

  @override
  String get registerAccountTitle => 'নতুন অ্যাকাউন্ট খুলুন';

  @override
  String get registerAccountMessage => 'কৃষিপণ্য কেনা বা বিক্রি শুরু করতে আপনার সাধারণ তথ্য দিন';

  @override
  String get fullName => 'আপনার নাম';

  @override
  String get enterYourName => 'নাম লিখুন';

  @override
  String get phoneNumber => 'মোবাইল নম্বর';

  @override
  String get phoneNumberHint => '01XXXXXXXXX';

  @override
  String get enterPhoneNumber => 'মোবাইল নম্বর লিখুন';

  @override
  String get enterValidPhoneNumber => 'সঠিক মোবাইল নম্বর লিখুন';

  @override
  String get email => 'ইমেইল';

  @override
  String get enterEmail => 'ইমেইল লিখুন';

  @override
  String get enterValidEmail => 'সঠিক ইমেইল লিখুন';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get confirmPassword => 'পাসওয়ার্ড আবার লিখুন';

  @override
  String get enterPassword => 'পাসওয়ার্ড লিখুন';

  @override
  String get confirmYourPassword => 'পাসওয়ার্ড আবার লিখুন';

  @override
  String get passwordMinimumLength => 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';

  @override
  String get passwordsDoNotMatch => 'দুইটি পাসওয়ার্ড মিলছে না';

  @override
  String get mainActivity => 'আপনি মূলত কী করতে চান';

  @override
  String get wantToBuy => 'পণ্য কিনতে চাই';

  @override
  String get wantToSell => 'পণ্য বিক্রি করব';

  @override
  String get wantToBuyAndSell => 'কেনা ও বিক্রি দুটোই';

  @override
  String get enterYourLocation => 'আপনার এলাকা লিখুন';

  @override
  String get accountReviewMessage => 'অ্যাকাউন্টটি শুরুতে রিভিউর অপেক্ষায় থাকবে। বিস্তারিত ভেরিফিকেশন পরে যোগ করা হবে।';

  @override
  String get registrationSuccessful => 'অ্যাকাউন্ট তৈরি হয়েছে';

  @override
  String get alreadyHaveAccount => 'আগেই অ্যাকাউন্ট আছে? লগইন করুন';

  @override
  String get editPost => 'পোস্ট এডিট';

  @override
  String get saveChanges => 'পরিবর্তন সংরক্ষণ';

  @override
  String get postUpdated => 'পোস্ট আপডেট হয়েছে';

  @override
  String get offline => 'অফলাইন';

  @override
  String get offlineChangesUnavailable => 'পোস্টে পরিবর্তন করতে ইন্টারনেট চালু করুন।';

  @override
  String get findAgriculturalProducts => 'কৃষিপণ্য খুঁজুন';

  @override
  String get buyDirectlyFromPeople => 'কৃষক ও ক্রেতার সাথে সরাসরি যোগাযোগ করুন';

  @override
  String get justNow => 'এইমাত্র';

  @override
  String minutesAgo(int count) {
    return '$count মিনিট আগে';
  }

  @override
  String hoursAgo(int count) {
    return '$count ঘণ্টা আগে';
  }

  @override
  String daysAgo(int count) {
    return '$count দিন আগে';
  }

  @override
  String get productInformation => 'পণ্যের তথ্য';

  @override
  String get deliveryInformation => 'সময় ও জায়গা';

  @override
  String get optionalInformationHint => 'দাম, মান ও বিস্তারিত চাইলে যোগ করুন';

  @override
  String get loginToAccount => 'আপনার অ্যাকাউন্টে লগইন করুন';

  @override
  String get loginAccountMessage => 'কৃষিপণ্য কেনা-বেচা চালিয়ে যেতে আপনার তথ্য দিন';

  @override
  String get loginWelcomeMessage => 'কৃষক ও ক্রেতার সরাসরি যোগাযোগ';

  @override
  String get noAccountYet => 'নতুন ব্যবহারকারী?';

  @override
  String get edit => 'এডিট';

  @override
  String get postAgain => 'আবার পোস্ট করুন';

  @override
  String get postIsClosed => 'পোস্টটি বন্ধ করা হয়েছে';

  @override
  String neededDuring(String period) {
    return 'প্রয়োজন: $period';
  }

  @override
  String availableDuring(String period) {
    return 'পাওয়া যাবে: $period';
  }

  @override
  String get noActivePosts => 'কোনো চালু পোস্ট নেই';

  @override
  String get noClosedPosts => 'কোনো বন্ধ পোস্ট নেই';

  @override
  String get closedPostsWillAppearHere => 'বন্ধ করা পোস্ট এখানে দেখা যাবে';

  @override
  String get buyPosts => 'কেনার পোস্ট';

  @override
  String get sellPosts => 'বেচার পোস্ট';

  @override
  String get whatDoYouWantToBuy => 'কী কিনতে চান?';

  @override
  String get whatDoYouWantToSell => 'কী বিক্রি করতে চান?';

  @override
  String get buyAndSellPosts => 'কেনা-বেচার পোস্ট';

  @override
  String get findBuyPostsMessage => 'পণ্য বা এলাকার নাম লিখুন, অথবা ক্যাটাগরি বাছুন।';

  @override
  String get findSellPostsMessage => 'ক্যাটাগরি বেছে আপনার পণ্যের পোস্ট করুন।';

  @override
  String get findBuyAndSellPostsMessage => 'কেনা-বেচার পোস্ট খুঁজুন অথবা নতুন পোস্ট করুন।';

  @override
  String buyPostResults(int count) {
    return '$countটি কেনার পোস্ট পাওয়া গেছে';
  }

  @override
  String sellPostResults(int count) {
    return '$countটি বিক্রির পোস্ট পাওয়া গেছে';
  }

  @override
  String postResults(int count) {
    return '$countটি পোস্ট পাওয়া গেছে';
  }

  @override
  String buyAndSellResultSummary(int buyCount, int sellCount) {
    return 'কেনার পোস্ট $buyCountটি • বিক্রির পোস্ট $sellCountটি';
  }

  @override
  String get latestFirst => 'নতুন পোস্ট আগে';

  @override
  String get findSellOffersMessage => 'কৃষক ও বিক্রেতাদের পণ্য খুঁজুন।';

  @override
  String get findBuyRequestsMessage => 'যেসব ক্রেতা কৃষিপণ্য খুঁজছেন তাদের পোস্ট দেখুন।';
}
