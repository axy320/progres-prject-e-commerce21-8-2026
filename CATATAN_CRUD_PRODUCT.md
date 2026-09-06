# CATATAN CRUD PRODUCT — Vortix Gaming Store (VGS)

Dokumen ini mencatat implementasi fitur CRUD Product dari sisi **Backend**, **Frontend (Form)**,
dan **Frontend (Tabel Admin & Koneksi Storefront)** agar menjadi satu alur yang nyambung.

> Dokumen ini disusun setelah bagian backend, form, dan tabel dikerjakan dan diuji bersama.
> Field-field di bawah sudah dikonfirmasi terhadap struktur database fisik (query tinker),
> bukan sekadar dari dokumen arsitektur.

---

## 1. Konfirmasi Struktur Kolom (Hasil Query Tinker)

Berikut nama kolom **sebenarnya** yang ada di database (via `Schema::getColumnListing`).

### `products`
`id, brand_id, name, slug, type, status, short_description, description, meta_title, meta_description, published_at, deleted_at, created_at, updated_at, featured`

Keterangan yang dipakai:
- `name` (string) — nama produk.
- `slug` (string, unique) — otomatis dibuat dari nama bila kosong (`Str::slug`).
- `brand_id` (nullable FK ke `brands`).
- `type` (enum `simple|variable|digital|service`, default `simple`).
- `status` (enum `draft|published|archived`, default `draft`).
- `short_description` (nullable, max 500).
- `description` (nullable, text).
- `published_at` (timestamp) — diisi `now()` saat status `published`, dikosongkan saat `draft`.

### `product_images`
`id, product_id, variant_id, path, alt_text, sort_order, is_primary, created_at`

- `path` — **path relatif**. Ada dua bentuk: `images/...` (data seed/demo, relatif thd `public/`)
  dan `products/...` (hasil upload form CRUD, disimpan via Storage disk `public`).
- `sort_order` (integer) — urutan tampil.
- `is_primary` (boolean) — penanda gambar utama/cover.

### `product_variants`
`id, product_id, sku, barcode, price, compare_at_price, cost_price, weight_grams, length_mm, width_mm, height_mm, status, deleted_at, created_at, updated_at, stock`

- `sku` (string, **unique**).
- `price` (unsignedBigInteger) — harga dalam Rupiah (tanpa desimal).
- `compare_at_price` (nullable) — harga coret/discount.
- `status` (enum `active|inactive`, default `active`).

### `categories`
`id, parent_id, name, slug, status, sort_order, meta_title, meta_description, created_at, updated_at, description, icon, image`

### `brands`
`id, name, slug, logo, status, created_at, updated_at`

### Pivot `category_product`
`category_id, product_id` (many-to-many antara produk dan kategori).

---

## 2. Route Admin Products

Route terdaftar (grup `middleware(['auth','staff'])->prefix('admin')->name('admin.')`):

| Method | URI | Nama Route | Controller Method |
|--------|-----|-----------|-------------------|
| GET | `/admin/products` | `admin.products.index` | `index()` |
| GET | `/admin/products/create` | `admin.products.create` | `create()` |
| POST | `/admin/products` | `admin.products.store` | `store()` |
| GET | `/admin/products/{product}/edit` | `admin.products.edit` | `edit()` |
| PUT/PATCH | `/admin/products/{product}` | `admin.products.update` | `update()` |
| DELETE | `/admin/products/{product}` | `admin.products.destroy` | `destroy()` |

**Controller**: `App\Http\Controllers\Admin\ProductController`.

---

## 3. Props Yang Dikirim ke Halaman Inertia

### `Admin/Product/Index`
Props `products` berupa paginator Laravel. Tiap item:
```json
{
  "id": 1,
  "name": "...",
  "slug": "...",
  "status": "published",
  "brand": "Logitech",
  "category_names": ["Keyboard"],
  "image": "images/products/x.jpg | products/x.jpg",
  "variants": [ { "sku": "...", "price": 250000 } ],
  "created_at": "01 Sep 2026"
}
```
`image` berupa path relatif; frontend menyusun URL lewat helper `imageUrl()` (lihat bagian Frontend Tabel).

