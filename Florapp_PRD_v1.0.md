# Product Requirements Document (PRD)
# Florapp — Mobile Marketplace Tanaman Berbasis Flutter

**Versi:** 1.0  
**Status:** In Development / Rekonstruksi PRD Pasca-Development  
**Platform Utama:** Android  
**Framework:** Flutter  
**Bahasa:** Dart  
**Backend:** Firebase  
**Database:** Cloud Firestore  
**Authentication:** Firebase Authentication  
**App Protection:** Firebase App Check  
**Dokumen:** PRD yang disusun berdasarkan progres implementasi dan keputusan desain selama pengembangan

---

## 1. Tujuan Dokumen

Dokumen ini merupakan Product Requirements Document (PRD) untuk **Florapp**, aplikasi marketplace tanaman berbasis mobile.

Secara ideal, PRD dibuat sebelum proses development dimulai. Namun, karena pengembangan Florapp telah berjalan dan sejumlah fitur sudah berhasil diimplementasikan, dokumen ini disusun kembali sebagai **baseline requirement** yang mendokumentasikan:

- tujuan dan visi Florapp;
- target pengguna;
- struktur navigasi;
- fitur yang telah dibuat;
- fitur yang sedang dikembangkan;
- keputusan arsitektur dan database;
- alur pembeli dan penjual;
- kebutuhan fungsional dan non-fungsional;
- aturan keamanan;
- roadmap pengembangan berikutnya.

Dokumen ini berfungsi sebagai acuan agar pengembangan berikutnya tetap konsisten meskipun sebagian requirement baru difinalisasi setelah implementasi awal.

---

# 2. Ringkasan Produk

**Florapp** adalah aplikasi marketplace mobile yang berfokus pada jual beli tanaman. Pengguna dapat berperan sebagai **pembeli**, **penjual**, atau menjalankan kedua peran tersebut menggunakan satu akun.

Sebagai pembeli, pengguna dapat:

- melihat katalog tanaman;
- melihat detail produk;
- melihat informasi toko penjual;
- menambahkan produk ke keranjang;
- menyimpan alamat pengiriman;
- melakukan checkout;
- melihat transaksi;
- melihat status pengiriman;
- memberikan rating dan ulasan setelah transaksi selesai.

Sebagai penjual, pengguna dapat:

- memiliki profil toko;
- mengelola identitas toko;
- menambahkan tanaman yang dijual;
- melihat produk miliknya;
- mengedit produk;
- menghapus produk;
- memantau pesanan;
- memantau pengiriman;
- melihat saldo dan aktivitas penjualan;
- mengelola fitur toko melalui Shop Center.

Florapp dirancang menggunakan pendekatan marketplace modern dengan pemisahan yang jelas antara:

> **aktivitas pembelian pengguna** dan **aktivitas penjualan/toko pengguna**.

---

# 3. Latar Belakang

Tanaman merupakan produk yang memiliki karakteristik khusus dalam proses jual beli, seperti kondisi fisik tanaman, kebutuhan informasi yang cukup detail, lokasi penjual, pengemasan, pengiriman, serta kepercayaan antara pembeli dan penjual.

Marketplace umum dapat digunakan untuk menjual tanaman, tetapi aplikasi yang dirancang khusus dapat memberikan pengalaman yang lebih relevan dengan kebutuhan pengguna tanaman.

Florapp dikembangkan dengan konsep:

> **One Account, Two Roles**

Satu akun dapat digunakan sebagai:

```text
Pembeli
dan
Penjual
```

Dengan pendekatan tersebut pengguna tidak perlu membuat akun terpisah ketika ingin mulai menjual tanaman.

---

# 4. Problem Statement

Florapp dikembangkan untuk menjawab beberapa kebutuhan berikut:

1. Pengguna membutuhkan tempat khusus untuk mencari dan membeli tanaman secara digital.
2. Penjual tanaman membutuhkan cara yang sederhana untuk memasarkan dan mengelola produk.
3. Pembeli membutuhkan informasi produk dan toko sebelum membeli.
4. Penjual membutuhkan pusat pengelolaan toko tanpa harus menggunakan aplikasi terpisah.
5. Pembeli dan penjual membutuhkan status transaksi yang jelas.
6. Sistem membutuhkan mekanisme reputasi melalui rating dan review.
7. Data akun, produk, toko, keranjang, dan transaksi harus terhubung dengan identitas pengguna.

---

# 5. Product Vision

Membangun marketplace tanaman mobile yang:

- mudah digunakan;
- memiliki pengalaman pembelian yang sederhana;
- memungkinkan siapa pun yang memiliki akun menjadi penjual;
- mempunyai pemisahan jelas antara profile user dan profile toko;
- memiliki alur transaksi yang lengkap;
- aman dan scalable;
- menggunakan data nyata dari Firebase, bukan dummy data untuk fitur yang telah diintegrasikan.

---

# 6. Product Goals

## 6.1 Goal Utama

Mewujudkan aplikasi marketplace tanaman mobile yang memungkinkan proses:

```text
Cari tanaman
→ Lihat produk
→ Lihat toko
→ Masukkan keranjang
→ Checkout
→ Transaksi
→ Pengiriman
→ Selesai
→ Review
```

