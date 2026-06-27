// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rahal';

  @override
  String get homeGreeting => 'Ready for takeoff?';

  @override
  String homeGreetingWithName(String name) {
    return 'Ready for takeoff, $name?';
  }

  @override
  String get homeHeroTitle => 'Plan your next adventure';

  @override
  String get homeHeroSubtitle =>
      'Search inspiring places, compare ideas, and open a destination guide without leaving the home screen.';

  @override
  String get homeDestinationsTitle => 'Explore destinations';

  @override
  String get homeDestinationsSubtitle =>
      'Browse a curated set of destinations and open a quick guide for the place that matches your next trip.';

  @override
  String get homeSearchHint => 'Search destinations, countries, or keywords';

  @override
  String get homeExploreDestination => 'Open guide';

  @override
  String get homeBackToDestinations => 'Back to destinations';

  @override
  String get homeNoDestinationsTitle => 'No destinations found';

  @override
  String get homeNoDestinationsSubtitle =>
      'Try a different search term to explore more places.';

  @override
  String get homeOfficialWebsite => 'Official website';

  @override
  String get homeOfficialWebsiteHint =>
      'Use this source when you want the destination\'s official travel page.';

  @override
  String get homeOfficialSource => 'Official source';

  @override
  String get homeTravelerGuide => 'Traveler guide';

  @override
  String get homeSearchReady => 'Search-ready';

  @override
  String get seeAll => 'See all';

  @override
  String get allDestinationsTitle => 'All Destinations';

  @override
  String get popularDestinations => 'Popular';

  @override
  String get allDestinationsTab => 'All';

  @override
  String get noDestinationResults => 'No results found';

  @override
  String get destinationBestTimeTitle => 'Best Time to Visit';

  @override
  String destinationBestTimeBody(String name) {
    return 'The ideal time to explore $name is during the milder seasons when sightseeing and outdoor activities feel most comfortable.';
  }

  @override
  String get destinationCuisineTitle => 'Local Cuisine';

  @override
  String destinationCuisineBody(String name) {
    return 'Experience local flavors in $name and explore signature dishes, neighborhood favorites, and food markets.';
  }

  @override
  String get destinationStayTitle => 'Where to Stay';

  @override
  String get destinationStayBody =>
      'Choose an area close to the attractions you care about most, with good transport access and comfortable surroundings.';

  @override
  String get destinationAttractionsTitle => 'Top Attractions';

  @override
  String destinationAttractionsBody(String name) {
    return 'Start with the best-known places in $name, then leave room for local neighborhoods and hidden gems.';
  }

  @override
  String get devMenu => 'Dev Menu';

  @override
  String get mainScreens => 'Main Screens';

  @override
  String get auth => 'Auth';

  @override
  String get hotels => 'Hotels';

  @override
  String get flights => 'Flights';

  @override
  String get carRent => 'Car Rent';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboarding1Title => 'Plan Your Trip';

  @override
  String get onboarding1Body =>
      'Create your dream trip with ease. Choose a destination, find the perfect place to stay, and build an itinerary that suits you.';

  @override
  String get onboarding2Title => 'Get the Best Deal';

  @override
  String get onboarding2Body =>
      'Save time and money by finding the best travel deals. Exclusive promotions and discounts to make your trip more affordable.';

  @override
  String get onboarding3Title => 'Explore Local Attractions';

  @override
  String get onboarding3Body =>
      'Discover the beauty of local places you may never have visited. Experience authentic local life in every destination.';

  @override
  String get signInTitle => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to continue';

  @override
  String get signUpTitle => 'Create account';

  @override
  String get signUpSubtitle => 'Join us and start exploring';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get age => 'Age';

  @override
  String get gender => 'Gender';

  @override
  String get phone => 'Phone Number';

  @override
  String get nationalId => 'National ID';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get passwordHint => 'Min 8 chars, upper, lower, number, special';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a reset link';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent =>
      'Reset link sent! Check your inbox.\nRedirecting to sign in...';

  @override
  String get errorFillFields => 'Please fill in all fields';

  @override
  String get errorValidEmail => 'Enter a valid email';

  @override
  String get errorPasswordLength => 'Password must be at least 8 characters';

  @override
  String get errorLettersOnly => 'Letters only';

  @override
  String get errorMustBe18 => 'Must be 18+';

  @override
  String get errorRequired => 'Required';

  @override
  String get errorValidPhone => 'Enter a valid phone number (7-15 digits)';

  @override
  String get errorPasswordUppercase => 'At least 1 uppercase letter';

  @override
  String get errorPasswordLowercase => 'At least 1 lowercase letter';

  @override
  String get errorPasswordNumber => 'At least 1 number';

  @override
  String get errorPasswordSpecial => 'At least 1 special character';

  @override
  String get errorPasswordMinLength => 'At least 8 characters';

  @override
  String get carRentTitle => 'Car Rent';

  @override
  String get carRentSubtitle => 'Rent a car at the best rates';

  @override
  String get carRentHint =>
      'Tap a car to select it, then fill in the details below';

  @override
  String get selected => 'Selected';

  @override
  String get showMore => 'Show more';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get selectCarFirst => '↑ Select a car from the list above';

  @override
  String get pickupLocation => 'Pickup location';

  @override
  String get dropoffLocation => 'Dropoff location';

  @override
  String get selectLocation => 'Select location';

  @override
  String get pickupDateTime => 'Pickup date & time';

  @override
  String get dropoffDateTime => 'Dropoff date & time';

  @override
  String get selectDateTime => 'Select date & time';

  @override
  String totalDays(int days) {
    return 'Total: $days day(s)';
  }

  @override
  String get privateDriver => 'Private driver';

  @override
  String privateDriverExtra(String amount) {
    return 'Extra $amount/day';
  }

  @override
  String carRentalDays(int days) {
    return 'Car rental ($days days)';
  }

  @override
  String get total => 'Total';

  @override
  String get proceedToPayment => 'Proceed To Payment';

  @override
  String get bookingConfirmed => 'Booking confirmed! 🎉';

  @override
  String get bookingFailed => 'Booking failed';

  @override
  String get selectCarError => 'Please select a car first';

  @override
  String get selectLocationsError =>
      'Please select pickup and dropoff locations';

  @override
  String get selectDatesError => 'Please select pickup and dropoff date & time';

  @override
  String get dropoffBeforePickup => 'Dropoff must be after pickup';

  @override
  String get signInFirst => 'Please sign in first';

  @override
  String get perDay => 'Per day';

  @override
  String get perWeek => 'Per week';

  @override
  String get vatIncluded => '*The prices are inclusive of VAT';

  @override
  String get noCarAvailable => 'No cars available';

  @override
  String get seats => 'Seats';

  @override
  String get bags => 'Bags';

  @override
  String get unableToConnect => 'Unable to connect';

  @override
  String get checkConnectionRetry =>
      'Please check your connection and try again';

  @override
  String get retry => 'Retry';

  @override
  String dateTimeAt(String date, String time) {
    return '$date at $time';
  }

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get searchStays => 'Search Stays';

  @override
  String get overOneMillion => 'Over 1M properties worldwide';

  @override
  String get destination => 'Destination';

  @override
  String get entireCountry => 'Entire country';

  @override
  String get cityOnly => 'City only';

  @override
  String get whereToQuestion => 'Where to?';

  @override
  String get dates => 'Dates';

  @override
  String get checkIn => 'Check in';

  @override
  String get checkOut => 'Check out';

  @override
  String get guests => 'Guests';

  @override
  String get searchProperties => 'Search Properties';

  @override
  String nights(int count) {
    return '$count night(s)';
  }

  @override
  String get room => 'Room';

  @override
  String get adults => 'Adults';

  @override
  String get children => 'Children';

  @override
  String get addAnotherRoom => 'Add another room';

  @override
  String get done => 'Done';

  @override
  String get remove => 'Remove';

  @override
  String get maxGuestsPerRoom =>
      'The maximum number of guests allowed per room is 4.';

  @override
  String propertiesFound(int count, String destination) {
    return '$count properties found in $destination';
  }

  @override
  String get sortBy => 'Sort by';

  @override
  String get filter => 'Filter';

  @override
  String get propertyRating => 'Property Rating';

  @override
  String get view => 'View';

  @override
  String get clearAll => 'Clear all';

  @override
  String get apply => 'Apply';

  @override
  String get noPropertiesMatch => 'No properties match your filters';

  @override
  String get searchByHotelName => 'Search by hotel name';

  @override
  String get priceLowToHigh => 'Price: Low to High';

  @override
  String get priceHighToLow => 'Price: High to Low';

  @override
  String get rating => 'Rating';

  @override
  String get totalPriceOneNight => 'Total price for 1 night (including taxes)';

  @override
  String get yourStay => 'Your Stay';

  @override
  String get views => 'Views';

  @override
  String get rooms => 'Rooms';

  @override
  String get roomsAndGuests => 'Rooms & Guests';

  @override
  String get numberOfRooms => 'Number of rooms';

  @override
  String get bookNow => 'Book Now';

  @override
  String get perNight => '/ night';

  @override
  String totalNightsRooms(String total, int nights, int rooms) {
    return '$total ($nights nights, $rooms room(s))';
  }

  @override
  String get guestDetails => 'Guest details';

  @override
  String get guest => 'Guest';

  @override
  String get you => 'You';

  @override
  String get fullName => 'Full name';

  @override
  String get address => 'Address';

  @override
  String saveGuest(int number) {
    return 'Save Guest $number';
  }

  @override
  String get fillGuestDetails =>
      'Please fill in details for all remaining guests';

  @override
  String get hotelBookedSuccess => 'Hotel booked successfully! 🏨';

  @override
  String get hotelSeeReviews => 'See reviews';

  @override
  String get hotelRatingExceptional => 'Exceptional';

  @override
  String get hotelRatingExcellent => 'Excellent';

  @override
  String get hotelRatingVeryGood => 'Very Good';

  @override
  String get hotelRatingGood => 'Good';

  @override
  String get hotelRatingStandard => 'Standard';

  @override
  String get hotelViewSea => 'Sea view';

  @override
  String get hotelViewPool => 'Pool view';

  @override
  String get hotelViewGarden => 'Garden view';

  @override
  String get hotelViewCity => 'City view';

  @override
  String get hotelViewMountain => 'Mountain view';

  @override
  String get hotelViewRiver => 'River view';

  @override
  String get hotelViewLake => 'Lake view';

  @override
  String get hotelViewHarbor => 'Harbor view';

  @override
  String get viewSummary => 'View summary';

  @override
  String get hideSummary => 'Hide summary';

  @override
  String get checkInLabel => 'Check-in';

  @override
  String get checkOutLabel => 'Check-out';

  @override
  String get nightsLabel => 'Nights';

  @override
  String get roomsLabel => 'Rooms';

  @override
  String get guestsLabel => 'Guests';

  @override
  String get pricePerNight => 'Price per night';

  @override
  String get searchFlights => 'Search Flights';

  @override
  String get oneWay => 'One-way';

  @override
  String get roundTrip => 'Round trip';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get departure => 'Departure';

  @override
  String get returnDate => 'Return';

  @override
  String get passengersAndClass => 'Passengers & Class';

  @override
  String get passengers => 'Passengers';

  @override
  String get age12Plus => 'Age 12+';

  @override
  String get age211 => 'Age 2-11';

  @override
  String get underTwo => 'Under 2';

  @override
  String get infants => 'Infants';

  @override
  String get cabinClass => 'Cabin Class';

  @override
  String get selectDepartureCity => 'Select Departure City';

  @override
  String get selectArrivalCity => 'Select Arrival City';

  @override
  String get passenger => 'Passenger';

  @override
  String get travellerDetails => 'Traveller details';

  @override
  String get nationality => 'Nationality';

  @override
  String get passportNumber => 'Passport number';

  @override
  String get passportExpiry => 'Passport expiry date';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get travelDocument => 'Travel document';

  @override
  String get contactDetails => 'Contact details';

  @override
  String get nationalityLabel => 'Nationality *';

  @override
  String get selectNationality => 'Select Nationality';

  @override
  String get searchCountry => 'Search country...';

  @override
  String get noCountryFound => 'No country found';

  @override
  String get selectCountryCode => 'Select Country Code';

  @override
  String get searchCountryOrCode => 'Search country or code…';

  @override
  String get noCodeFound => 'No code found';

  @override
  String savePassenger(int number) {
    return 'Save Passenger $number';
  }

  @override
  String confirmBookings(int count) {
    return 'Confirm $count Bookings';
  }

  @override
  String get fillPassengerDetails =>
      'Please fill in details for all remaining passengers';

  @override
  String get flightBookedSuccess => 'Flight booked successfully! ✈️';

  @override
  String get someBookingsFailed => 'Some bookings failed. Please try again.';

  @override
  String get reviewTrip => 'Review your trip';

  @override
  String get flightDetails => 'Flight Details';

  @override
  String get priceSummary => 'Price Summary';

  @override
  String get baseFare => 'Base fare';

  @override
  String get taxesAndFees => 'Taxes & fees';

  @override
  String get included => 'Included';

  @override
  String get checkedBaggage => 'Checked Baggage';

  @override
  String get checkedBaggageIncluded =>
      'This flight includes checked baggage at no extra cost.';

  @override
  String get noBaggageIncluded =>
      'This flight does not include checked baggage. Additional fees may apply.';

  @override
  String get continue_ => 'Continue';

  @override
  String get totalPrice => 'Total price';

  @override
  String get class_ => 'Class';

  @override
  String get tripType => 'Trip Type';

  @override
  String get airline => 'Airline';

  @override
  String get duration => 'Duration';

  @override
  String get stops => 'Stops';

  @override
  String get pricePerPerson => 'Price per person';

  @override
  String get outboundFlight => 'Outbound Flight';

  @override
  String get returnFlight => 'Return Flight';

  @override
  String get noFlightsFound => 'No flights found';

  @override
  String get tryDifferentDates => 'Try different dates or cities';

  @override
  String get selectCitiesError => 'Please select departure and arrival cities';

  @override
  String get selectReturnDate => 'Please select a return date';

  @override
  String get errorPassport => '6-9 letters/numbers only';

  @override
  String get errorPhone => '7-15 digits only';

  @override
  String get pleaseFixErrors => 'Please fix the errors above';

  @override
  String get selectDate => 'Select date';

  @override
  String get viewSummaryFlight => 'View summary';

  @override
  String get hideSummaryFlight => 'Hide summary';

  @override
  String get promoCode => 'Promo Code';

  @override
  String get enterCode => 'Enter code';

  @override
  String get subtotal => 'Subtotal';

  @override
  String discountWithCode(String code) {
    return 'Discount ($code)';
  }

  @override
  String get invalidPromoCode => 'Invalid promo code';

  @override
  String get promoValidateFailed => 'Could not validate code. Try again.';

  @override
  String get userDashboardTitle => 'My Bookings';

  @override
  String get userDashboardSubtitle => 'All your travel bookings in one place';

  @override
  String get userDashboardTotal => 'Total';

  @override
  String get userDashboardConfirmed => 'Confirmed';

  @override
  String get userDashboardCompleted => 'Completed';

  @override
  String get userDashboardPending => 'Pending';

  @override
  String get userDashboardAll => 'All';

  @override
  String get userDashboardFlights => 'Flights';

  @override
  String get userDashboardHotels => 'Hotels';

  @override
  String get userDashboardCars => 'Cars';

  @override
  String get userDashboardFlight => 'Flight';

  @override
  String get userDashboardHotel => 'Hotel';

  @override
  String get userDashboardCar => 'Car';

  @override
  String get userDashboardCheckIn => 'Check in';

  @override
  String get userDashboardCheckOut => 'Check out';

  @override
  String get userDashboardRooms => 'Rooms';

  @override
  String get userDashboardGuest => 'Guest';

  @override
  String get userDashboardPickUp => 'Pick up';

  @override
  String get userDashboardDropOff => 'Drop off';

  @override
  String get userDashboardRoute => 'Route';

  @override
  String get userDashboardDepartureDate => 'Departure';

  @override
  String get userDashboardReturnDate => 'Return';

  @override
  String get userDashboardPassenger => 'Passenger';

  @override
  String get userDashboardTripType => 'Trip type';

  @override
  String get userDashboardNoBookings => 'No bookings yet';

  @override
  String get userDashboardNoBookingsSubtitle =>
      'Your bookings will appear here once you create one.';

  @override
  String get userDashboardLoadError => 'Could not load bookings';

  @override
  String get adminCarBookings => 'Car Bookings';

  @override
  String get adminHotelBookings => 'Hotel Bookings';

  @override
  String get adminFlightBookings => 'Flight Bookings';

  @override
  String get adminCarBookingsSubtitle =>
      'Manage and review all car rental bookings';

  @override
  String get adminHotelBookingsSubtitle =>
      'Manage and review all hotel bookings';

  @override
  String get adminFlightBookingsSubtitle =>
      'Manage and review all flight bookings';

  @override
  String get adminDashboardLoadError => 'Could not load admin dashboard';

  @override
  String get adminNoBookings => 'No bookings here yet';

  @override
  String get adminNoBookingsSubtitle =>
      'New bookings for this section will appear here.';

  @override
  String get adminBookingConfirmed => 'Booking confirmed';

  @override
  String get adminBookingDeleted => 'Booking deleted';

  @override
  String get adminActionFailed => 'Action failed';

  @override
  String get adminConfirm => 'Confirm';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusPending => 'Pending';

  @override
  String get aboutTitle => 'About Us';

  @override
  String get aboutMissionLabel => 'Our Mission';

  @override
  String get aboutMissionBody =>
      'Rahal is your companion on every journey. We believe travel should be simple, enjoyable, and accessible to everyone. That\'s why we\'ve brought everything you need into one place - from flights and hotels to car rentals - at competitive prices with an unmatched experience.';

  @override
  String get aboutOfferLabel => 'What We Offer';

  @override
  String get aboutContactLabel => 'Get In Touch';

  @override
  String get aboutHeadquarters => 'Headquarters';

  @override
  String get aboutHeadquartersValue => 'Riyadh, Saudi Arabia';

  @override
  String get aboutVersion => 'Version 1.0.0';

  @override
  String get aboutStatsHotels => 'Hotels';

  @override
  String get aboutStatsDestinations => 'Destinations';

  @override
  String get aboutStatsTravelers => 'Happy Travelers';

  @override
  String get aboutFeatureFlightsTitle => 'Flight Booking';

  @override
  String get aboutFeatureFlightsDesc =>
      'Search and book the best flights from hundreds of airlines worldwide.';

  @override
  String get aboutFeatureHotelsTitle => 'Hotel Stays';

  @override
  String get aboutFeatureHotelsDesc =>
      'Choose from over 1M+ hotels and apartments across the globe.';

  @override
  String get aboutFeatureCarsTitle => 'Car Rentals';

  @override
  String get aboutFeatureCarsDesc =>
      'Rent your preferred car at the best rates with an optional private driver.';

  @override
  String get aboutFeatureSupportTitle => '24/7 Support';

  @override
  String get aboutFeatureSupportDesc =>
      'Our support team is always available to assist you throughout your journey.';

  @override
  String get menuDashboard => 'My Bookings';

  @override
  String get menuAdminDashboard => 'Admin Dashboard';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuAboutUs => 'About Us';

  @override
  String get menuProfileFallback => 'Rahal User';

  @override
  String get menuNoEmail => 'No email';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsAppearanceSubtitle => 'Choose the app mode';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Choose the app language';

  @override
  String get settingsLight => 'Light';

  @override
  String get settingsDark => 'Dark';

  @override
  String get menuLogout => 'Logout';

  @override
  String get errorName => 'Must be 2–50 letters';

  @override
  String get errorAge => 'Must be between 18 and 120';

  @override
  String get errorNationalId => 'Must be 8–20 alphanumeric characters';

  @override
  String get upcomingTrip => 'Upcoming trip';

  @override
  String get specialOffers => 'Special offers';

  @override
  String get specialOffer => 'Special Offer';

  @override
  String get offerBadge => 'APP EXCLUSIVE';

  @override
  String get offerWelcomeGift => 'Your welcome gift.';

  @override
  String get offerDiscount => '20% off everything.';

  @override
  String get offerCodeLabel => 'Code';

  @override
  String get offerCodeCopied => 'Code copied: RAHAL20';

  @override
  String get offerCopyCode => 'Copy Code';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentCreditCard => 'Credit card';

  @override
  String get paymentDebitCard => 'Debit card';

  @override
  String get paymentCardNumber => 'Card number';

  @override
  String get paymentCardholderName => 'Cardholder name';

  @override
  String get paymentCardholderHint => 'Name on card';

  @override
  String get paymentExpiry => 'Expiry date';

  @override
  String get paymentCvv => 'CVV';

  @override
  String get paymentSaveCard => 'Save card';

  @override
  String get paymentSaveCardSub => 'For faster checkout next time';

  @override
  String get paymentSecureNote => 'Your payment is secured';

  @override
  String get paymentErrorCardNumberRequired => 'Enter your card number';

  @override
  String get paymentErrorCardNumberInvalid => 'Enter a valid card number';

  @override
  String get paymentErrorCardholderRequired => 'Enter the cardholder name';

  @override
  String get paymentErrorCardholderInvalid => 'Enter a valid name';

  @override
  String get paymentErrorExpiryRequired => 'Enter the expiry date';

  @override
  String get paymentErrorExpiryInvalid => 'Enter a valid expiry date';

  @override
  String get paymentErrorExpiryExpired => 'This card has expired';

  @override
  String get paymentErrorCvvRequired => 'Enter the CVV';

  @override
  String get paymentErrorCvvInvalid => 'Enter a valid CVV';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get airport => 'Airport';

  @override
  String get downtown => 'Downtown';

  @override
  String get trainStation => 'Train Station';

  @override
  String get hotelDistrict => 'Hotel District';

  @override
  String get shoppingDistrict => 'Shopping District';

  @override
  String get industrialZone => 'Industrial Zone';

  @override
  String get airportRoad => 'Airport Road';

  @override
  String get dubai => 'Dubai';

  @override
  String get abuDhabi => 'Abu Dhabi';

  @override
  String get sharjah => 'Sharjah';

  @override
  String get riyadh => 'Riyadh';

  @override
  String get jeddah => 'Jeddah';

  @override
  String get cairo => 'Cairo';

  @override
  String get alexandria => 'Alexandria';

  @override
  String get giza => 'Giza';

  @override
  String get aswan => 'Aswan';

  @override
  String get doha => 'Doha';

  @override
  String get alRayyan => 'Al Rayyan';

  @override
  String get manama => 'Manama';

  @override
  String get muharraq => 'Muharraq';

  @override
  String get muscat => 'Muscat';

  @override
  String get salalah => 'Salalah';

  @override
  String get kuwaitCity => 'Kuwait City';

  @override
  String get salmiya => 'Salmiya';

  @override
  String get amman => 'Amman';

  @override
  String get zarqa => 'Zarqa';

  @override
  String get beirut => 'Beirut';

  @override
  String get tripoli => 'Tripoli';

  @override
  String get istanbul => 'Istanbul';

  @override
  String get ankara => 'Ankara';

  @override
  String get izmir => 'Izmir';

  @override
  String get london => 'London';

  @override
  String get manchester => 'Manchester';

  @override
  String get birmingham => 'Birmingham';

  @override
  String get paris => 'Paris';

  @override
  String get lyon => 'Lyon';

  @override
  String get marseille => 'Marseille';

  @override
  String get madrid => 'Madrid';

  @override
  String get barcelona => 'Barcelona';

  @override
  String get seville => 'Seville';

  @override
  String get rome => 'Rome';

  @override
  String get milan => 'Milan';

  @override
  String get venice => 'Venice';

  @override
  String get berlin => 'Berlin';

  @override
  String get munich => 'Munich';

  @override
  String get hamburg => 'Hamburg';

  @override
  String get tokyo => 'Tokyo';

  @override
  String get osaka => 'Osaka';

  @override
  String get kyoto => 'Kyoto';

  @override
  String get singapore => 'Singapore';

  @override
  String get bangkok => 'Bangkok';

  @override
  String get phuket => 'Phuket';

  @override
  String get chiangMai => 'Chiang Mai';

  @override
  String get delhi => 'Delhi';

  @override
  String get mumbai => 'Mumbai';

  @override
  String get bangalore => 'Bangalore';

  @override
  String get seoul => 'Seoul';

  @override
  String get busan => 'Busan';

  @override
  String get incheon => 'Incheon';

  @override
  String get newYork => 'New York';

  @override
  String get losAngeles => 'Los Angeles';

  @override
  String get chicago => 'Chicago';

  @override
  String get miami => 'Miami';

  @override
  String get lasVegas => 'Las Vegas';

  @override
  String get toronto => 'Toronto';

  @override
  String get vancouver => 'Vancouver';

  @override
  String get montreal => 'Montreal';

  @override
  String get mexicoCity => 'Mexico City';

  @override
  String get cancun => 'Cancun';

  @override
  String get playaDelCarmen => 'Playa del Carmen';

  @override
  String get saoPaulo => 'São Paulo';

  @override
  String get rioDeJaneiro => 'Rio de Janeiro';

  @override
  String get salvador => 'Salvador';

  @override
  String get sydney => 'Sydney';

  @override
  String get melbourne => 'Melbourne';

  @override
  String get brisbane => 'Brisbane';

  @override
  String get uae => 'UAE';

  @override
  String get saudiArabia => 'Saudi Arabia';

  @override
  String get egypt => 'Egypt';

  @override
  String get qatar => 'Qatar';

  @override
  String get bahrain => 'Bahrain';

  @override
  String get oman => 'Oman';

  @override
  String get kuwait => 'Kuwait';

  @override
  String get jordan => 'Jordan';

  @override
  String get lebanon => 'Lebanon';

  @override
  String get turkey => 'Turkey';

  @override
  String get unitedKingdom => 'United Kingdom';

  @override
  String get france => 'France';

  @override
  String get spain => 'Spain';

  @override
  String get italy => 'Italy';

  @override
  String get germany => 'Germany';

  @override
  String get japan => 'Japan';

  @override
  String get thailand => 'Thailand';

  @override
  String get india => 'India';

  @override
  String get southKorea => 'South Korea';

  @override
  String get unitedStates => 'United States';

  @override
  String get canada => 'Canada';

  @override
  String get mexico => 'Mexico';

  @override
  String get brazil => 'Brazil';

  @override
  String get australia => 'Australia';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get selectCity => 'Select City';

  @override
  String get selectPickupLocation => 'Pickup Location';

  @override
  String get selectDropoffLocation => 'Dropoff Location';

  @override
  String get sameCityAsPickup => 'Same city as pickup';

  @override
  String stepOf(int step) {
    return 'Step $step of 4';
  }

  @override
  String get tripDetails => 'Trip Details';

  @override
  String get yourInformation => 'Your Information';

  @override
  String get reviewAndConfirm => 'Review & Confirm';

  @override
  String get pickupAndDropoff => 'Pickup & Drop-off';

  @override
  String get airportNotice =>
      'Pickup and drop-off are always at the city airport';

  @override
  String get pricePerDayFilter => 'Price/day';

  @override
  String get noCarsMatch => 'No cars match your filters';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get location => 'Location';

  @override
  String get until => 'Until';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get trip => 'Trip';

  @override
  String get priceBreakdown => 'Price Breakdown';

  @override
  String get continuee => 'Continue';

  @override
  String get day => 'day';

  @override
  String get days => 'days';

  @override
  String get total2 => 'total';

  @override
  String get saved => 'saved';

  @override
  String get sortPriceLow => 'Price: Low to High';

  @override
  String get sortPriceHigh => 'Price: High to Low';

  @override
  String get sortNameAZ => 'Name: A to Z';

  @override
  String get sortSeatsLow => 'Seats: Fewest First';

  @override
  String get sortSeatsHigh => 'Seats: Most First';

  @override
  String get cashOnlyTitle => 'Cash Payment Only';

  @override
  String get cashOnlyBody =>
      'We currently don\'t support online payments. Please prepare to pay in cash upon receiving the car.';

  @override
  String get searchCity => 'Search cities...';

  @override
  String get sortPriceAsc => 'Price ↑';

  @override
  String get sortPriceDesc => 'Price ↓';

  @override
  String get sortNameAz => 'A–Z';

  @override
  String get car => 'Car';

  @override
  String get info => 'Your Info';

  @override
  String get review => 'Review';

  @override
  String get bookingConfirmedTitle => 'You\'re all set!';

  @override
  String get bookingConfirmedMessage =>
      'Your booking is confirmed. Our team will be ready at the airport when you arrive.';

  @override
  String get carsCashPaymentTitle => 'Pay at Pickup — No Card Needed';

  @override
  String get carsCashPaymentBody =>
      'Pay in cash when you collect your car — no online forms, no hidden fees, no hassle.';

  @override
  String get flightsCashPaymentTitle => 'Book Now — Pay in Cash';

  @override
  String get flightsCashPaymentBody =>
      'Reserve your seat today and pay in cash — no card needed, no online forms, no hassle.';

  @override
  String get hotelsCashPaymentTitle => 'Book Now — Pay at Check-In';

  @override
  String get hotelsCashPaymentBody =>
      'Reserve your room today and pay in cash at check-in — no card needed, no online forms, no hassle.';

  @override
  String get dubaiInternationalAirport => 'Dubai International Airport';

  @override
  String get abuDhabiInternationalAirport => 'Abu Dhabi International Airport';

  @override
  String get sharjahInternationalAirport => 'Sharjah International Airport';

  @override
  String get kingKhalidInternationalAirport =>
      'King Khalid International Airport';

  @override
  String get kingAbdulazizInternationalAirport =>
      'King Abdulaziz International Airport';

  @override
  String get cairoInternationalAirport => 'Cairo International Airport';

  @override
  String get elNouzhaAirport => 'El Nouzha Airport';

  @override
  String get hamadInternationalAirport => 'Hamad International Airport';

  @override
  String get bahrainInternationalAirport => 'Bahrain International Airport';

  @override
  String get muscatInternationalAirport => 'Muscat International Airport';

  @override
  String get kuwaitInternationalAirport => 'Kuwait International Airport';

  @override
  String get queenAliaInternationalAirport =>
      'Queen Alia International Airport';

  @override
  String get beirutRaficHaririInternational =>
      'Beirut–Rafic Hariri International';

  @override
  String get istanbulAirport => 'Istanbul Airport';

  @override
  String get sabihaCokcentInternationalAirport =>
      'Sabiha Gökçen International Airport';

  @override
  String get adnanMenderesAirport => 'Adnan Menderes Airport';

  @override
  String get ankaraEsenbogaAirport => 'Ankara Esenboğa Airport';

  @override
  String get heathrowAirport => 'Heathrow Airport';

  @override
  String get gatwickAirport => 'Gatwick Airport';

  @override
  String get manchesterAirport => 'Manchester Airport';

  @override
  String get charlesDeGaulleAirport => 'Charles de Gaulle Airport';

  @override
  String get parisOrlyAirport => 'Paris-Orly Airport';

  @override
  String get adolfoSuarezMadridBarajasAirport =>
      'Adolfo Suárez Madrid–Barajas Airport';

  @override
  String get barcelonaElPratAirport => 'Barcelona–El Prat Airport';

  @override
  String get leonardoDaVinciFiumicinoAirport =>
      'Leonardo da Vinci–Fiumicino Airport';

  @override
  String get milanMalpensaAirport => 'Milan Malpensa Airport';

  @override
  String get berlinBrandenburgAirport => 'Berlin Brandenburg Airport';

  @override
  String get munichAirport => 'Munich Airport';

  @override
  String get hamburgAirport => 'Hamburg Airport';

  @override
  String get tokyoHanedaAirport => 'Tokyo Haneda Airport';

  @override
  String get naritaInternationalAirport => 'Narita International Airport';

  @override
  String get kansaiInternationalAirport => 'Kansai International Airport';

  @override
  String get singaporeChangiAirport => 'Singapore Changi Airport';

  @override
  String get suvarnabhumiAirport => 'Suvarnabhumi Airport';

  @override
  String get phuketInternationalAirport => 'Phuket International Airport';

  @override
  String get indiraGandhiInternationalAirport =>
      'Indira Gandhi International Airport';

  @override
  String get chhatrapatiShivajiInternational =>
      'Chhatrapati Shivaji International';

  @override
  String get incheonInternationalAirport => 'Incheon International Airport';

  @override
  String get gimpoInternationalAirport => 'Gimpo International Airport';

  @override
  String get johnFKennedyInternationalAirport =>
      'John F. Kennedy International Airport';

  @override
  String get laGuardiaAirport => 'LaGuardia Airport';

  @override
  String get losAngelesInternationalAirport =>
      'Los Angeles International Airport';

  @override
  String get ohareInternationalAirport => 'O\'Hare International Airport';

  @override
  String get miamiInternationalAirport => 'Miami International Airport';

  @override
  String get harryReidInternationalAirport =>
      'Harry Reid International Airport';

  @override
  String get torontoPearsonInternationalAirport =>
      'Toronto Pearson International Airport';

  @override
  String get vancouverInternationalAirport => 'Vancouver International Airport';

  @override
  String get mexicoCityInternationalAirport =>
      'Mexico City International Airport';

  @override
  String get cancunInternationalAirport => 'Cancún International Airport';

  @override
  String get saoPauloGuarulhosInternational =>
      'São Paulo–Guarulhos International';

  @override
  String get rioDeJaneiroGaleaoInternational =>
      'Rio de Janeiro–Galeão International';

  @override
  String get sydneyKingsfordSmithAirport => 'Sydney Kingsford Smith Airport';

  @override
  String get melbourneAirport => 'Melbourne Airport';

  @override
  String get brisbaneAirport => 'Brisbane Airport';

  @override
  String get all => 'all';

  @override
  String get economy => 'Economy';

  @override
  String get premiumEconomy => 'Premium Economy';

  @override
  String get business => 'Business';

  @override
  String get firstClass => 'First Class';

  @override
  String get settingsCurrencyTitle => 'Currency';

  @override
  String get settingsCurrencySubtitle => 'Choose your preferred currency';

  @override
  String get promoAlreadyUsed => 'Promo code already used';

  @override
  String get cashBannerTitle => 'Pay cash on arrival — flights, hotels & cars';

  @override
  String get cashBannerBody =>
      'Book now, no card needed. Just show up and pay cash when you get there.';

  @override
  String get inputHint => 'Ask about any destination...';

  @override
  String get welcomeMessage => 'Ask me anything about traveling!';

  @override
  String get chatbotTitle => 'Travel Assistant';

  @override
  String get askRahal => 'Ask Rahal';
}
