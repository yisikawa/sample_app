//tokogeko.net
String kAuthToken =
    ' Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0IiwiZXhwIjoxNTg1MTk1Njc5fQ.Jx54qy9PqSisSsZgNWhwJQcowzWEEBuJWSoHwziLW0MvwFmYC9ahvsukVEjifwqsZHUPyEgkg0kGBbcPG6tBVA';
String kTargetUrl = 'https://tokogeko.net/';
// 10.0.2.2:10080
//String kAuthToken =
//    ' Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0IiwiZXhwIjoxNTg1NDQyMzM0fQ.GB5fUhTgpTjIrMiVrWNfTVPRvHc-Dp0sSYZSr_mfQLbPthm7G4fAeEUIWu8kKCSnnRiiURFxnEoBNLAqBZ1vMg';
//String kTargetUrl = 'http://10.0.2.2:10080/';

int kAccountNo = 0;
int kTokoFlag = 1; // 1:登校　2:下校
String kTargetDate = '';
DateTime kSelectedDate;

const String kAppTitle = '登下校　見守りアプリ';
const String kAccountPageTitle = 'アカウント';
const String kRatingPageTitle = '登下校評価';
const String kRoutePageTitle = '登下校経路';
const String kMakerPageTitle = 'マーカー';
const String kLocationPageTitle = 'ユーザー位置';

const double kMinZoom = 10.0;
const double kMaxZoom = 19.0;
const List<String> kMapHttp = [
//    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  'https://j.tile.openstreetmap.jp/{z}/{x}/{y}.png',
  'https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png',
  'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png',
  'https://cyberjapandata.gsi.go.jp/xyz/ort/{z}/{x}/{y}.jpg',
];