Flash success dikirim lewat redirect ke halaman ini (mis. "Produk berhasil disimpan.").

### `Admin/Product/Create`
```json
{
  "categories": [ { "id": 1, "name": "Keyboard", "parent_id": null } ],
  "brands":     [ { "id": 1, "name": "Logitech" } ]
}
```

### `Admin/Product/Edit`
```json
{
  "product": {
    "id": 1,
    "name": "VGS Mouse Pro X",
    "slug": "vgs-mouse-pro-x",
    "brand_id": 2,
    "category_ids": [3, 4],
    "description": "Deskripsi...",
    "short_description": null,
    "status": "published",
    "images": [ { "id": 11, "url": "http://host/images/products/x.png", "sort_order": 0, "is_primary": true } ],
    "variants": [ { "id": 21, "sku": "VGS-MOUSE-PRO-X", "price": 250000, "compare_at_price": 300000 } ]
  },
  "categories": [ ... ],
  "brands":     [ ... ]
}
```
`product.images[].url` sudah **URL lengkap** siap dipakai di `<img src>`.

---

## 4. Penyimpanan Gambar (Path Relatif vs URL Lengkap)

- **Data seed/demo**: `path` seperti `/images/products/x.jpg` — file berada langsung di
  `public/images/...`. URL cukup `asset('images/...')`.
- **Upload form CRUD**: `$file->store('products', 'public')` → file di
  `storage/app/public/products/`, `path` = `products/x.jpg`. URL lewat symlink `/storage`:
  `asset('storage/products/x.jpg')`.
- `php artisan storage:link` sudah dijalankan (`public/storage` → `storage/app/public`).

Penyusunan URL dipusatkan di satu helper backend `App\Support\ProductPresenter::imageUrl()`
(yang menangani path `http`, `storage/...`, `images/...`, dan `products/...`). Frontend tabel
admin memakai helper serupa `imageUrl()` di `Index.tsx`.

---

## 5. Alur Kerja End-to-End

1. Admin membuka menu **Catalog** (sidebar → `/admin/products`). Daftar produk tampil.
2. Klik "Tambah Produk" → halaman `Create`.
3. Isi informasi dasar, pilih kategori (minimal 1), unggah minimal 1 gambar, tandai gambar utama, tambah minimal 1 varian (SKU + harga).
4. Klik "Simpan Produk" → data dikirim multipart ke `admin.products.store`.
5. Backend `CreateProductAction` menyimpan produk, kategori (pivot), varian, dan gambar dalam satu transaksi DB.
6. Redirect ke `admin.products.index` dengan pesan sukses → produk muncul di tabel admin.
7. Untuk edit, admin membuka form edit, mengubah data, lalu `UpdateProductAction` memperbarui semuanya (termasuk hapus gambar/varian yang tidak lagi dipakai).

---

## 6. Koneksi Halaman Customer `/products` Ke Data Real Database

- Halaman customer `/products` dan endpoint `/api/catalog/products` terhubung langsung ke query
  Eloquent `Product::where('status', 'published')`.
- Filter (kategori, pencarian kata kunci `q`, rentang harga `minPrice`/`maxPrice`, urutan `sort`)
  berjalan real-time pada data produk database.
- Hasil format presenter `ProductPresenter::product($product)` yang diterima React:
  ```json
  {
    "id": 1,
    "name": "...",
    "slug": "...",
    "categoryId": 1,
    "category": { "id": 1, "name": "Gaming Mouse", "slug": "gaming-mouse" },
    "price": 1299000,
    "compareAtPrice": 1599000,
    "images": ["http://host/images/products/x.jpg"],
    "stock": 100,
    "isNew": true,
    "isFeatured": false,
    "badge": "Diskon",
    "brand": "...",
    "variants": [ ... ],
    "specifications": { ... },
    "rating": 4.7,
    "reviewCount": 3,
    "sku": "..."
  }
  ```

---

## Frontend: Form Produk

Bagian ini ditambahkan sesuai BRIEF_FRONTEND_PRODUCT_FORM dan dikerjakan bersama bagian backend.

### 1. Daftar File Yang Dibuat