dan dari sisi penjual:

```text
Buat toko
→ Tambah produk
→ Kelola produk
→ Terima pesanan
→ Proses
→ Kirim
→ Selesai
→ Terima rating/review
→ Kelola pendapatan
```

## 6.2 Goal Teknis

- Menggunakan Flutter untuk frontend mobile.
- Menggunakan Firebase Authentication untuk akun.
- Menggunakan Cloud Firestore untuk data aplikasi.
- Menggunakan Security Rules untuk kontrol akses.
- Menggunakan Firebase App Check sebagai lapisan perlindungan tambahan.
- Menggunakan struktur project berbasis feature agar mudah dikembangkan.

---

# 7. Target Users

## 7.1 Buyer / Pembeli

Karakteristik:

- ingin mencari tanaman;
- ingin melihat informasi produk;
- membutuhkan alamat pengiriman;
- ingin melakukan pembelian;
- ingin memantau status pesanan;
- ingin memberikan review.

## 7.2 Seller / Penjual

Karakteristik:

- ingin menjual tanaman;
- ingin membuat identitas toko;
- ingin mengelola produk;
- ingin menerima pesanan;
- ingin mengelola pengiriman;
- ingin melihat pendapatan;
- ingin membangun reputasi toko.

## 7.3 Multi-role User

Satu akun dapat menjadi:

```text
Buyer + Seller
```

sehingga fitur pembelian dan penjualan hidup berdampingan tetapi mempunyai konteks yang berbeda.

---

# 8. Product Scope

## 8.1 In Scope

### Authentication
- Register
- Login
- Logout
- Email verification
- Password reset
- Session handling
- Penghapusan akun permanen (sesuai implementasi/finalisasi)

### Buyer
- Home
- Katalog produk
- Product Detail
- Cart
- Shipping Address
- Checkout
- Transaction
- Order status
- Favorite/Wishlist
- Rating/Review
- Notification

### Seller
- Shop Center
- Shop Profile
- Shop Settings/Tools
- Add Product
- My Products
- Edit Product
- Delete Product
- Seller Orders
- Shipping management
- Seller balance
- Sales history
- Seller verification
- Shop analytics
- Promo

### Shared
- Firebase Authentication
- Firestore
- Security Rules
- App Check
- Currency formatting Rupiah

## 8.2 Out of Scope / Tahap Lanjutan

- Payment gateway production
- Integrasi logistik eksternal
- Chat real-time
- Push notification production
- Sistem voucher kompleks
- Wallet production
- Rekening/payout production
- Analitik lanjutan
- Moderasi review tingkat lanjut

---

# 9. Navigasi Utama

Bottom Navigation Florapp menggunakan lima tab:

```text
1. Home
2. Transaksi
3. Shop
4. Notifikasi
5. Profile
```

## 9.1 Home

Fokus pada discovery dan katalog produk.

## 9.2 Transaksi

Fokus pada aktivitas pengguna sebagai pembeli.

Termasuk:

```text
Keranjang
Diproses
Dikirim
Selesai
```

## 9.3 Shop

Fokus pada aktivitas pengguna sebagai penjual.

Shop berfungsi sebagai:

> Seller Center / Shop Center

## 9.4 Notifikasi

Fokus pada informasi aktivitas akun, pembelian, dan toko.

## 9.5 Profile

Fokus pada identitas pribadi pengguna dan pengaturan akun.

---

# 10. Struktur Folder yang Direkomendasikan

Struktur project yang berkembang selama pengembangan diarahkan menjadi feature-based:

```text
lib/
├── core/
│   └── theme/
│
├── features/
│   ├── auth/
│   ├── navigation/
│   │   └── presentation/
│   │       ├── bottom_nav_page.dart
│   │       └── pages/
│   │           ├── home_page.dart
│   │           ├── transaction_page.dart
│   │           ├── shop_page.dart
│   │           ├── notification_page.dart
│   │           └── profile_page.dart
│   │
│   ├── products/
│   │   ├── domain/
│   │   │   └── product_model.dart
│   │   └── presentation/
│   │       ├── product_detail_page.dart
│   │       └── ...
│   │
│   ├── profile/
│   │   └── presentation/
│   │       ├── profile_page.dart
│   │       ├── edit_profile_page.dart
│   │       └── shipping_address_page.dart
│   │
│   ├── settings/
│   │   └── presentation/
│   │       └── settings_page.dart
│   │
│   └── shop/
│       └── presentation/
│           └── pages/
│               ├── shop_tools_page.dart
│               ├── shop_profile_page.dart
│               ├── sell_page.dart
│               ├── my_products_page.dart
│               ├── edit_product_page.dart
│               └── ...
│
└── shared/
    ├── services/
    │   ├── firestore_service.dart
    │   └── cart_service.dart
    │
    ├── utils/
    │   └── currency_formatter.dart
    │
    └── widgets/
        └── product_card.dart
```

Prinsip struktur:

- `navigation` = halaman level utama;
- `shop` = seluruh fitur seller;
- `products` = domain produk;
- `profile` = data pribadi user;
- `settings` = konfigurasi akun;
- `shared` = komponen dan service yang digunakan bersama.

---

# 11. Authentication Requirements

