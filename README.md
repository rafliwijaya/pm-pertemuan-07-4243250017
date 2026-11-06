### Pertemuan 7
### A. Identitas
- Nama: Muhammad Rafli Wijaya
- NIM: 4243250017
- Kelas: PSIK 24D
- Mata Kuliah: Pemrograman Mobile

### B. Screenshot
- Flutter Analyze
![flutteranalyze](./assets/images/analyze.png)

- Flutter Test
![flutteranalyze](./assets/images/test.png)

- Mobile: Statistik
![flutteranalyze](./assets/images/mobile_statistik.png)

- Mobile: Tambah Tugas
![flutteranalyze](./assets/images/mobile_tambah.png)

- Mobile: List Tugas
![flutteranalyze](./assets/images/mobile_tugas.png)

- Tab: Statistik
![flutteranalyze](./assets/images/tab_statisik.png)

- Tab: Tambah Tugas
![flutteranalyze](./assets/images/tab_tambah.png)

- Tab: List Tugas
![flutteranalyze](./assets/images/tab_tugas.png)

### C. Diagram
## Diagram Pembagian State (Ephemeral vs App State)

```mermaid
flowchart TD
    subgraph Root ["Root Pohon Widget"]
        App["MePlanApp"]
        Model["ChangeNotifierProvider (TugasModel)<br/><b>[ APP STATE / STATE BERSAMA ]</b><br/>• List data tugas kuliah<br/>• Operasi: tambah, toggle selesai, hapus<br/>• Perhitungan: Total, Selesai, Aktif, Persentase"]
        App --> Model
    end

    subgraph Pages ["Halaman & Navigasi"]
        Nav["KerangkaNavigasi<br/><i>(context.select)</i><br/>• Badge jumlah tugas aktif"]
        Daftar["HalamanDaftarTugas<br/><b>[ EPHEMERAL STATE ]</b><br/>• FilterChip: Semua/Aktif/Selesai<br/>• Dikelola lokal via setState"]
        Form["HalamanFormTambah<br/><b>[ EPHEMERAL STATE ]</b><br/>• TextEditingController<br/>• Dikelola di initState & dispose"]
        Statistik["HalamanStatistik<br/><i>(context.watch)</i><br/>• Grafik pencapaian & metrik angka"]
    end

    Model -->|Update Badge real-time| Nav
    Model -->|Kirim daftar tugas| Daftar
    Form -->|Kirim tugas baru via context.read| Model
    Model -->|Update otomatis persentase| Statistik

    classDef appState fill:#e1f5fe,stroke:#0288d1,stroke-width:2px,color:#01579b;
    classDef localState fill:#fff3e0,stroke:#f57c00,stroke-width:2px,color:#e65100;
    classDef observer fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px,color:#4a148c;

    class Model appState;
    class Daftar,Form localState;
    class Nav,Statistik observer;
```
Alasan Pemisahan State:
- App State (Bersama via Provider): Daftar tugas dan statistik harus diakses dan diubah oleh berbagai halaman yang terpisah rute go_router. Perubahan status tugas di halaman daftar harus otomatis memperbarui badge navigasi dan persentase di halaman statistik secara bersamaan.
- Ephemeral State (Lokal via setState): Status filter Semua/Aktif/Selesai di halaman daftar dan teks yang sedang diketik pada form hanya dibutuhkan oleh widget itu sendiri, sehingga cukup dikelola lokal dengan setState supaya render lebih efisien.

### D. Penjelasan Pemilihan Provider
Dalam pengembangan aplikasi MePlan ini, siklus hidup (lifecycle) StatefulWidget diterapkan pada HalamanFormTambah. Pengendali input teks (TextEditingController) diinisialisasi pada metode initState(). Metode ini hanya dieksekusi satu kali saat widget pertama kali dimasukkan ke dalam pohon widget (widget tree), untuk menjamin bahwa pengontrol siap menerima masukan pengguna. Selanjutnya, kedua controller wajib dibersihkan pada metode dispose() dengan memanggil _controller.dispose(). Langkah ini penting untuk mencegah kebocoran memori, karena objek controller yang tidak dibuang akan terus berada di memori meskipun pengguna telah berpindah layar.

Saya memilih Provider (ChangeNotifier) sebagai solusi state management bersama karena pendekatan ini menawarkan keseimbangan yg optimal antara keterbacaan kode (readability) dan performa. Dibandingkan dengan Cubit/BLoC yang membutuhkan definisi event/state class terpisah (boilerplate tinggi), Provider memungkinkan pemusatan logika bisnis dalam satu kelas model yang bersih. Konsumsi data di UI dioptimalkan menggunakan context.select pada badge navigasi agar hanya membangun ulang (rebuild) saat jumlah tugas aktif berubah.

### Informasi Tambahan
Untuk pratikum pertemuan 7 ada pada repository "pm_p6_pratikum_4243250017" di gabung dengan pratikum pertemuan 6

### E. Pernyataan Penggunaan AI
Saya menggunakan ai untuk membuat kerangka awal / template dari tugas ini, kemudian meminta intruksinya harus berisi apa file ini, kemudian bagaimana gambaran struktur file yg diperlukan, jika sudah buntu, saya meminta ai untuk generate kode nya kemudian mengetik ulang kode tersebut. saya juga menggunakan ai untuk membuat penjelasan yg lebih to the poin untuk readme dan diagram pada poin C.