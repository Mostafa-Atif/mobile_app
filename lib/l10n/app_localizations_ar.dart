// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'رحّال';

  @override
  String get devMenu => 'قائمة المطور';

  @override
  String get mainScreens => 'الشاشات الرئيسية';

  @override
  String get auth => 'التسجيل';

  @override
  String get hotels => 'الفنادق';

  @override
  String get flights => 'الرحلات';

  @override
  String get carRent => 'تأجير السيارات';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get onboarding1Title => 'خطّط لرحلتك';

  @override
  String get onboarding1Body =>
      'أنشئ رحلة أحلامك بسهولة. اختر وجهتك، وابحث عن أفضل مكان للإقامة، وابنِ جدول سفر يناسبك.';

  @override
  String get onboarding2Title => 'احصل على أفضل العروض';

  @override
  String get onboarding2Body =>
      'وفّر وقتك ومالك من خلال أفضل عروض السفر. خصومات وعروض حصرية تجعل رحلتك أكثر توفيراً.';

  @override
  String get onboarding3Title => 'اكتشف المعالم المحلية';

  @override
  String get onboarding3Body =>
      'اكتشف جمال الأماكن التي لم تزرها من قبل. عش تجارب أصيلة في كل وجهة تختارها.';

  @override
  String get signInTitle => 'أهلاً بعودتك';

  @override
  String get signInSubtitle => 'سجّل دخولك للمتابعة';

  @override
  String get signUpTitle => 'إنشاء حساب';

  @override
  String get signUpSubtitle => 'انضم إلينا وابدأ رحلتك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get age => 'العمر';

  @override
  String get gender => 'الجنس';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get nationalId => 'الرقم القومي';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get haveAccount => 'لديك حساب بالفعل؟';

  @override
  String get passwordHint => '8 أحرف على الأقل، كبيرة وصغيرة وأرقام ورموز';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get forgotPasswordTitle => 'استعادة كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين';

  @override
  String get sendResetLink => 'إرسال رابط الاستعادة';

  @override
  String get resetLinkSent =>
      'تم إرسال الرابط! تحقق من بريدك.\nجارٍ التحويل لتسجيل الدخول...';

  @override
  String get errorFillFields => 'يرجى ملء جميع الحقول';

  @override
  String get errorValidEmail => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get errorPasswordLength => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get errorLettersOnly => 'أحرف فقط';

  @override
  String get errorMustBe18 => 'يجب أن يكون عمرك 18 أو أكثر';

  @override
  String get errorRequired => 'مطلوب';

  @override
  String get errorValidPhone => 'أدخل رقم هاتف صحيح (7-15 رقماً)';

  @override
  String get errorPasswordUppercase => 'حرف كبير واحد على الأقل';

  @override
  String get errorPasswordLowercase => 'حرف صغير واحد على الأقل';

  @override
  String get errorPasswordNumber => 'رقم واحد على الأقل';

  @override
  String get errorPasswordSpecial => 'رمز خاص واحد على الأقل';

  @override
  String get errorPasswordMinLength => '8 أحرف على الأقل';

  @override
  String get carRentTitle => 'تأجير السيارات';

  @override
  String get carRentSubtitle => 'استأجر سيارتك بأفضل الأسعار';

  @override
  String get carRentHint => 'اضغط على سيارة لاختيارها، ثم أكمل تفاصيل الحجز';

  @override
  String get selected => 'محدد';

  @override
  String get showMore => 'عرض المزيد';

  @override
  String get bookingDetails => 'تفاصيل الحجز';

  @override
  String get selectCarFirst => '↑ اختر سيارة من القائمة أعلاه';

  @override
  String get pickupLocation => 'موقع الاستلام';

  @override
  String get dropoffLocation => 'موقع التسليم';

  @override
  String get selectLocation => 'اختر موقعاً';

  @override
  String get pickupDateTime => 'تاريخ ووقت الاستلام';

  @override
  String get dropoffDateTime => 'تاريخ ووقت التسليم';

  @override
  String get selectDateTime => 'اختر التاريخ والوقت';

  @override
  String totalDays(int days) {
    return 'الإجمالي: $days يوم';
  }

  @override
  String get privateDriver => 'سائق خاص';

  @override
  String get privateDriverExtra => 'إضافي ﷼100/يوم';

  @override
  String carRentalDays(int days) {
    return 'تأجير السيارة ($days أيام)';
  }

  @override
  String get total => 'الإجمالي';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get bookingConfirmed => 'تم الحجز بنجاح! 🎉';

  @override
  String get bookingFailed => 'فشل الحجز';

  @override
  String get selectCarError => 'يرجى اختيار سيارة أولاً';

  @override
  String get selectLocationsError => 'يرجى اختيار مواقع الاستلام والتسليم';

  @override
  String get selectDatesError => 'يرجى اختيار تاريخ ووقت الاستلام والتسليم';

  @override
  String get dropoffBeforePickup => 'يجب أن يكون وقت التسليم بعد الاستلام';

  @override
  String get signInFirst => 'يرجى تسجيل الدخول أولاً';

  @override
  String get perDay => 'يومياً';

  @override
  String get perWeek => 'أسبوعياً';

  @override
  String get vatIncluded => '*الأسعار شاملة ضريبة القيمة المضافة';

  @override
  String get noCarAvailable => 'لا توجد سيارات متاحة';

  @override
  String get seats => 'مقاعد';

  @override
  String get bags => 'حقائب';

  @override
  String get unableToConnect => 'تعذّر الاتصال';

  @override
  String get checkConnectionRetry => 'يرجى التحقق من اتصالك والمحاولة مجدداً';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get searchStays => 'البحث عن إقامة';

  @override
  String get overOneMillion => 'أكثر من مليون عقار حول العالم';

  @override
  String get destination => 'الوجهة';

  @override
  String get entireCountry => 'الدولة كاملة';

  @override
  String get cityOnly => 'مدينة محددة';

  @override
  String get whereToQuestion => 'إلى أين؟';

  @override
  String get dates => 'التواريخ';

  @override
  String get checkIn => 'تسجيل الدخول';

  @override
  String get checkOut => 'تسجيل الخروج';

  @override
  String get guests => 'النزلاء';

  @override
  String get searchProperties => 'البحث عن عقارات';

  @override
  String nights(int count) {
    return '$count ليلة';
  }

  @override
  String get room => 'غرفة';

  @override
  String get adults => 'البالغون';

  @override
  String get children => 'الأطفال';

  @override
  String get addAnotherRoom => 'إضافة غرفة أخرى';

  @override
  String get done => 'تم';

  @override
  String get remove => 'إزالة';

  @override
  String get maxGuestsPerRoom => 'الحد الأقصى لعدد النزلاء في الغرفة هو 8.';

  @override
  String propertiesFound(int count, String destination) {
    return '$count عقار في $destination';
  }

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get filter => 'تصفية';

  @override
  String get propertyRating => 'تقييم العقار';

  @override
  String get view => 'الإطلالة';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get apply => 'تطبيق';

  @override
  String get noPropertiesMatch => 'لا توجد عقارات تطابق معايير البحث';

  @override
  String get searchByHotelName => 'البحث باسم الفندق';

  @override
  String get priceLowToHigh => 'السعر: من الأقل إلى الأعلى';

  @override
  String get priceHighToLow => 'السعر: من الأعلى إلى الأقل';

  @override
  String get rating => 'التقييم';

  @override
  String get totalPriceOneNight => 'السعر الإجمالي لليلة واحدة (شامل الضرائب)';

  @override
  String get yourStay => 'إقامتك';

  @override
  String get views => 'الإطلالات';

  @override
  String get rooms => 'الغرف';

  @override
  String get roomsAndGuests => 'الغرف والنزلاء';

  @override
  String get numberOfRooms => 'عدد الغرف';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get perNight => '/ ليلة';

  @override
  String totalNightsRooms(int total, int nights, int rooms) {
    return 'SAR $total الإجمالي ($nights ليلة، $rooms غرفة)';
  }

  @override
  String get guestDetails => 'تفاصيل النزيل';

  @override
  String get guest => 'نزيل';

  @override
  String get you => 'أنت';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get address => 'العنوان';

  @override
  String saveGuest(int number) {
    return 'حفظ بيانات النزيل $number';
  }

  @override
  String get fillGuestDetails => 'يرجى إكمال تفاصيل جميع النزلاء المتبقين';

  @override
  String get hotelBookedSuccess => 'تم حجز الفندق بنجاح! 🏨';

  @override
  String get viewSummary => 'عرض الملخص';

  @override
  String get hideSummary => 'إخفاء الملخص';

  @override
  String get checkInLabel => 'تسجيل الدخول';

  @override
  String get checkOutLabel => 'تسجيل الخروج';

  @override
  String get nightsLabel => 'الليالي';

  @override
  String get roomsLabel => 'الغرف';

  @override
  String get guestsLabel => 'نزلاء';

  @override
  String get pricePerNight => 'السعر لكل ليلة';

  @override
  String get searchFlights => 'البحث عن رحلات';

  @override
  String get oneWay => 'رحلة ذهاب';

  @override
  String get roundTrip => 'ذهاب وعودة';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get departure => 'المغادرة';

  @override
  String get returnDate => 'العودة';

  @override
  String get passengersAndClass => 'الركاب والدرجة';

  @override
  String get passengers => 'الركاب';

  @override
  String get age12Plus => '12 سنة فأكثر';

  @override
  String get age211 => '2-11 سنة';

  @override
  String get underTwo => 'أقل من سنتين';

  @override
  String get infants => 'الرضع';

  @override
  String get cabinClass => 'درجة المقصورة';

  @override
  String get selectDepartureCity => 'اختر مدينة المغادرة';

  @override
  String get selectArrivalCity => 'اختر مدينة الوصول';

  @override
  String get passenger => 'راكب';

  @override
  String get travellerDetails => 'تفاصيل المسافر';

  @override
  String get nationality => 'الجنسية';

  @override
  String get passportNumber => 'رقم جواز السفر';

  @override
  String get passportExpiry => 'تاريخ انتهاء جواز السفر';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get mobileNumber => 'رقم الهاتف المحمول';

  @override
  String get travelDocument => 'وثيقة السفر';

  @override
  String get contactDetails => 'بيانات التواصل';

  @override
  String savePassenger(int number) {
    return 'حفظ الراكب $number';
  }

  @override
  String confirmBookings(int count) {
    return 'تأكيد $count حجوزات';
  }

  @override
  String get fillPassengerDetails => 'يرجى إكمال تفاصيل جميع الركاب المتبقين';

  @override
  String get flightBookedSuccess => 'تم حجز الرحلة بنجاح! ✈️';

  @override
  String get someBookingsFailed => 'فشل بعض الحجوزات. يرجى المحاولة مجدداً.';

  @override
  String get reviewTrip => 'مراجعة رحلتك';

  @override
  String get flightDetails => 'تفاصيل الرحلة';

  @override
  String get priceSummary => 'ملخص السعر';

  @override
  String get baseFare => 'السعر الأساسي';

  @override
  String get taxesAndFees => 'الضرائب والرسوم';

  @override
  String get included => 'مشمول';

  @override
  String get checkedBaggage => 'الأمتعة المسجّلة';

  @override
  String get checkedBaggageIncluded =>
      'تشمل هذه الرحلة أمتعة مسجّلة بدون رسوم إضافية.';

  @override
  String get noBaggageIncluded =>
      'لا تشمل هذه الرحلة أمتعة مسجّلة. قد تطبق رسوم إضافية.';

  @override
  String get continue_ => 'متابعة';

  @override
  String get totalPrice => 'السعر الإجمالي';

  @override
  String get class_ => 'الدرجة';

  @override
  String get tripType => 'نوع الرحلة';

  @override
  String get airline => 'شركة الطيران';

  @override
  String get duration => 'المدة';

  @override
  String get stops => 'التوقفات';

  @override
  String get pricePerPerson => 'السعر لكل شخص';

  @override
  String get outboundFlight => 'رحلة الذهاب';

  @override
  String get returnFlight => 'رحلة العودة';

  @override
  String get noFlightsFound => 'لا توجد رحلات';

  @override
  String get tryDifferentDates => 'جرّب تواريخ أو مدناً مختلفة';

  @override
  String get selectCitiesError => 'يرجى اختيار مدينتي المغادرة والوصول';

  @override
  String get selectReturnDate => 'يرجى اختيار تاريخ العودة';

  @override
  String get errorPassport => '6-9 أحرف/أرقام فقط';

  @override
  String get errorPhone => '7-15 رقماً فقط';

  @override
  String get pleaseFixErrors => 'يرجى تصحيح الأخطاء أعلاه';

  @override
  String get selectDate => 'اختر تاريخاً';

  @override
  String get viewSummaryFlight => 'عرض الملخص';

  @override
  String get hideSummaryFlight => 'إخفاء الملخص';
}
