-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-keep class com.google.errorprone.annotations.** { *; }
-keep class javax.annotation.** { *; }
-keep class javax.annotation.concurrent.** { *; }
-keep class com.google.crypto.tink.** { *; }
# Keep Google HTTP Client classes
-keep class com.google.api.client.http.** { *; }
-dontwarn com.google.api.client.http.**

# Keep Joda-Time classes
-keep class org.joda.time.** { *; }
-dontwarn org.joda.time.**
