/// Profile Item Types (100% matching Java ProfileItemType enum)
enum ProfileItemType {
  getHelp,
  notification,
  shareWithFriends,
  feedBack,
  profileSettings,
  logout,
  login,
  contactUs;

  /// Convert to string (matching Java enum names)
  String get name {
    switch (this) {
      case ProfileItemType.getHelp:
        return 'GET_HELP';
      case ProfileItemType.notification:
        return 'NOTIFICATION';
      case ProfileItemType.shareWithFriends:
        return 'SHARE_WITH_FRIENDS';
      case ProfileItemType.feedBack:
        return 'FEED_BACK';
      case ProfileItemType.profileSettings:
        return 'PROFILE_SETTINGS';
      case ProfileItemType.logout:
        return 'LOGOUT';
      case ProfileItemType.login:
        return 'LOGIN';
      case ProfileItemType.contactUs:
        return 'CONTACT_US';
    }
  }

  /// Create from string
  static ProfileItemType? fromString(String value) {
    switch (value) {
      case 'GET_HELP':
        return ProfileItemType.getHelp;
      case 'NOTIFICATION':
        return ProfileItemType.notification;
      case 'SHARE_WITH_FRIENDS':
        return ProfileItemType.shareWithFriends;
      case 'FEED_BACK':
        return ProfileItemType.feedBack;
      case 'PROFILE_SETTINGS':
        return ProfileItemType.profileSettings;
      case 'LOGOUT':
        return ProfileItemType.logout;
      case 'LOGIN':
        return ProfileItemType.login;
      case 'CONTACT_US':
        return ProfileItemType.contactUs;
      default:
        return null;
    }
  }
}