Florapp menggunakan Firebase Authentication.

## 11.1 Register

Input:

- Nama
- Email
- Password

Proses:

```text
Register
→ Firebase Auth createUser
→ Email verification
→ Simpan user ke Firestore
→ Sign out
→ Kembali ke Login
```

## 11.2 Login

Proses:

```text
Email + Password
→ Firebase Auth
→ Cek email verification
→ Berhasil
→ masuk ke aplikasi
```

## 11.3 Password Visibility

Password input harus memiliki tombol:

```text
Hide password
Show password
```

## 11.4 Reset Password

Login menyediakan akses:

```text
Lupa password?
```

yang mengarah ke flow reset password Firebase.

---

# 12. User Profile

User Profile berbeda dari Store Profile.

## User Profile berisi:

- Nama pribadi
- Email
- Nomor telepon
- Foto profil
- Shipping Address

Data user berada pada:

```text
users/{userId}
```

Contoh data:

```json
{
  "name": "Nama User",
  "email": "user@email.com",
  "phone": "08xxxxxxxxxx",
  "photoUrl": "https://...",
  "createdAt": "timestamp"
}
```

---

# 13. Store Profile

Store Profile adalah identitas publik toko.

Data yang direncanakan:

```text
storeName
storeDescription
storePhoto
storePhone
storeCity
storeAddress
storeIsOpen
isSeller
storeUpdatedAt
```

Konsep:

```text
User Profile
≠
Store Profile
```

Contoh:

```text
User:
Mahendra Putra

Store:
Mahen Plant House
```

Hal ini mencegah data pribadi user tampil sebagai identitas toko.

---

# 14. Home Page Requirements

Home merupakan halaman discovery.

Komponen:

- Header
- Category Menu
- Promo Banner
- Produk Terbaru
- Product Card

Data produk berasal dari Firestore secara realtime.

Perilaku ketika produk kosong:

```text
Header tetap tampil
Category tetap tampil
Promo tetap tampil
Produk Terbaru tetap tampil
Hanya bagian katalog yang menampilkan:
"Belum ada produk"
```

Sistem tidak boleh mengganti seluruh halaman dengan halaman kosong ketika collection `products` kosong.

---

# 15. Product Data Model

Product minimal memiliki:

```text
id
name
image
price
description
userId
```

`userId` wajib merepresentasikan user yang membuat produk.

Contoh:

```json
{
  "name": "Monstera",
  "image": "https://...",
  "price": 150000,
  "description": "Tanaman...",
  "userId": "firebase-user-uid"
}
```

Field `userId` digunakan untuk:

- menentukan pemilik produk;
- menampilkan produk pada My Products;
- menghubungkan produk dengan toko;
- mengontrol izin edit/hapus;
- menghubungkan review ke seller.

---

# 16. Product Card

Product Card menampilkan:

- gambar;
- nama;
- harga;
- interaksi menuju Product Detail.

Semua harga menggunakan helper global:

```text
lib/shared/utils/currency_formatter.dart
```

Format:

```text
Rp 15.000
Rp 150.000
Rp 1.500.000
```

---

# 17. Product Detail Requirements

Product Detail menampilkan:

- foto utama;
- nama produk;
- harga;
- status produk;
- status pengiriman;
- kategori;
- profil toko;
- deskripsi;
- rating;
- ulasan pembeli;
- favorite;
- chat;
- cart;
- buy now.

Data toko tidak boleh ditulis hardcoded untuk produksi.

Relasi:

```text
Product
→ userId
→ Store/User data
→ Store information
```

---

# 18. Seller Store di Product Detail

Pembeli harus dapat melihat informasi publik toko:

- nama toko;
- foto/logo toko;
- deskripsi toko;
- kota;
- status buka/tutup;
- rating toko;
- jumlah produk.

Email pribadi user tidak ditampilkan sebagai informasi toko.

---

# 19. Review & Rating

Review harus terhubung ke:

- produk;
- pembeli;
- penjual.

Struktur yang direkomendasikan:

```text
products/{productId}/reviews/{reviewId}
```

Data review:

```text
buyerId
buyerName
buyerPhoto
sellerId
rating
comment
createdAt
```

Tujuan:

```text
buyerId
→ mengetahui siapa pembeli yang memberikan review

sellerId
→ mengetahui toko/penjual yang menerima review

productId
→ mengetahui produk yang diulas
```

Review idealnya hanya dapat diberikan setelah transaksi selesai.

---

# 20. Firestore Review Structure

Contoh:

```text
products
└── productId
    └── reviews
        └── reviewId
            ├── buyerId
            ├── buyerName
            ├── buyerPhoto
            ├── sellerId
            ├── rating
            ├── comment
            └── createdAt
```

Detail Product menampilkan:

```text
Ulasan Pembeli
★★★★★ 4.8
12 ulasan

Nama Pembeli
★★★★★
Tanamannya sehat dan packing bagus.
```

---

# 21. Shop Center

Shop Center adalah dashboard seller.

Fungsi utama:

```text
Shop Center
├── Profil toko
├── Jual barang
├── Produk saya
├── Pesanan
├── Pengiriman
├── Saldo
├── Chat
├── Promo
├── Analitik
└── Pengaturan/Fitur toko
```

