# Antigravity AI Agent Rules - FlorApp Project

Dokumen ini adalah aturan tetap (*workspace instructions & operational rules*) yang disepakati antara pengembang (User) dan AI Assistant untuk proyek **FlorApp Marketplace**.

---

## 1. 🌿 Ringkasan Proyek & Arsitektur
- **Nama Proyek**: FlorApp (Marketplace Tanaman Hias & Sarana Tani)
- **Teknologi**: Flutter (Mobile) + Google Firebase (Cloud Firestore & Auth)
- **Dokumen Panduan Utama**: `Florapp_PRD_v1.0.md`
- **Konsep Inti**: *"One Account, Two Roles"* (1 Akun Pengguna memiliki peran ganda sebagai Pembeli dan Penjual).
- **Prinsip Gambar/Storage**: Menggunakan `AppNetworkImage` yang mendukung URL eksternal dan format Data URL Base64 (`data:image/jpeg;base64,...`) dari galeri/kamera untuk menghindari ketergantungan Firebase Storage berbayar.

---

## 2. 🔀 Aturan Alur Kerja Git & Percabangan (Git Branching Rules)

### **A. Penambahan Fitur Baru (New Features)**
- **Wajib membuat feature branch baru** dari `development`:
  ```bash
  git checkout development
  git checkout -b feature/nama-fitur
  ```
- Kerjakan seluruh kode fitur sampai selesai.
- Lakukan commit dengan format *Conventional Commits*:
  ```bash
  git add .
  git commit -m "feat(scope): deskripsi fitur baru"
  git push -u origin feature/nama-fitur
  ```
- Gabungkan (*merge*) branch fitur ke `development` dan push `development`:
  ```bash
  git checkout development
  git merge feature/nama-fitur
  git push origin development
  ```

### **B. Perbaikan Bug Ringan & Pembaruan Minor (Bug Fixes / Minor Tweaks)**
- Dikerjakan **langsung pada branch `development`**:
  ```bash
  git checkout development
  # ... Lakukan perbaikan ...
  git add .
  git commit -m "fix(scope): deskripsi perbaikan bug"
  git push origin development
  ```

### **C. Branch `main` (Production Release)**
- Branch `main` hanya digunakan sebagai baseline versi rilis stabil.
- Tidak boleh melakukan commit langsung di `main` kecuali saat rilis final dari `development`.

---

## 3. 🧪 Standar Kualitas Kode (Code Quality & Verification)
- Setiap setelah selesai melakukan penulisan kode atau perbaikan, **wajib menjalankan `flutter analyze`**.
- Memastikan kode memiliki **0 Error dan 0 Linter Issues** sebelum dianggap selesai.
- Hindari penggunaan dummy data untuk fitur yang sudah memiliki service Firestore (`OrderService`, `CartService`, `ReviewService`, `FavoriteService`, `FirestoreService`).
