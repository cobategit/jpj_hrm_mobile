# jpj_hrm_mobile

Jatim Flutter project HRM.

## Preparation, installation, enviroment

- install flutter 3.7.6
- file jks ada di root project, nama file nya: jpj_hrm_mobile.jks
- untuk file key.properties ada di folder android/key.properties, isi nya sebagai berikut:

```
storePassword=jpj2023
keyPassword=jpj2023
keyAlias=upload
storeFile=C:/laragon/www/jpj_hrm_mobile/jpj_hrm_mobile.jks
```

- untuk build project .apk jalankan perintah ' flutter build apk --no-shrink '
- untuk build project web jalankan perintah ' flutter build web '

### Folder Structure

Let's use files and folders to structure our application. Doing this allows us to communicate architecture intent:

```
/lib
│── /configs (konfigurasi seperti url api, colors, text etc)
│── /controller (fungsi yang akan dipanggil oleh widget di folder screens, logic bisnis)
├── /models (inisialisasi data yang akan diterima dari api)
|── /screens (antar muka atau ui)
|── /services (fungsi restfull api atau fungsi untuk pemanggilan global untuk api)
|── /utils (fungsi global untuk bantuan bantuan sederhana)
└── /widgets (ui atau component yang akan dipakai untuk kebutuhan screens)
```

### Deploy flutter web

- letakan folder hasil build-an web di /build pada root hostingan atau server
- buat config server nginx ( apabila menggunakan nginx, atau sesuai kan dengan yang dipakai)

```
server {
    listen 8020;
    server_name jpj_hrm_mobile.test *.jpj_hrm_mobile.test;
    root "C:/laragon/www/jpj_hrm_mobile/build/web";

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
		autoindex on;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass php_upstream;
        #fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }


    charset utf-8;

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }
    location ~ /\.ht {
        deny all;
    }
}

# This file is auto-generated.
# If you want Laragon to respect your changes, just remove the [auto.] prefix
# If you want to use SSL, enable it at: Menu > Nginx > SSL > Enabled

```

### Noted

- apabila ingin membuild project ke web, perhatikan pada file absensi_controller dan auth_controller, didalam file tersebut ada import dart:html yang comment, jadi buka comment yang berkaitan dengan html