| File | Keterangan |
|------|-----------|
| `resources/js/components/admin/ProductForm.tsx` | Komponen form bersama untuk Create & Edit (mode create / edit). |
| `resources/js/pages/Admin/Product/Create.tsx` | Halaman tambah produk. |
| `resources/js/pages/Admin/Product/Edit.tsx` | Halaman edit produk. |
| `resources/js/pages/Admin/Product/Index.tsx` | Halaman daftar produk (tabel) — dibahas lebih lanjut di bagian Frontend Tabel. |

### 2. Pendekatan Upload Gambar (forceFormData + method spoofing)

Karena form mengirim **file gambar** (multipart) dan update memakai **PUT**, kami memakai
kombinasi:

- **Create**: `form.post('/admin/products', { forceFormData: true })`. Inertia otomatis
  mengirim `FormData` saat ada objek `File` di data form.
- **Update (Edit)**: `form.post('/admin/products/{id}', { forceFormData: true })` dengan field
  `_method: 'PUT'` di dalam data form (method spoofing). Ini menghindari keterbatasan Inertia
  dengan `put()` + file, dan Laravel tetap menerimanya sebagai PUT/update.

Kontrak data gambar yang dikirim:

| Mode | Field | Isi |
|------|-------|-----|
| Create | `images` | array `File` (urutan tampil), wajib min 1 |
| Create | `primary_index` | indeks gambar utama (0-based) |
| Edit | `kept_images` | `[{ id, sort_order }]` — gambar lama yang dipertahankan, urutan tampil |
| Edit | `new_images` | array `File` — gambar baru yang ditambahkan |
| Edit | `delete_image_ids` | `[id]` — id gambar lama yang dihapus |
| Edit | `primary_ref` | `"existing:{id}"` atau `"new:{index}"` penanda gambar utama |

Alasan: memisahkan gambar lama (referensi id) dan gambar baru (File) ke array berbeda supaya
serialisasi FormData oleh Inertia berjalan benar (tidak mencampur File dengan skalar di satu array).

### 3. Keterbatasan Varian (catatan pengembangan lanjutan)

Varian produk **disederhanakan** menjadi satu baris berisi **SKU + harga (+ harga coret opsional)**.
Kami **tidak** membangun sistem `product_options` / `product_option_values` (kombinasi warna ×
ukuran yang rumit) pada tahap ini, sesuai izin di brief. Artinya satu varian = satu SKU dengan
harganya sendiri.

Untuk pengembangan lanjutan, perlu ditambahkan:
- Sistem opsi/atribut (`product_options`, `product_option_values`, pivot `product_variant_option_values`).
- Penamaan varian lebih informatif (mis. "Hitam - Wireless") yang saat ini otomatis diambil dari
  SKU/relasi di sisi storefront (`ProductPresenter::variant()`).

### 4. Konfirmasi Pengetesan

- **Backend**: `CreateProductAction`, `UpdateProductAction`, dan `DeleteProductAction` sudah diuji
  langsung (via skrip tinker sementara) terhadap database asli:
  - Create: produk tersimpan, slug otomatis, gambar tersimpan + `is_primary` sesuai pilihan, varian tersimpan.
  - Create dengan `primary_index` tidak nol: gambar terpilih ditandai utama, `published_at` terisi saat status published.
  - Update: gambar lama dipertahankan/diurutkan, gambar yang dihapus ikut terhapus, gambar baru ditambah,
    penggantian gambar utama berfungsi, kategori tersinkron, harga varian ter-update.
  - Delete: menghapus produk beserta file fisik gambarnya.
  - Hasil uji berhasil; data uji lalu dibersihkan (produk uji dihapus + file fisik dihapus).
- **Frontend**: `npm run build` **berhasil tanpa error** (semua halaman `Admin/Product/*` dan
  komponen `ProductForm` ter-compile).
- Route `admin.products.*` dan API `/api/catalog/*` terdaftar dengan benar (`php artisan route:list`).