Shop Center harus fokus terhadap aktivitas jualan, bukan pengaturan akun pribadi.

---

# 22. Shop Tools / Shop Settings

Daripada menaruh seluruh fitur toko di halaman Shop utama, tombol settings pada Shop Center membuka halaman **Fitur Toko**.

Contoh:

```text
Shop Center
↓
Settings
↓
Fitur Toko
```

Isi:

### Identitas Toko
- Profil Toko
- Verifikasi Penjual

### Keuangan
- Riwayat Saldo
- Rekening Penarikan

### Operasional
- Pengaturan Pengiriman
- Promo Toko
- Analitik Toko

### Bantuan
- Pusat Bantuan Seller

Halaman Shop utama tetap fokus pada dashboard.

---

# 23. Jual Barang

Fitur Jual Barang membuka `SellPage`.

Input saat ini:

- Nama Produk
- Image URL
- Harga
- Deskripsi Produk

Saat upload berhasil:

```text
SellPage
→ tambah produk
→ sukses
→ kembali/masuk ke My Products
```

Foto produk menggunakan URL pada tahap saat ini karena Firebase Storage tidak digunakan.

---

# 24. My Products

My Products hanya menampilkan produk milik user yang login.

Query berdasarkan:

```text
userId == currentUser.uid
```

Fitur:

- jumlah produk;
- melihat daftar produk;
- tambah produk;
- edit;
- hapus.

---

# 25. Edit Product

Edit Product memungkinkan seller mengubah:

- nama;
- image;
- harga;
- deskripsi.

Update dilakukan ke document:

```text
products/{productId}
```

dan field:

```text
updatedAt
```

diperbarui.

---

# 26. Delete Product

Seller dapat menghapus produk melalui konfirmasi.

Perilaku:

```text
Klik Hapus
→ Dialog konfirmasi
→ Hapus
→ Firestore delete
→ Produk hilang dari Shop dan Home
```

Hanya pemilik produk yang boleh menghapus.

---

# 27. Transaction Page

Tab bottom navigation **Transaksi** merupakan area pembelian user.

Tab:

```text
Keranjang
Diproses
Dikirim
Selesai
```

Ini **berbeda** dari transaksi pada Shop Center.

### Transaction Page
= pembelian oleh user

### Shop Center
= penjualan oleh seller

---

# 28. Cart / Keranjang

Cart diletakkan di dalam Transaction Page.

Struktur:

```text
users/{userId}/cart/{productId}
```

Data:

```text
productId
name
image
price
quantity
sellerId
createdAt
updatedAt
```

Fitur:

- add to cart;
- increment quantity;
- decrement quantity;
- remove item;
- total item;
- subtotal;
- total pembayaran;
- checkout.

---

# 29. Cart Behavior

Jika produk belum ada:

```text
quantity = 1
```

Jika produk sudah ada:

```text
quantity + 1
```

Jika quantity menjadi 0:

```text
item dihapus
```

Semua total dihitung berdasarkan:

```text
price × quantity
```

---

# 30. Shipping Address

Shipping Address merupakan data untuk kebutuhan checkout.

Field:

```text
shippingFullName
shippingPhone
shippingCity
shippingProvince
shippingPostalCode
shippingAddress
```

Saat ini dapat ditempatkan pada:

```text
users/{userId}
```

untuk MVP.

Untuk tahap lanjutan, dapat dikembangkan menjadi:

```text
users/{userId}/addresses/{addressId}
```

agar mendukung multi-alamat.

---

# 31. Checkout

Checkout merupakan jembatan antara Cart dan Order.

Informasi:

- item;
- quantity;
- subtotal;
- alamat pengiriman;
- ongkos kirim;
- total;
- metode pembayaran.

Flow:

```text
Cart
↓
Checkout
↓
Alamat
↓
Konfirmasi
↓
Pembayaran
↓
Create Order
```

---

# 32. Order Architecture

Collection:

```text
orders/{orderId}
```

Data utama:

```text
buyerId
sellerId
items
totalPrice
shippingAddress
status
createdAt
updatedAt
```

Status:

```text
pending_payment
processing
shipped
completed
cancelled
```

---

# 33. Multi-Seller Order Consideration

Karena Florapp adalah marketplace, satu keranjang berpotensi berisi produk dari beberapa seller.

Implementasi awal dapat menggunakan satu order per seller saat checkout agar:

```text
Seller A
dan
Seller B
```

memiliki pesanan yang terpisah.

Contoh:

```text
Checkout
├── Order A → Seller A
└── Order B → Seller B
```

Hal ini penting untuk pengiriman dan status seller.

---

# 34. Seller Order Management

Seller dapat melihat pesanan yang memiliki:

```text
sellerId == currentUser.uid
```

Status:

```text
Menunggu Diproses
Perlu Dikirim
Dalam Pengiriman
Selesai
```

Seller tidak boleh mengubah order milik seller lain.

---

# 35. Notifikasi

Notifikasi harus mendukung dua konteks.

### Buyer
- order created;
- payment;
- processing;
- shipped;
- completed;
- request review.

### Seller
- new order;
- product sold;
- need to ship;
- completed order;
- new review.

---

