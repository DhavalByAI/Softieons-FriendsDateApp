String ageCalculator(String dob) {
  DateTime today = DateTime.now();
  if (today.year > int.parse(dob.toString().substring(dob.length - 4))) {
    return (today.year - int.parse(dob.toString().substring(dob.length - 4)))
        .toString();
  } else {
    return 0.toString();
  }
}
