import 'app_download_stub.dart'
    if (dart.library.js_interop) 'app_download_web.dart'
    as platform;

const androidDownloadUrl =
    'https://github.com/Obaldevshi/economic_app/releases/latest/download/not-spent-release.apk';

void downloadAndroidApp() => platform.openDownload(androidDownloadUrl);