# 36. Wishlist / Favorite

User dapat menyimpan produk favorit.

Konsep data:

```text
users/{userId}/wishlist/{productId}
```

Fitur:

- tambah;
- hapus;
- lihat wishlist.

---

# 37. Chat

Fitur chat antara buyer dan seller direncanakan, tetapi belum menjadi bagian inti implementasi awal.

Konsep:

```text
buyer
↕
seller
```

Chat dapat dikembangkan menggunakan:

```text
conversations
messages
```

di tahap berikutnya.

---

# 38. Seller Balance

Shop Center memiliki konsep saldo penjualan.

Saldo pada UI saat ini masih berupa struktur awal.

Untuk production, saldo tidak boleh hanya diubah dari client secara bebas.

Model production sebaiknya:

```text
orders
→ payment verified
→ seller ledger
→ balance
→ payout
```

Perubahan saldo perlu dikontrol oleh backend/trusted environment.

---

# 39. Currency Formatting

Semua tampilan harga harus konsisten menggunakan:

```text
intl
```

dan helper:

```text
lib/shared/utils/currency_formatter.dart
```

Function:

```dart
formatRupiah(value)
```

Format:

```text
Rp 5.000
Rp 25.000
Rp 150.000
Rp 1.500.000
```

Input field harga tetap menggunakan angka tanpa format mata uang:

```text
150000
```

sedangkan UI menggunakan:

```text
Rp 150.000
```

---

# 40. Firebase Storage Decision

Firebase Storage **tidak digunakan untuk tahap saat ini** karena pertimbangan biaya dan kebutuhan proyek.

Sebagai gantinya, image produk/profile dapat menggunakan URL eksternal pada tahap pengembangan.

Namun, secara production:

> penyimpanan file sebaiknya menggunakan storage yang dikendalikan aplikasi, CDN, atau object storage yang sesuai.

Keputusan ini perlu ditinjau kembali sebelum aplikasi dirilis secara publik.

---

# 41. Firebase App Check

Firebase App Check telah didaftarkan untuk aplikasi.

Status development yang digunakan:

```text
Monitoring
```

dan belum dipaksakan menjadi:

```text
Enforced
```

Tujuannya untuk menguji integrasi tanpa memblokir request aplikasi yang belum mengirim token App Check.

Saat production, App Check harus dikonfigurasi dan diverifikasi sebelum enforcement diaktifkan.

---

# 42. Firestore Security Rules

Prinsip rules:

## Products

- Read: public
- Create: authenticated user dan `userId` harus sama dengan `request.auth.uid`
- Update/Delete: hanya owner

## Users

- Read: authenticated
- Write: hanya owner

## Cart

- Read/Write: hanya owner dari cart

## Reviews

- Read: public
- Create: authenticated buyer
- Rating: 1–5
- Update/Delete: hanya pemilik review

Contoh baseline rules:

```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /products/{productId} {
      allow read: if true;

      allow create: if request.auth != null
                    && request.resource.data.userId == request.auth.uid;

      allow update, delete: if request.auth != null
                            && resource.data.userId == request.auth.uid;
    }

    match /products/{productId}/reviews/{reviewId} {
      allow read: if true;

      allow create: if request.auth != null
                    && request.resource.data.buyerId == request.auth.uid
                    && request.resource.data.sellerId is string
                    && request.resource.data.rating is number
                    && request.resource.data.rating >= 1
                    && request.resource.data.rating <= 5;

      allow update, delete: if request.auth != null
                            && resource.data.buyerId == request.auth.uid;
    }

    match /users/{userId} {
      allow read: if request.auth != null;

      allow write: if request.auth != null
                   && request.auth.uid == userId;
    }

    match /users/{userId}/cart/{cartItemId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }
  }
}
```

**Catatan:** Rules ini merupakan baseline development, bukan final security model untuk production. Order, payout, review eligibility, dan operasi sensitif sebaiknya diperketat ketika fitur tersebut sudah diimplementasikan.

---

# 43. Data Access Principles

Client tidak boleh dapat:

- memodifikasi produk seller lain;
- memodifikasi cart user lain;
- memodifikasi profile user lain;
- memanipulasi ownership dengan mengubah `userId`.

Ownership harus diverifikasi melalui Security Rules.

---

# 44. UI/UX Requirements

Karakter visual Florapp:

- modern;
- clean;
- green-oriented;
- card based;
- mobile friendly;
- rounded corners;
- subtle shadow;
- clear hierarchy;
- safe area aware.

Warna utama:

```text
#4CAF50
```

Warna sekunder:

```text
#81C784
```

Background:

```text
Colors.grey.shade100
```

---

# 45. Safe Area Requirements

Halaman utama harus menghormati:

- status bar;
- notch;
- navigation bar;
- gesture area.

Gunakan:

```dart
SafeArea(...)
```

secara konsisten.

Khusus halaman yang memiliki bottom navigation/action bar, area bawah harus tetap aman.

---

# 46. Responsive Behavior

UI harus tetap usable pada:

- layar kecil;
- layar besar;
- aspect ratio berbeda;
- notch;
- navigation gesture.

Scrolling harus digunakan untuk halaman dengan konten panjang.

---

# 47. Error Handling

