class User {
  String fName;
  String lName;
  int payNumber;
  String rank;
  String email;

  User({this.fName, this.lName, this.payNumber, this.rank, this.email});

  User.fromMap(Map userMap): this(
    fName: userMap["fName"],
    lName: userMap["lName"],
    payNumber: userMap["pay_number"],
    rank: userMap["rank"],
    email: userMap["email"],
  );

  String get fullName{
    return fName + " " + lName;
  }

  String get rankAbbreviation{
    List<String> rankWords = rank.split(' ');
    String secondLetter;
    String firstLetter = rankWords.first.substring(0, 1).toUpperCase();
    //Changes A/S to A/B in the event and able seaman is the user
   if(firstLetter == "A" && rankWords.last.substring(0, 1).toUpperCase() == "S"){
     secondLetter = "B";
   } else {
     secondLetter = rankWords.last.substring(0, 1).toUpperCase();
   }
   String abbreviation = firstLetter + "/" + secondLetter;

    return abbreviation;
  }

  String get nameAbbreviation{
    String abbreviation = fName.substring(0, 1) + lName.substring(0, 1);
    return abbreviation;
  }

}