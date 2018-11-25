const devnagariNumerals = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];

const devnagariWeekDays = [
  'आईतवार',
  'सोमवार',
  'मंगलवार',
  'बुधवार',
  'बिहीवार',
  'शुक्रवार',
  'शनिवार',
];

const devnagariWeekDaysShort = [
  'आईत',
  'सोम',
  'मंगल',
  'बुध',
  'बिही',
  'शुक्र',
  'शनि'
];

const devnagariMonths = [
  'बैशाख',
  'जेष्ठ',
  'आषाढ',
  'श्रावण',
  'भदौ',
  'आश्विन',
  'कार्तिक',
  'मंसिर',
  'पौष',
  'माघ',
  'फाल्गुन',
  'चैत',
];

const _gregorianMonths = [
  'जनवरी',
  'फरवरी',
  'मार्च',
  'अप्रेल',
  'मई',
  'जून',
  'जुलाई',
  'अगस्त',
  'सितम्बर',
  'अक्टुबर',
  'नवम्बर',
  'दिसम्बर'
];

String gregorianMonths(int month) {
  return _gregorianMonths[month - 1];
}

String intoDevnagariNumeral(int number) {
  var devnagari = number == 0 ? devnagariNumerals[0] : '';
  while (number != 0) {
    final digit = number % 10;
    devnagari = '${devnagariNumerals[digit]}$devnagari';
    number = number ~/ 10;
  }
  return devnagari;
}
