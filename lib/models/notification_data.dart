
class NotificationData {
  final String title;
  final String body;
  final Map data = {
    'click_action':'FLUTTER_NOTIFICATION_CLICK'
  };
  final List<String> tokens;

  NotificationData({this.title,this.body,this.tokens});



}