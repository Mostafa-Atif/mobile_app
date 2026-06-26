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
  String get homeGreeting => 'جاهز للإقلاع؟';

  @override
  String homeGreetingWithName(String name) {
    return 'جاهز للإقلاع، $name؟';
  }

  @override
  String get homeHeroTitle => 'خطّط لمغامرتك القادمة';

  @override
  String get homeHeroSubtitle =>
      'ابحث عن أماكن ملهمة، وقارن الأفكار، وافتح دليل الوجهة مباشرة من الصفحة الرئيسية.';

  @override
  String get homeDestinationsTitle => 'استكشف الوجهات';

  @override
  String get homeDestinationsSubtitle =>
      'تصفّح مجموعة مختارة من الوجهات وافتح دليلًا سريعًا للمكان المناسب لرحلتك القادمة.';

  @override
  String get homeSearchHint => 'ابحث عن وجهات أو دول أو كلمات مفتاحية';

  @override
  String get homeExploreDestination => 'افتح الدليل';

  @override
  String get homeBackToDestinations => 'العودة إلى الوجهات';

  @override
  String get homeNoDestinationsTitle => 'لم يتم العثور على وجهات';

  @override
  String get homeNoDestinationsSubtitle =>
      'جرّب كلمة بحث مختلفة لاكتشاف مزيد من الأماكن.';

  @override
  String get homeOfficialWebsite => 'الموقع الرسمي';

  @override
  String get homeOfficialWebsiteHint =>
      'استخدم هذا المصدر عندما تريد الصفحة الرسمية الخاصة بالوجهة.';

  @override
  String get homeOfficialSource => 'المصدر الرسمي';

  @override
  String get homeTravelerGuide => 'دليل المسافر';

  @override
  String get homeSearchReady => 'جاهز للبحث';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get allDestinationsTitle => 'كل الوجهات';

  @override
  String get popularDestinations => 'الأشهر';

  @override
  String get allDestinationsTab => 'الكل';

  @override
  String get noDestinationResults => 'لم يتم العثور على نتائج';

  @override
  String get destinationBestTimeTitle => 'أفضل وقت للزيارة';

  @override
  String destinationBestTimeBody(String name) {
    return 'أفضل وقت لاكتشاف $name يكون خلال المواسم المعتدلة حين تكون الجولات والأنشطة الخارجية أكثر راحة.';
  }

  @override
  String get destinationCuisineTitle => 'المأكولات المحلية';

  @override
  String destinationCuisineBody(String name) {
    return 'استكشف نكهات $name المحلية وجرّب الأطباق المشهورة والأماكن المفضلة لدى السكان والأسواق الغذائية.';
  }

  @override
  String get destinationStayTitle => 'أماكن الإقامة';

  @override
  String get destinationStayBody =>
      'اختر منطقة قريبة من الأماكن التي تهمك مع سهولة في التنقل ومحيط مريح للإقامة.';

  @override
  String get destinationAttractionsTitle => 'أبرز المعالم';

  @override
  String destinationAttractionsBody(String name) {
    return 'ابدأ بأشهر الأماكن في $name ثم اترك وقتًا لاكتشاف الأحياء المحلية والزوايا المميزة.';
  }

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
  String privateDriverExtra(String amount) {
    return 'إضافي $amount/يوم';
  }

  @override
  String carRentalDays(int days) {
    return 'تأجير السيارة ($days أيام)';
  }

  @override
  String get total => 'الإجمالي';

  @override
  String get proceedToPayment => 'انتقل إلى الدفع';

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
  String dateTimeAt(String date, String time) {
    return '$date في $time';
  }

  @override
  String errorWithMessage(String message) {
    return 'خطأ: $message';
  }

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
  String get maxGuestsPerRoom => 'الحد الأقصى لعدد النزلاء في الغرفة هو 4.';

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
  String totalNightsRooms(String total, int nights, int rooms) {
    return '$total الإجمالي ($nights ليلة، $rooms غرفة)';
  }

  @override
  String get guestDetails => 'تفاصيل النزلاء';

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
  String get hotelSeeReviews => 'عرض التقييمات';

  @override
  String get hotelRatingExceptional => 'استثنائي';

  @override
  String get hotelRatingExcellent => 'ممتاز';

  @override
  String get hotelRatingVeryGood => 'جيد جدًا';

  @override
  String get hotelRatingGood => 'جيد';

  @override
  String get hotelRatingStandard => 'قياسي';

  @override
  String get hotelViewSea => 'إطلالة على البحر';

  @override
  String get hotelViewPool => 'إطلالة على المسبح';

  @override
  String get hotelViewGarden => 'إطلالة على الحديقة';

  @override
  String get hotelViewCity => 'إطلالة على المدينة';

  @override
  String get hotelViewMountain => 'إطلالة على الجبل';

  @override
  String get hotelViewRiver => 'إطلالة على النهر';

  @override
  String get hotelViewLake => 'إطلالة على البحيرة';

  @override
  String get hotelViewHarbor => 'إطلالة على الميناء';

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
  String get passengers => 'ركاب';

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
  String get nationalityLabel => 'الجنسية *';

  @override
  String get selectNationality => 'اختر الجنسية';

  @override
  String get searchCountry => 'ابحث عن دولة...';

  @override
  String get noCountryFound => 'لا توجد دولة';

  @override
  String get selectCountryCode => 'اختر رمز الدولة';

  @override
  String get searchCountryOrCode => 'ابحث عن دولة أو رمز...';

  @override
  String get noCodeFound => 'لا يوجد رمز';

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

  @override
  String get promoCode => 'كود الخصم';

  @override
  String get enterCode => 'أدخل الكود';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String discountWithCode(String code) {
    return 'الخصم ($code)';
  }

  @override
  String get invalidPromoCode => 'كود الخصم غير صالح';

  @override
  String get promoValidateFailed => 'تعذّر التحقق من الكود. حاول مرة أخرى.';

  @override
  String get userDashboardTitle => 'حجوزاتي';

  @override
  String get userDashboardSubtitle => 'كل حجوزاتك في مكان واحد';

  @override
  String get userDashboardTotal => 'الإجمالي';

  @override
  String get userDashboardConfirmed => 'مؤكد';

  @override
  String get userDashboardCompleted => 'مكتمل';

  @override
  String get userDashboardPending => 'قيد الانتظار';

  @override
  String get userDashboardAll => 'الكل';

  @override
  String get userDashboardFlights => 'رحلات';

  @override
  String get userDashboardHotels => 'فنادق';

  @override
  String get userDashboardCars => 'سيارات';

  @override
  String get userDashboardFlight => 'رحلة';

  @override
  String get userDashboardHotel => 'فندق';

  @override
  String get userDashboardCar => 'سيارة';

  @override
  String get userDashboardCheckIn => 'تاريخ الوصول';

  @override
  String get userDashboardCheckOut => 'تاريخ المغادرة';

  @override
  String get userDashboardRooms => 'الغرف';

  @override
  String get userDashboardGuest => 'النزيل';

  @override
  String get userDashboardPickUp => 'تاريخ الاستلام';

  @override
  String get userDashboardDropOff => 'تاريخ التسليم';

  @override
  String get userDashboardRoute => 'المسار';

  @override
  String get userDashboardDepartureDate => 'تاريخ الذهاب';

  @override
  String get userDashboardReturnDate => 'تاريخ العودة';

  @override
  String get userDashboardPassenger => 'المسافر';

  @override
  String get userDashboardTripType => 'نوع الرحلة';

  @override
  String get userDashboardNoBookings => 'لا توجد حجوزات بعد';

  @override
  String get userDashboardNoBookingsSubtitle =>
      'ستظهر حجوزاتك هنا بمجرد إنشاء حجز.';

  @override
  String get userDashboardLoadError => 'تعذر تحميل الحجوزات';

  @override
  String get adminCarBookings => 'حجوزات السيارات';

  @override
  String get adminHotelBookings => 'حجوزات الفنادق';

  @override
  String get adminFlightBookings => 'حجوزات الرحلات';

  @override
  String get adminCarBookingsSubtitle =>
      'إدارة ومراجعة جميع حجوزات تأجير السيارات';

  @override
  String get adminHotelBookingsSubtitle => 'إدارة ومراجعة جميع حجوزات الفنادق';

  @override
  String get adminFlightBookingsSubtitle => 'إدارة ومراجعة جميع حجوزات الرحلات';

  @override
  String get adminDashboardLoadError => 'تعذر تحميل لوحة تحكم المدير';

  @override
  String get adminNoBookings => 'لا توجد حجوزات هنا بعد';

  @override
  String get adminNoBookingsSubtitle =>
      'ستظهر الحجوزات الجديدة لهذا القسم هنا.';

  @override
  String get adminBookingConfirmed => 'تم تأكيد الحجز';

  @override
  String get adminBookingDeleted => 'تم حذف الحجز';

  @override
  String get adminActionFailed => 'فشلت العملية';

  @override
  String get adminConfirm => 'تأكيد';

  @override
  String get statusConfirmed => 'مؤكد';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get aboutTitle => 'من نحن';

  @override
  String get aboutMissionLabel => 'مهمّتنا';

  @override
  String get aboutMissionBody =>
      'رحّال هو رفيقك في كل رحلة. نؤمن بأن السفر يجب أن يكون سهلاً وممتعاً ومتاحاً للجميع. لذلك وفّرنا في مكان واحد كل ما تحتاجه - من حجز رحلات الطيران إلى الفنادق وتأجير السيارات - بأسعار منافسة وتجربة استخدام لا مثيل لها.';

  @override
  String get aboutOfferLabel => 'ما نقدّمه';

  @override
  String get aboutContactLabel => 'تواصل معنا';

  @override
  String get aboutHeadquarters => 'المقر الرئيسي';

  @override
  String get aboutHeadquartersValue => 'الرياض، المملكة العربية السعودية';

  @override
  String get aboutVersion => 'الإصدار ١.٠.٠';

  @override
  String get aboutStatsHotels => 'فندق';

  @override
  String get aboutStatsDestinations => 'وجهة';

  @override
  String get aboutStatsTravelers => 'عميل سعيد';

  @override
  String get aboutFeatureFlightsTitle => 'حجز رحلات';

  @override
  String get aboutFeatureFlightsDesc =>
      'ابحث عن أفضل الرحلات وأرخصها من مئات شركات الطيران حول العالم.';

  @override
  String get aboutFeatureHotelsTitle => 'حجز فنادق';

  @override
  String get aboutFeatureHotelsDesc =>
      'اختر من بين أكثر من مليون فندق وشقة فندقية في جميع أنحاء العالم.';

  @override
  String get aboutFeatureCarsTitle => 'تأجير سيارات';

  @override
  String get aboutFeatureCarsDesc =>
      'استأجر سيارتك المفضلة بأفضل الأسعار مع خيار السائق الخاص.';

  @override
  String get aboutFeatureSupportTitle => 'دعم على مدار الساعة';

  @override
  String get aboutFeatureSupportDesc =>
      'فريق دعم متاح دائماً لمساعدتك في أي وقت خلال رحلتك.';

  @override
  String get menuDashboard => 'حجوزاتي';

  @override
  String get menuAdminDashboard => 'إدارة الحجوزات';

  @override
  String get menuSettings => 'الإعدادات';

  @override
  String get menuAboutUs => 'من نحن';

  @override
  String get menuProfileFallback => 'مستخدم رحّال';

  @override
  String get menuNoEmail => 'لا يوجد بريد';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsAppearanceTitle => 'المظهر';

  @override
  String get settingsAppearanceSubtitle => 'اختر وضع التطبيق';

  @override
  String get settingsLanguageTitle => 'اللغة';

  @override
  String get settingsLanguageSubtitle => 'اختر لغة التطبيق';

  @override
  String get settingsLight => 'فاتح';

  @override
  String get settingsDark => 'داكن';

  @override
  String get menuLogout => 'تسجيل الخروج';

  @override
  String get errorName => 'يجب أن يكون من 2 إلى 50 حرفاً';

  @override
  String get errorAge => 'يجب أن يكون العمر بين 18 و 120';

  @override
  String get errorNationalId => 'يجب أن يكون من 8 إلى 20 حرفاً أو رقماً';

  @override
  String get upcomingTrip => 'رحلتك القادمة';

  @override
  String get specialOffers => 'عروض خاصة';

  @override
  String get specialOffer => 'عرض خاص';

  @override
  String get offerBadge => 'حصري للتطبيق';

  @override
  String get offerWelcomeGift => 'هدية رحال.';

  @override
  String get offerDiscount => 'خصم 20%';

  @override
  String get offerCodeLabel => 'الكود';

  @override
  String get offerCodeCopied => 'تم نسخ الكود: RAHAL20';

  @override
  String get offerCopyCode => 'نسخ الكود';

  @override
  String get paymentTitle => 'الدفع';

  @override
  String get paymentCreditCard => 'بطاقة ائتمان';

  @override
  String get paymentDebitCard => 'بطاقة مدين';

  @override
  String get paymentCardNumber => 'رقم البطاقة';

  @override
  String get paymentCardholderName => 'اسم حامل البطاقة';

  @override
  String get paymentCardholderHint => 'الاسم على البطاقة';

  @override
  String get paymentExpiry => 'تاريخ الانتهاء';

  @override
  String get paymentCvv => 'CVV';

  @override
  String get paymentSaveCard => 'حفظ البطاقة';

  @override
  String get paymentSaveCardSub => 'لإتمام الدفع بشكل أسرع في المرة القادمة';

  @override
  String get paymentSecureNote => 'بيانات الدفع محمية';

  @override
  String get paymentErrorCardNumberRequired => 'أدخل رقم البطاقة';

  @override
  String get paymentErrorCardNumberInvalid => 'أدخل رقم بطاقة صحيح';

  @override
  String get paymentErrorCardholderRequired => 'أدخل اسم حامل البطاقة';

  @override
  String get paymentErrorCardholderInvalid => 'أدخل اسمًا صحيحًا';

  @override
  String get paymentErrorExpiryRequired => 'أدخل تاريخ الانتهاء';

  @override
  String get paymentErrorExpiryInvalid => 'أدخل تاريخ انتهاء صحيح';

  @override
  String get paymentErrorExpiryExpired => 'انتهت صلاحية هذه البطاقة';

  @override
  String get paymentErrorCvvRequired => 'أدخل رمز CVV';

  @override
  String get paymentErrorCvvInvalid => 'أدخل رمز CVV صحيح';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get airport => 'المطار';

  @override
  String get downtown => 'وسط المدينة';

  @override
  String get trainStation => 'محطة القطار';

  @override
  String get hotelDistrict => 'حي الفنادق';

  @override
  String get shoppingDistrict => 'حي التسوق';

  @override
  String get industrialZone => 'المنطقة الصناعية';

  @override
  String get airportRoad => 'طريق المطار';

  @override
  String get dubai => 'دبي';

  @override
  String get abuDhabi => 'أبوظبي';

  @override
  String get sharjah => 'الشارقة';

  @override
  String get riyadh => 'الرياض';

  @override
  String get jeddah => 'جدة';

  @override
  String get cairo => 'القاهرة';

  @override
  String get alexandria => 'الإسكندرية';

  @override
  String get giza => 'الجيزة';

  @override
  String get aswan => 'أسوان';

  @override
  String get doha => 'الدوحة';

  @override
  String get alRayyan => 'الريان';

  @override
  String get manama => 'المنامة';

  @override
  String get muharraq => 'المحرق';

  @override
  String get muscat => 'مسقط';

  @override
  String get salalah => 'صلالة';

  @override
  String get kuwaitCity => 'مدينة الكويت';

  @override
  String get salmiya => 'السالمية';

  @override
  String get amman => 'عمّان';

  @override
  String get zarqa => 'الزرقاء';

  @override
  String get beirut => 'بيروت';

  @override
  String get tripoli => 'طرابلس';

  @override
  String get istanbul => 'إسطنبول';

  @override
  String get ankara => 'أنقرة';

  @override
  String get izmir => 'إزمير';

  @override
  String get london => 'لندن';

  @override
  String get manchester => 'مانشستر';

  @override
  String get birmingham => 'برمنغهام';

  @override
  String get paris => 'باريس';

  @override
  String get lyon => 'ليون';

  @override
  String get marseille => 'مرسيليا';

  @override
  String get madrid => 'مدريد';

  @override
  String get barcelona => 'برشلونة';

  @override
  String get seville => 'إشبيلية';

  @override
  String get rome => 'روما';

  @override
  String get milan => 'ميلانو';

  @override
  String get venice => 'البندقية';

  @override
  String get berlin => 'برلين';

  @override
  String get munich => 'ميونخ';

  @override
  String get hamburg => 'هامبورغ';

  @override
  String get tokyo => 'طوكيو';

  @override
  String get osaka => 'أوساكا';

  @override
  String get kyoto => 'كيوتو';

  @override
  String get singapore => 'سنغافورة';

  @override
  String get bangkok => 'بانكوك';

  @override
  String get phuket => 'فوكيت';

  @override
  String get chiangMai => 'شيانغ ماي';

  @override
  String get delhi => 'دلهي';

  @override
  String get mumbai => 'مومباي';

  @override
  String get bangalore => 'بنغالور';

  @override
  String get seoul => 'سيول';

  @override
  String get busan => 'بوسان';

  @override
  String get incheon => 'إنتشون';

  @override
  String get newYork => 'نيويورك';

  @override
  String get losAngeles => 'لوس أنجلوس';

  @override
  String get chicago => 'شيكاغو';

  @override
  String get miami => 'ميامي';

  @override
  String get lasVegas => 'لاس فيغاس';

  @override
  String get toronto => 'تورنتو';

  @override
  String get vancouver => 'فانكوفر';

  @override
  String get montreal => 'مونتريال';

  @override
  String get mexicoCity => 'مكسيكو سيتي';

  @override
  String get cancun => 'كانكون';

  @override
  String get playaDelCarmen => 'بلايا ديل كارمن';

  @override
  String get saoPaulo => 'ساو باولو';

  @override
  String get rioDeJaneiro => 'ريو دي جانيرو';

  @override
  String get salvador => 'سالفادور';

  @override
  String get sydney => 'سيدني';

  @override
  String get melbourne => 'ملبورن';

  @override
  String get brisbane => 'بريزبن';

  @override
  String get uae => 'الإمارات';

  @override
  String get saudiArabia => 'المملكة العربية السعودية';

  @override
  String get egypt => 'مصر';

  @override
  String get qatar => 'قطر';

  @override
  String get bahrain => 'البحرين';

  @override
  String get oman => 'عُمان';

  @override
  String get kuwait => 'الكويت';

  @override
  String get jordan => 'الأردن';

  @override
  String get lebanon => 'لبنان';

  @override
  String get turkey => 'تركيا';

  @override
  String get unitedKingdom => 'المملكة المتحدة';

  @override
  String get france => 'فرنسا';

  @override
  String get spain => 'إسبانيا';

  @override
  String get italy => 'إيطاليا';

  @override
  String get germany => 'ألمانيا';

  @override
  String get japan => 'اليابان';

  @override
  String get thailand => 'تايلاند';

  @override
  String get india => 'الهند';

  @override
  String get southKorea => 'كوريا الجنوبية';

  @override
  String get unitedStates => 'الولايات المتحدة';

  @override
  String get canada => 'كندا';

  @override
  String get mexico => 'المكسيك';

  @override
  String get brazil => 'البرازيل';

  @override
  String get australia => 'أستراليا';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get selectCity => 'اختر المدينة';

  @override
  String get selectPickupLocation => 'موقع الاستلام';

  @override
  String get selectDropoffLocation => 'موقع التسليم';

  @override
  String get sameCityAsPickup => 'نفس مدينة الاستلام';

  @override
  String stepOf(int step) {
    return 'الخطوة $step من 4';
  }

  @override
  String get tripDetails => 'تفاصيل الرحلة';

  @override
  String get yourInformation => 'معلوماتك';

  @override
  String get reviewAndConfirm => 'المراجعة والتأكيد';

  @override
  String get pickupAndDropoff => 'الاستلام والتسليم';

  @override
  String get airportNotice => 'الاستلام والتسليم دائماً في مطار المدينة';

  @override
  String get pricePerDayFilter => 'السعر/يوم';

  @override
  String get noCarsMatch => 'لا توجد سيارات تطابق الفلاتر';

  @override
  String get clearFilters => 'مسح الفلاتر';

  @override
  String get location => 'الموقع';

  @override
  String get until => 'حتى';

  @override
  String get vehicle => 'السيارة';

  @override
  String get trip => 'الرحلة';

  @override
  String get priceBreakdown => 'تفاصيل السعر';

  @override
  String get continuee => 'متابعة';

  @override
  String get day => 'يوم';

  @override
  String get days => 'أيام';

  @override
  String get total2 => 'المجموع';

  @override
  String get saved => 'وفّرت';

  @override
  String get sortPriceLow => 'السعر: من الأقل';

  @override
  String get sortPriceHigh => 'السعر: من الأعلى';

  @override
  String get sortNameAZ => 'الاسم: أ إلى ي';

  @override
  String get sortSeatsLow => 'المقاعد: الأقل أولاً';

  @override
  String get sortSeatsHigh => 'المقاعد: الأكثر أولاً';

  @override
  String get cashOnlyTitle => 'الدفع نقدًا فقط';

  @override
  String get cashOnlyBody =>
      'لا ندعم الدفع الإلكتروني حاليًا. يُرجى تجهيز المبلغ نقدًا عند استلام السيارة.';

  @override
  String get searchCity => 'ابحث عن مدينة...';

  @override
  String get sortPriceAsc => 'السعر ↑';

  @override
  String get sortPriceDesc => 'السعر ↓';

  @override
  String get sortNameAz => 'أ–ي';

  @override
  String get car => 'السيارة';

  @override
  String get info => 'معلوماتك';

  @override
  String get review => 'مراجعة';

  @override
  String get bookingConfirmedTitle => 'كل شيء جاهز!';

  @override
  String get bookingConfirmedMessage =>
      'تم تأكيد حجزك. سيكون فريقنا في المطار بانتظارك عند وصولك.';

  @override
  String get carsCashPaymentTitle => 'الدفع عند الاستلام — بدون بطاقة';

  @override
  String get carsCashPaymentBody =>
      'ادفع نقداً عند استلام سيارتك — بدون نماذج إلكترونية، بدون رسوم خفية، بدون تعقيد.';

  @override
  String get flightsCashPaymentTitle => 'احجز الآن — وادفع نقداً';

  @override
  String get flightsCashPaymentBody =>
      'احجز مقعدك الآن وادفع نقداً — بدون بطاقة، بدون نماذج إلكترونية، بدون تعقيد.';

  @override
  String get hotelsCashPaymentTitle => 'احجز الآن — وادفع عند الوصول';

  @override
  String get hotelsCashPaymentBody =>
      'احجز غرفتك الآن وادفع نقداً عند وصولك — بدون بطاقة، بدون نماذج إلكترونية، بدون تعقيد.';

  @override
  String get dubaiInternationalAirport => 'مطار دبي الدولي';

  @override
  String get abuDhabiInternationalAirport => 'مطار أبوظبي الدولي';

  @override
  String get sharjahInternationalAirport => 'مطار الشارقة الدولي';

  @override
  String get kingKhalidInternationalAirport => 'مطار الملك خالد الدولي';

  @override
  String get kingAbdulazizInternationalAirport => 'مطار الملك عبدالعزيز الدولي';

  @override
  String get cairoInternationalAirport => 'مطار القاهرة الدولي';

  @override
  String get elNouzhaAirport => 'مطار النزهة';

  @override
  String get hamadInternationalAirport => 'مطار حمد الدولي';

  @override
  String get bahrainInternationalAirport => 'مطار البحرين الدولي';

  @override
  String get muscatInternationalAirport => 'مطار مسقط الدولي';

  @override
  String get kuwaitInternationalAirport => 'مطار الكويت الدولي';

  @override
  String get queenAliaInternationalAirport => 'مطار الملكة علياء الدولي';

  @override
  String get beirutRaficHaririInternational => 'مطار بيروت رفيق الحريري الدولي';

  @override
  String get istanbulAirport => 'مطار إسطنبول';

  @override
  String get sabihaCokcentInternationalAirport => 'مطار صبيحة كوكجن الدولي';

  @override
  String get adnanMenderesAirport => 'مطار عدنان مندريس';

  @override
  String get ankaraEsenbogaAirport => 'مطار أنقرة إسنبوغا';

  @override
  String get heathrowAirport => 'مطار هيثرو';

  @override
  String get gatwickAirport => 'مطار غاتويك';

  @override
  String get manchesterAirport => 'مطار مانشستر';

  @override
  String get charlesDeGaulleAirport => 'مطار شارل ديغول';

  @override
  String get parisOrlyAirport => 'مطار باريس أورلي';

  @override
  String get adolfoSuarezMadridBarajasAirport =>
      'مطار أدولفو سواريز مدريد باراخاس';

  @override
  String get barcelonaElPratAirport => 'مطار برشلونة إل برات';

  @override
  String get leonardoDaVinciFiumicinoAirport =>
      'مطار ليوناردو دا فينشي فيوميتشينو';

  @override
  String get milanMalpensaAirport => 'مطار ميلانو مالبينسا';

  @override
  String get berlinBrandenburgAirport => 'مطار برلين براندنبورغ';

  @override
  String get munichAirport => 'مطار ميونخ';

  @override
  String get hamburgAirport => 'مطار هامبورغ';

  @override
  String get tokyoHanedaAirport => 'مطار طوكيو هانيدا';

  @override
  String get naritaInternationalAirport => 'مطار ناريتا الدولي';

  @override
  String get kansaiInternationalAirport => 'مطار كانساي الدولي';

  @override
  String get singaporeChangiAirport => 'مطار سنغافورة تشانغي';

  @override
  String get suvarnabhumiAirport => 'مطار سوفارنابهومي';

  @override
  String get phuketInternationalAirport => 'مطار فوكيت الدولي';

  @override
  String get indiraGandhiInternationalAirport => 'مطار إنديرا غاندي الدولي';

  @override
  String get chhatrapatiShivajiInternational => 'مطار شاتراباتي شيفاجي الدولي';

  @override
  String get incheonInternationalAirport => 'مطار إنتشون الدولي';

  @override
  String get gimpoInternationalAirport => 'مطار غيمبو الدولي';

  @override
  String get johnFKennedyInternationalAirport => 'مطار جون إف كينيدي الدولي';

  @override
  String get laGuardiaAirport => 'مطار لاغوارديا';

  @override
  String get losAngelesInternationalAirport => 'مطار لوس أنجلوس الدولي';

  @override
  String get ohareInternationalAirport => 'مطار أوهير الدولي';

  @override
  String get miamiInternationalAirport => 'مطار ميامي الدولي';

  @override
  String get harryReidInternationalAirport => 'مطار هاري ريد الدولي';

  @override
  String get torontoPearsonInternationalAirport => 'مطار تورنتو بيرسون الدولي';

  @override
  String get vancouverInternationalAirport => 'مطار فانكوفر الدولي';

  @override
  String get mexicoCityInternationalAirport => 'مطار مكسيكو سيتي الدولي';

  @override
  String get cancunInternationalAirport => 'مطار كانكون الدولي';

  @override
  String get saoPauloGuarulhosInternational =>
      'مطار ساو باولو غوارولهوس الدولي';

  @override
  String get rioDeJaneiroGaleaoInternational =>
      'مطار ريو دي جانيرو غاليان الدولي';

  @override
  String get sydneyKingsfordSmithAirport => 'مطار سيدني كينغسفورد سميث';

  @override
  String get melbourneAirport => 'مطار ملبورن';

  @override
  String get brisbaneAirport => 'مطار بريزبن';

  @override
  String get all => 'الكل';

  @override
  String get economy => 'اقتصادي';

  @override
  String get premiumEconomy => 'اقتصادي مميز';

  @override
  String get business => 'رجال الأعمال';

  @override
  String get firstClass => 'الدرجة الأولى';

  @override
  String get settingsCurrencyTitle => 'العملة';

  @override
  String get settingsCurrencySubtitle => 'اختر عملتك المفضلة';

  @override
  String get promoAlreadyUsed => 'تم استخدام كود الخصم مسبقاً';

  @override
  String get cashBannerTitle => 'ادفع نقداً عند الوصول — رحلات وفنادق وسيارات';

  @override
  String get cashBannerBody =>
      'احجز الآن بدون بطاقة. فقط احضر وادفع نقداً عند وصولك.';
}