Minimal setiap operasi Firebase harus memiliki:

- loading state;
- success feedback;
- error feedback;
- mounted/context safety;
- empty state.

Contoh:

```text
Loading
→ progress indicator

Success
→ SnackBar / visual feedback

Error
→ SnackBar / error state

Empty
→ empty state yang tetap mempertahankan layout halaman
```

---

# 48. Performance Requirements

- Gunakan Firestore stream hanya ketika realtime update memang diperlukan.
- Hindari rebuild yang tidak perlu.
- Gunakan lazy loading untuk list besar pada tahap lanjutan.
- Gunakan cached network image strategy bila katalog sudah besar.
- Hindari nested scroll berlebihan.
- Jangan melakukan query tidak terbatas untuk production.

---

# 49. Security Requirements

Minimum:

- Firebase Authentication.
- Firestore Security Rules.
- App Check.
- Ownership validation.
- Validasi input client.
- Validasi ulang pada server/rules untuk data sensitif.

Production harus mempertimbangkan:

- Cloud Functions / trusted backend untuk operasi sensitif;
- server-side order validation;
- payment verification;
- payout verification;
- review eligibility validation.

---

# 50. Functional Requirements

## FR-01 Authentication

Sistem harus dapat membuat akun menggunakan email dan password.

## FR-02 Verification

Sistem harus mendukung verifikasi email.

## FR-03 Login

Sistem harus dapat mengautentikasi pengguna.

## FR-04 Profile

Sistem harus dapat menyimpan dan memperbarui profile user.

## FR-05 Home

Sistem harus menampilkan produk dari Firestore.

## FR-06 Product Detail

Sistem harus menampilkan detail produk dan toko penjual.

## FR-07 Seller Ownership

Sistem harus menghubungkan produk dengan user penjual.

## FR-08 Product Management

Seller harus dapat create/read/update/delete produk miliknya.

## FR-09 Cart

Buyer harus dapat menambah, mengurangi, dan menghapus item cart.

## FR-10 Shipping Address

Buyer harus dapat menyimpan alamat pengiriman.

## FR-11 Checkout

Buyer harus dapat membuat order dari cart.

## FR-12 Transaction

Buyer harus dapat melihat status transaksi.

## FR-13 Seller Orders

Seller harus dapat melihat pesanan yang berkaitan dengan tokonya.

## FR-14 Review

Buyer harus dapat memberikan rating/review sesuai aturan transaksi.

## FR-15 Notification

Sistem harus menyediakan informasi aktivitas pengguna.

## FR-16 Wishlist

Buyer harus dapat menyimpan produk favorit.

## FR-17 Seller Profile

Seller harus dapat mengelola identitas toko.

---

# 51. Non-Functional Requirements

## NFR-01 Usability

Aplikasi harus mudah dipahami tanpa tutorial panjang.

## NFR-02 Maintainability

Source code harus terorganisasi berdasarkan fitur/domain.

## NFR-03 Scalability

Data architecture harus dapat berkembang tanpa redesign besar.

## NFR-04 Security

Akses data harus dikontrol melalui Firebase Security Rules.

## NFR-05 Reliability

Operasi Firestore harus menangani loading/error/empty state.

## NFR-06 Performance

Data yang ditampilkan harus memiliki respons yang wajar dan tidak menyebabkan UI freeze.

## NFR-07 Consistency

Format harga, spacing, warna, dan komponen UI harus konsisten.

---

# 52. User Flow — Buyer

```text
Register/Login
      ↓
Home
      ↓
Cari/lihat tanaman
      ↓
Product Detail
      ↓
Lihat toko
      ↓
Tambah ke Cart
      ↓
Transaksi → Keranjang
      ↓
Checkout
      ↓
Shipping Address
      ↓
Konfirmasi
      ↓
Pembayaran
      ↓
Diproses
      ↓
Dikirim
      ↓
Selesai
      ↓
Rating & Review
```

---

# 53. User Flow — Seller

```text
Login
  ↓
Shop
  ↓
Shop Center
  ↓
Store Profile
  ↓
Tambah Produk
  ↓
Produk Saya
  ↓
Produk tampil di Home
  ↓
Buyer membeli
  ↓
Pesanan masuk
  ↓
Proses
  ↓
Kirim
  ↓
Selesai
  ↓
Review dari buyer
  ↓
Pendapatan
```

---

# 54. Firestore Data Model

Konsep awal:

```text
Firestore
│
├── users
│   └── {userId}
│       ├── name
│       ├── email
│       ├── phone
│       ├── photoUrl
│       ├── shippingFullName
│       ├── shippingPhone
│       ├── shippingCity
│       ├── shippingProvince
│       ├── shippingPostalCode
│       ├── shippingAddress
│       ├── storeName
│       ├── storeDescription
│       ├── storePhoto
│       ├── storePhone
│       ├── storeCity
│       ├── storeAddress
│       ├── storeIsOpen
│       └── isSeller
│
│       └── cart
│           └── {productId}
│
├── products
│   └── {productId}
│       ├── name
│       ├── image
│       ├── price
│       ├── description
│       ├── userId
│       ├── createdAt
│       └── updatedAt
│
│       └── reviews
│           └── {reviewId}
│
├── orders
│   └── {orderId}
│
├── notifications
│   └── {notificationId}
│
└── ...
```

