class NewMessage {
  String from;
  String to;
  String message;

  NewMessage(this.from, this.to, this.message);

  Map<String, dynamic> toJson() {
    return {'from': from, 'to': to, 'message': message};
  }
}
