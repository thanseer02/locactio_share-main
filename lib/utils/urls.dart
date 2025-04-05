// ignore_for_file: public_member_api_docs

/// Server URL
// const String urlBase = 'https://hail-dev.aufy.net/api/web/driver'; //Digi
const String urlBase = 'https://api.hail-technologies.com/driver'; //live
 
// Future<String?> get urlBase => SPUtils.getString(keyBaseURL);

///onBording
String get postLogin => '/sessions';
String get postRegister => '/users';
String get postLogout => '/sessions';
String get postForgetPasswordOtpApi => '/otps';
String get postVerifyOtpApi => '/otps/verify';
String get postResetPasswordApi => '/otps/reset-password';

///trips
String get getTrips => '/trips';
String get getNewTripsApi => '/new-trips';
String get postRideAcceptApi => '/ride-requests';
String get delRejectRideApi => '/ride-requests';
String get getRejectReasonApi => '/ride-reject-reasons';
String get postRideStatusApi => '/ride-statuses';
String get getTripDetailsApi => '/trips';

///homeApi
String get getStatusApi => '/statuses';
String get postStatusApi => '/statuses';

//earnings
String get getEarningsUrl => '/earnings';
String get postWithdrawRequestsUrl => '/withdraw-requests';
String get vehicleDocUpload => '/vehicle-document-uploads';
String get postlostFound => '/lost-founds';
String get driverDocUpload => '/driver-document-uploads';
String get postswitchCategory => '/switch-vehicle-categories';
String get settings => '/settings';
String get updateProfile => '/users/profile-update';

///rating
String get getRatingsApi => '/ratings';

///notifications
String get getNotificationsApi => '/notifications';

///delete account
String get postDeleteAccountApi => '/request-for-account-deletions';

///forceUpdate
String get getForceUpdateApi => '/apps';

///google log
String get postGoogleLogApi => '/google-api-logs';

///chat push Api
String get postChatPushApi => '/chat-push-notifications';
