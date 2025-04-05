/// [EnumCheckInType] define diffrent types of checkins
enum EnumCheckInType {
  /// Guest is checked in
  checkedIn,

  /// Guest is in transist
  inTransist,

  /// Expected guest
  expected,
}

/// [EnumCheckinInfoStatus] define diffrent types of statuses while
/// informations collecting
enum EnumCheckinInfoStatus {
  /// Pending status of information collection
  pending,

  /// Pending status of information collection
  inProgress,

  /// Missing status of information collection
  missing,

  /// when informations are collected
  done,

  /// Payment type
  cash,
}

///[EnumInfoTabItemStatus] is used to managae color and icons
///of InfoTabBarItem
enum EnumInfoTabItemStatus {
  ///not completed
  notcompleted,

  ///partialy completed
  partialy,

  /// completed
  completed
}

///[EnumButtonCurve] is used to set border radius for
///of SingleSideCurvedButton
enum EnumButtonCurve {
  ///apply curve on left side
  left,

  ///apply curve on right side
  right
}

///[EnumFromWhicScreen] is used to defines navigation from which screen
enum EnumFromWhicScreen {
  ///[medical] navigation form userinformation
  ///medical section
  medical,

  ///[paymentScreen] navigation form paymentScreen
  paymentScreen,
}

///[EnumPaymentMethod] is used to defines payment methodes
enum EnumPaymentMethod {
  ///[card] payment using card
  card,

  ///[cash] navigation form paymentScreen
  cash,
}

enum EnumRideCancelledStatus {
  completed,
  accepted,
  cancelledbydriver,
  cancelledbyuser,
}

enum EnumRideStatus {
  accected,
  arrived,
  startTrip,
  endTrip,
  completeTrip,
}

enum EnumPaymentType {
  cash,
  card,
  online,
  wallet,
}