---

# 55. Catatan Arsitektur Store

Untuk MVP, data toko masih dapat berada di:

```text
users/{userId}
```

Namun untuk production marketplace, struktur yang lebih sehat adalah:

```text
users/{userId}
```

untuk data pribadi dan:

```text
stores/{storeId}
```

untuk data publik toko.

Migrasi tersebut dapat dilakukan ketika fitur seller semakin kompleks.

---

# 56. Status Development Saat PRD Dibuat

| Fitur | Status |
|---|---|
| Flutter project | ✅ Berjalan |
| Firebase setup | ✅ |
| Firebase Authentication | ✅ |
| Login | ✅ |
| Register | ✅ |
| Email Verification | ✅ |
| Password Reset | ✅/terintegrasi |
| Profile User | ✅ |
| Edit Profile | ✅ |
| Upload foto profile via gallery | ✅ |
| Crop foto profile | ✅ |
| Shipping Address UI | ✅ |
| Firestore Shipping Address | ✅ |
| Settings Page | ✅ |
| Bottom Navigation | ✅ |
| Home UI | ✅ |
| Firestore Product Listing | ✅ |
| Empty Product State | ✅ |
| Product Card | ✅ |
| Product Detail | ✅ |
| Seller identification via userId | ✅ |
| Store Profile UI | ✅/baseline |
| Shop Center | ✅/baseline |
| Shop Tools | ✅/baseline |
| Add Product | ✅ |
| My Products | ✅ |
| Edit Product | ✅ |
| Delete Product | ✅ |
| Currency Formatter | ✅ |
| Product Review UI | 🟡 |
| Review Firestore structure | 🟡 |
| Cart service | 🟡/baseline |
| Transaction page | 🟡/baseline |
| Checkout | ⬜ |
| Order system | ⬜ |
| Seller order management | ⬜ |
| Shipping management | ⬜ |
| Notification system | ⬜ |
| Wishlist | ⬜ |
| Chat | ⬜ |
| Seller balance | 🟡/UI baseline |
| Payment gateway | ⬜ |
| App Check | ✅ Monitoring |

---

# 57. Known Technical Decisions & Lessons

## 57.1 Empty Firestore Collection

Collection `products` boleh kosong tanpa menyebabkan seluruh HomePage kosong.

Yang kosong hanya katalog produk.

## 57.2 Product Ownership

Produk harus mempunyai:

```text
userId
```

agar dapat diketahui siapa seller-nya.

## 57.3 User vs Store

Identitas toko dan identitas pribadi user tidak boleh dianggap sebagai hal yang sama.

## 57.4 Cart Location

Karena bottom tab sudah diubah menjadi:

```text
Transaksi
```

maka cart ditempatkan sebagai bagian dari Transaction Page, bukan bottom tab terpisah.

## 57.5 Shop Navigation

Shop tetap menjadi tab utama, sedangkan fitur pengelolaan toko diletakkan lebih dalam melalui Shop Tools/Settings.

## 57.6 Storage

Firebase Storage sementara tidak digunakan.

## 57.7 Currency

Semua harga memakai formatter global agar konsisten.

---

# 58. Recommended Development Roadmap

Karena project sudah berjalan, roadmap berikut dibuat berdasarkan kondisi aktual.

## Phase 1 — Foundation
- Authentication
- User Profile
- Firestore Rules
- Product Model
- Home

**Status: sebagian besar selesai**

## Phase 2 — Seller
- Shop Center
- Shop Profile
- Sell Product
- My Products
- Edit Product
- Delete Product

**Status: sebagian besar selesai**

## Phase 3 — Buyer Cart
- Cart Service
- Cart UI
- Quantity
- Remove item
- Total

**Status: sedang dikembangkan**

## Phase 4 — Checkout
- Shipping Address integration
- Order summary
- Shipping cost
- Checkout confirmation

## Phase 5 — Order
- Create order
- Buyer transaction status
- Seller order management

## Phase 6 — Shipping
- Shipping status
- Seller shipping management
- Buyer tracking

## Phase 7 — Review
- Review creation after completed order
- Rating aggregation
- Seller reputation

## Phase 8 — Engagement
- Wishlist
- Notification
- Chat

## Phase 9 — Financial
- Seller balance
- Transaction history
- Payout
- Payment gateway

## Phase 10 — Production Hardening
- App Check enforcement
- Security audit
- Server-side validation
- Monitoring
- Performance optimization
- Production release

---

# 59. Acceptance Criteria MVP

Florapp dapat dianggap memiliki MVP marketplace apabila pengguna dapat:

### Buyer
- register;
- login;
- melihat produk;
- membuka detail produk;
- melihat toko penjual;
- memasukkan produk ke cart;
- mengatur alamat;
- checkout;
- melihat order;
- melihat status order;
- memberikan review setelah order selesai.

### Seller
- masuk ke Shop;
- memiliki profile toko;
- menambah produk;
- melihat produk sendiri;
- edit produk;
- menghapus produk;
- menerima order;
- memproses order;
- memperbarui status pengiriman;
- melihat penjualan.

---