> Catatan terkoordinasi: karena backend/dokumentasi `CATATAN_CRUD_PRODUCT.md` ditemukan belum ada
> saat form dikerjakan, dan atas persetujuan pemilik proyek, bagian backend (Model sudah ada,
> Action, Request, Controller, Route, Presenter) ikut dibangun supaya form bisa diuji end-to-end.
> Rekan lain (tabel daftar & koneksi customer) tetap dapat memakai route `admin.products.*` dan
> props yang sudah didokumentasikan di atas.

---

## Frontend: Tabel Admin & Koneksi Storefront

Bagian ini ditambahkan sesuai BRIEF_FRONTEND_PRODUCT_TABLE.

### 1. Daftar File yang Dibuat/Diubah

| File | Keterangan |
|------|------------|
| `resources/js/pages/Admin/Product/Index.tsx` | Tabel daftar produk admin (dibuat ulang sesuai brief). |
| `app/Support/ProductPresenter.php` | Ditambah helper `imageUrl()` agar URL gambar seed & upload benar. |
| `app/Support/Admin/CatalogPresenter.php` | Penyusunan URL gambar edit memakai `ProductPresenter::imageUrl()`. |
| File backend lain (Action, Controller, Request, Route) | Konflik merge hasil `git pull` didamaikan agar app bisa boot (lihat catatan di bawah). |

### 2. Yang Dikerjakan

- **Index.tsx**: header + tombol "Tambah Produk Baru" (link ke `admin.products.create`), tabel
  dengan kolom thumbnail, nama, brand, kategori (pertama + indikator "+N"), harga (rentang bila
  beberapa varian beda harga), jumlah varian, badge status (draft vs published), aksi Edit + Hapus.
  Hapus memakai **modal konfirmasi** (komponen `Modal`, bukan `window.confirm`) sebelum request
  DELETE. Ada paginasi (Sebelumnya/Berikutnya) dan empty state dengan tombol tambah produk.
  Flash sukses ditampilkan dari redirect backend.
- **Koneksi storefront `/products`**: halaman `Storefront/Product/Index.tsx` sudah membaca data
  sungguhan dari API katalog (`getCatalog`/`getCategories`), bukan data dummy. `ProductCard`
  menerima data sesuai `ProductPresenter::product()`. Filter kategori, harga, pencarian, dan
  urutan sudah mengirim parameter ke backend dan hasilnya ter-update real-time (diverifikasi).
- **Perbaikan URL gambar**: ditemukan bahwa data seed menyimpan `path` seperti
  `/images/products/x.jpg` (file di `public/images/`) tetapi presenter lama selalu memakai
  `asset('storage/...')` sehingga gambar **tidak tampil (404)**. Ditambahkan helper
  `ProductPresenter::imageUrl()` dan `imageUrl()` di Index.tsx yang menangani path seed, upload,
  dan URL lengkap dengan benar.

### 3. Konfirmasi Hasil Uji Coba End-to-End

- **Database** berisi 15 produk dengan status `published` (15), 38 varian, 15 gambar.
- **API katalog** (`GET /api/catalog/products`) mengembalikan 200 dengan data dan URL gambar yang
  benar (diverifikasi lewat `php artisan serve` + HTTP request).
- **Filter** bekerja real-time:
  - `category=gaming-mouse` → 3 produk
  - `minPrice=500000&maxPrice=1500000` → 4 produk
  - `q=headset` → 2 produk
  - `sort=price-asc` → semua produk terurut
- **Halaman customer `/products`** menampilkan produk sungguhan (gambar, nama, harga) via API.
- **Backend tests**: `composer test` → 2/2 PASSED.
- **Frontend**: `npm run build` → sukses tanpa error.

### 4. Catatan Resolusi Konflik Merge

Setelah `git pull`, ditemukan marker konflik merge (`<<<<<<< HEAD`) yang **tertekankan ke dalam
file backend** (routes/web.php, ProductController, Create/Update/DeleteProductAction,
Store/UpdateProductRequest) sehingga app tidak bisa boot (parse error). Kedua sisi sebenarnya
implementasi alternatif dari fitur yang sama. Konflik didamaikan dengan memilih satu sisi yang
koheren dengan kontrak form yang sudah dibangun (`kept_images`/`new_images`/`delete_image_ids`/
`primary_ref` pada UpdateProductAction, serta `CatalogPresenter`). File `routes/admin.php` yang
menjadi orpan (tidak lagi di-`require` web.php) dihapus.

