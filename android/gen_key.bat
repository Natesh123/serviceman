@echo off
"D:\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore d:\serviceman\serviceman\android\app\upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -dname "CN=Dirt2Tidy, OU=App, O=Dirt2Tidy, L=City, S=State, C=IN" -storepass D2T_app123 -keypass D2T_app123
echo Done