# 60. Out-of-Scope MVP

Fitur berikut tidak menjadi penghambat MVP pertama:

- live chat;
- payment gateway kompleks;
- multi-wallet;
- promo engine kompleks;
- rekomendasi AI;
- analytics lanjutan;
- live tracking kurir;
- sistem affiliate.

---

# 61. Risiko Produk

## Risiko 1 — Manipulasi Client

User dapat mencoba mengubah data melalui client.

Mitigasi:

- Security Rules;
- ownership verification;
- trusted backend untuk operasi sensitif.

## Risiko 2 — Product tanpa sellerId

Produk lama dapat tidak mempunyai `userId`.

Mitigasi:

- migration/update data;
- validasi saat upload.

## Risiko 3 — Review Palsu

User dapat memberi review tanpa pembelian jika rules hanya memvalidasi `buyerId`.

Mitigasi:

- setelah order system selesai, review hanya boleh dibuat jika user memiliki order completed yang valid.

## Risiko 4 — Harga dimanipulasi

Client bisa mengirim price berbeda.

Mitigasi:

- order menggunakan harga produk yang diverifikasi server;
- jangan mempercayai harga yang dikirim client saat checkout production.

## Risiko 5 — Payout palsu

Saldo tidak boleh diubah langsung dari client.

Mitigasi:

- backend/trusted environment;
- ledger-based balance.

---

# 62. Future Architecture Direction

Ketika Florapp semakin besar, struktur dapat berkembang menjadi:

```text
features/
├── auth/
├── home/
├── products/
├── stores/
├── cart/
├── checkout/
├── orders/
├── reviews/
├── notifications/
├── wishlist/
├── chat/
├── seller/
├── profile/
└── settings/
```

Service:

```text
shared/services/
├── auth_service.dart
├── product_service.dart
├── cart_service.dart
├── order_service.dart
├── review_service.dart
└── notification_service.dart
```

---

# 63. Definition of Done

Sebuah fitur dianggap selesai apabila:

1. UI selesai.
2. Navigation selesai.
3. Firebase integration selesai jika dibutuhkan.
4. Loading state tersedia.
5. Empty state tersedia.
6. Error state tersedia.
7. Security Rules diperbarui.
8. Data ownership tervalidasi.
9. Tidak menggunakan dummy data untuk alur nyata.
10. Tested pada kondisi normal dan edge case.

---

# 64. Final Product Structure

Secara konseptual, Florapp dibagi menjadi lima area utama:

```text
┌─────────────────────────────────────────┐
│                  FLORAPP                │
├─────────────────────────────────────────┤
│ Home                                    │
│ ├── Discovery                           │
│ ├── Category                            │
│ ├── Product                             │
│ └── Product Detail                      │
│                                         │
│ Transaksi                               │
│ ├── Keranjang                           │
│ ├── Diproses                            │
│ ├── Dikirim                             │
│ └── Selesai                             │
│                                         │
│ Shop                                    │
│ ├── Shop Center                         │
│ ├── Produk Saya                         │
│ ├── Jual Barang                         │
│ ├── Pesanan                             │
│ ├── Pengiriman                          │
│ ├── Saldo                               │
│ └── Fitur Toko                          │
│                                         │
│ Notifikasi                              │
│                                         │
│ Profile                                 │
│ ├── User Profile                        │
│ ├── Shipping Address                    │
│ └── Settings                            │
└─────────────────────────────────────────┘
```

---

# 65. Kesimpulan

Florapp merupakan aplikasi marketplace tanaman berbasis Flutter yang menggabungkan aktivitas pembelian dan penjualan dalam satu akun.

Pengembangan yang telah dilakukan membentuk fondasi marketplace yang cukup jelas:

```text
Authentication
→ Home
→ Product
→ Product Detail
→ Seller
→ Shop Center
→ Product Management
→ Cart
→ Transaction
→ Checkout
→ Order
→ Shipping
→ Review
```

Arsitektur Florapp membedakan:

```text
Profile User
```

dengan:

```text
Profile Toko
```

serta membedakan:

```text
Transaksi pembelian
```

dengan:

```text
Transaksi penjualan
```

Pemisahan tersebut menjadi dasar penting agar Florapp dapat berkembang dari aplikasi marketplace sederhana menjadi sistem marketplace yang lebih lengkap.

Karena beberapa fitur masih berada dalam tahap implementasi, PRD ini harus diperlakukan sebagai **dokumen hidup (living document)** dan diperbarui ketika terjadi perubahan pada requirement, struktur database, security rules, atau alur bisnis.

---

# 66. Next Immediate Priority

Berdasarkan posisi pengembangan saat dokumen ini dibuat, prioritas berikutnya adalah:

```text
1. Cart finalization
       ↓
2. Checkout
       ↓
3. Order creation
       ↓
4. Buyer Transaction
       ↓
5. Seller Order Management
       ↓
6. Shipping
       ↓
7. Review eligibility
       ↓
8. Notification
```

Urutan ini menjaga agar pengembangan mengikuti rantai bisnis utama marketplace:

> **produk → keranjang → checkout → order → pengiriman → selesai → review**

dan menghindari pembangunan fitur sekunder sebelum fondasi transaksi selesai.