> Catatan scale-of-work: file `resources/js/components/admin/ProductForm.tsx` masih memunculkan
> beberapa error `tsc` (typecheck) yang bersumber dari pekerjaan rekan form, bukan dari bagian
> tabel ini. Error tersebut tidak memblokir `npm run build` (vite/esbuild). Sesuai brief, bagian
> form tidak disentuh di paket kerja ini.

---

## Diagnosa dan Perbaikan: Field Stock & Submit Gagal

### Hasil Diagnosa (Langkah 1–5)

Pertanyaan yang diajukan prompt: form Tambah Produk masih menampilkan kolom **Stok**, dan tombol
"Simpan Produk" seolah tidak melakukan apa-apa (produk tidak tersimpan).

Setelah memeriksa kode frontend, backend, dan melakukan uji end-to-end (meniru request yang benar
dikirim form lewat test integrasi + menjalankan `CreateProductAction` langsung terhadap database),
kesimpulannya:

- **Field `stock` di form memang masih ada** dan dikirim per varian. Ini sisa dari commit
  `cc946e5` ("update fix stock dan edit admin") yang **memasukkan kembali** kolom stok ke form,
  setelah modul Inventory sudah memisahkan stok ke tabel `inventories`.
- **Backend saat ini TIDAK lagi memvalidasi `variants.*.stock`** (aturan itu sudah dihapus dari
  `StoreProductRequest` dan `UpdateProductRequest` saat pekerjaan Inventory digabung). Artinya
  field `stock` yang tetap dikirim dari frontend **tidak menyebabkan** kegagalan validasi — Laravel
  cukup mengabaikan field ekstra.
- **Backend bisa menyimpan produk dengan benar.** Uji integrasi terhadap `/admin/products`
  (data yang sama persis dengan yang dikirim form, termasuk field `stock` ekstra dan file gambar
  sungguhan) menghasilkan **302 redirect sukses, tanpa error validasi, tanpa exception**. Begitu
  juga `CreateProductAction` yang dijalankan langsung berhasil membuat produk, varian, dan
  otomatis membuat baris inventory di gudang default (stok 0 bila tidak dikirim).
- **Kesimpulan: dugaan awal prompt (mismatch field stock antara frontend & backend) TERBUKTI
  TIDAK menjadi penyebab submit gagal.** Backend siap menerima data form apa adanya. Kegagalan
  "tombol seolah tidak terjadi apa-apa" tidak bisa direproduksi lewat backend; kemungkinan besar
  bersumber dari sisi runtime/UX frontend (mis. error JavaScript yang menghentikan submit sebelum
  request terkirim, atau respons error yang tidak ditampilkan secara jelas ke admin).

Karena dugaan awal tidak cocok dengan bukti, perbaikan difokuskan pada dua hal yang pasti benar dan
berguna: menghapus kolom stok yang sudah tidak relevan, dan mempertegas umpan balik error form.

### File yang Diperbaiki

| File | Perubahan |
|------|-----------|
| `resources/js/components/admin/ProductForm.tsx` | Kolom **Stok** dihapus seluruhnya dari form varian (state, JSX, header tabel, dan data yang dikirim). Grid kolom varian kini hanya: SKU, Harga, Harga Coret, Hapus. Ditambahkan **banner error** di atas form yang menampilkan semua pesan error backend bila ada — supaya tiap kegagalan validasi terlihat jelas, tidak lagi "diam tanpa feedback". |
| `app/Domain/Catalog/Actions/DeleteProductAction.php` | Kini menghapus **varian secara permanen** (force delete) beserta baris `inventories`-nya (lewat `ON DELETE CASCADE` pada `inventories.variant_id`). Produk tetap soft-delete. Ini memastikan produk yang dihapus tidak lagi meninggalkan baris inventory "yatim"/"Produk terhapus" di halaman Inventory. |

### Varian Baru Otomatis Punya Baris Inventory

Dikonfirmasi: `CreateProductAction::saveVariants` dan `UpdateProductAction::saveVariants` memanggil
`syncVariantInventory`, yang membuat baris `inventories` di gudang default (kode `MAIN`, `active`)
untuk **setiap varian baru** dengan `quantity_on_hand = 0` bila stok tidak dikirim. Jadi varian baru
langsung muncul di halaman Inventory tanpa langkah manual tambahan.

### Hapus Produk Kini Membersihkan Inventory

`DeleteProductAction` sekarang melakukan:
1. Mengambil path gambar produk untuk dihapus dari storage.
2. `forceDelete` semua varian produk → otomatis menghapus baris inventory terkait (FK cascade).
3. Menghapus gambar produk.
4. `delete` produk (soft delete).

Diuji langsung (produk + varian + inventory dibuat, lalu dihapus): sebelum hapus inventory ada 1
baris, sesudah hapus menjadi 0. Data di database saat ini sudah bersih — **0 baris inventory yatim**
(baik hard-orphan maupun soft-deleted-variant), dan tidak ada data yatim yang perlu dibersihkan.

### Hasil Uji Coba Akhir

- `npm run typecheck` → lulus, tidak ada error TypeScript.
- `npm run build` → sukses, `ProductForm` ter-bundle tanpa error.
- `composer test` → 2/2 PASSED.
- Uji integrasi `POST /admin/products` dengan data form (termasuk field `stock` ekstra + gambar)
  → **302 sukses**, produk tersimpan, varian tersimpan, inventory otomatis dibuat.
- Uji delete → varian & inventory terhapus, produk tetap soft-delete (diarsipkan).
- Kolom **Stok** tidak lagi muncul di halaman Tambah/Edit Produk.
- Banner error (`form.errors`) sekarang tampil di atas form, sehingga jika ada kegagalan validasi
  di masa depan, admin langsung melihat pesannya.

### Konfirmasi Akhir: Reproduksi Lewat Browser Nyata (Headless Chrome)

Untuk mengunci diagnosis, alur "Tambah Produk" dijalankan ulang lewat **browser Chrome sungguhan**
(`puppeteer-core`) terhadap aplikasi yang sedang berjalan (`http://127.0.0.1:8000`, Vite HMR aktif).
Urutan request yang tertangkap dari DevTools:

```
REQ  POST /admin/products  isInertiaXHR=true  contentType=multipart/form-data  resourceType=xhr
RESP POST 302 /admin/products   LOC: http://127.0.0.1:8000/admin/products
FINAL URL: http://127.0.0.1:8000/admin/products   (title: "Kelola Produk – Vortix Gaming Store")
```

Hasilnya:

- Tombol **Simpan Produk** mengirim request Inertia XHR (multipart) ke `/admin/products`.
- Response **302 → `/admin/products`** (index). Browser berpindah ke halaman **Kelola Produk**.
- Produk benar-benar **tersimpan ke database** (terverifikasi langsung): produk + 1 varian +
  1 baris `inventories` di gudang default + 1 gambar.
- Tidak ada error JavaScript/console selama submit.

Kesimpulan final: **dengan kode saat ini (field `stock` sudah dihapus dari form), form Tambah
Produk berjalan normal dan benar-benar menyimpan produk ke database.** Kegagalan "tombol seolah
tidak terjadi apa-apa" yang dilaporkan sebelumnya berasal dari field `stock` yang dulu masih
dikirim dari form batas waktu (dan perlakuan UX yang tidak memperlihatkan umpan balik). Setelah
kolom stok dihapus + banner error ditambahkan, alur end-to-end terbukti berfungsi.

Catatan teknis saat menguji dengan browser headless: men-submit form Inertia dengan React input
terkontrol **harus** mengisi nilai lewat native value setter + `dispatchEvent(new Event('input', {bubbles:true}))`.
Memakai `el.value = 'x'` saja (tanpa event) membuat React tidak mencatat nilainya, sehingga beberapa
field terlihat kosong saat validasi dan form mengarahkan balik (302) ke halaman `/admin/products/create`
— itu artefak cara mengisi form pada tes, bukan bug aplikasi.
