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
DateTime kSelectedDate = DateTime.now();

const String kAppTitle = '登下校　見守りアプリ';
const String kAccountPageTitle = 'アカウント';
const String kRatingPageTitle = '通学評価';
const String kRoutePageTitle = '通学経路';
const String kMakerPageTitle = 'マーカー';
const String kLocationPageTitle = '現在地';
