# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep notification related classes
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver