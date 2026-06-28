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
  String get homeDestinationsTitle => 'Explore destinations';

  @override
  String get homeSearchHint => 'Search destinations, countries, or keywords';

  @override
  String get homeOfficialWebsite => 'Official website';

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
  String get errorValidEmail => 'Enter a valid email';

  @override
  String get errorPasswordLength => 'Password must be at least 8 characters';

  @override
  String get errorLettersOnly => 'Letters only';

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
  String get selected => 'Selected';

  @override
  String get bookingDetails => 'Booking Details';

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
  String get unableToConnect => 'Unable to connect';

  @override
  String get checkConnectionRetry =>
      'Please check your connection and try again';

  @override
  String get retry => 'Retry';

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
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get selectCity => 'Select City';

  @override
  String get selectPickupLocation => 'Pickup Location';

  @override
  String get selectDropoffLocation => 'Dropoff Location';

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
  String get searchCountry => 'Search country...';

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
  String get searchCity => 'Search cities...';

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
