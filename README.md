# 🛍️ European Fashion Store Analytics (dbt + Postgres + Power BI)

## 📌 Project Overview
Proyek ini menganalisis dataset multi-tabel dari sebuah **retail fashion store Eropa** dengan pendekatan **data warehouse + star schema**.  
Teknologi utama:
- **dbt** untuk transformasi data (staging, marts, quality tests)  
- **Postgres (pgAdmin 4)** sebagai data warehouse  
- **Power BI** untuk dashboard interaktif  

Tujuan utama: menunjukkan **kemampuan data modeling, SQL analytics, dan business insight** yang relevan untuk retail & e-commerce.

---

## 🗂️ Dataset
https://www.kaggle.com/datasets/joycemara/european-fashion-store-multitable-dataset?select=dataset_fashion_store_salesitems.csv
Dataset terdiri dari **7 tabel relational** (3,600+ baris total), clean & interconnected:

- `customers` → profil pelanggan (1,000 rows)  
- `sales` → transaksi per order (905 rows)  
- `sales_items` → detail item per transaksi (2,253 rows)  
- `products` → informasi produk (500 rows)  
- `stock` → jumlah stok per negara & produk (1,000 rows)  
- `campaigns` → promo marketing (7 rows)  
- `channels` → definisi channel penjualan (2 rows)  

---

## 🏗️ Data Modeling (Star Schema)
Pipeline dibangun dengan **dbt** dalam tiga lapisan:
- **Seeds (Raw)** → load CSV ke schema `raw`  
- **Staging** → cleaning & standardisasi (date parsing, tipe data, normalisasi)  
- **Marts**  
  - `fact_sales_items` → tabel fact utama (transaksi detail)  
  - `dim_customers`, `dim_products`, `dim_channels`, `dim_date`, `dim_campaigns`  

⭐ Hasil akhir berupa **star schema** siap untuk analisis BI.  

---
<img width="634" height="113" alt="image" src="https://github.com/user-attachments/assets/cbc7e47d-a52a-4af0-9946-58a6ffe193af" />
<img width="1606" height="343" alt="image" src="https://github.com/user-attachments/assets/9d948b65-4061-4ff5-bb47-5df47dd25394" />


## 📊 Business Insights
Analisis menghasilkan temuan kunci:

1. **Profitability & Growth**  
   - Revenue **324K** dalam 2,5 bulan, margin **43.5%** → bisnis sehat  
   - Mei tumbuh +4.9% dibanding April, Juni **projected 183.5K** (run-rate)  

2. **Channel Contribution**  
   - E-commerce 52–54%, App Mobile 46–48% → **balance channel**  
   - Strategi dual-channel terbukti efektif  

3. **Customer Retention vs Acquisition**  
   - New customer tinggi (302 Apr → 222 Mei), returning rendah (100 Mei → 72 Jun)  
   - Gap besar di **loyalty** → peluang untuk program retensi  

4. **Discount Efficiency**  
   - Hanya 7% revenue datang dari diskon, tapi margin drop **26% vs 45%**  
   - Promo harus lebih selektif → jangan sekadar “jual banyak”  

5. **Category & SKU Drivers**  
   - Top kategori: Shoes, T-Shirts, Dresses (~70K revenue tiap kategori)  
   - Produk brand **Tiva** dominan di Top 5 SKU  

---

## 📈 Dashboard (Power BI)
Dashboard menjawab pertanyaan bisnis utama:
- **KPI cards**: Revenue, Orders, Margin %  
- **Trend**: Revenue bulanan + run-rate projection  
- **Channel analysis**: Web vs App  
- **Customer funnel**: New vs Returning  
- **Discount impact**: Margin Non-Discounted vs Discounted  
- **Category & SKU**: Top Categories & Top 5 Products  

<img width="1119" height="622" alt="image" src="https://github.com/user-attachments/assets/c9ea2040-783d-4d37-9a84-92be1019079c" />
<img width="1314" height="781" alt="image" src="https://github.com/user-attachments/assets/82ae070c-b681-4058-ae89-7c406f4918c8" />
<img width="1325" height="786" alt="image" src="https://github.com/user-attachments/assets/b5548a48-cd12-483b-8d30-9bdc2f4c2a43" />
<img width="1306" height="722" alt="image" src="https://github.com/user-attachments/assets/1f8273c2-c4df-4559-a283-47495e9c0cc7" />
<img width="1314" height="787" alt="image" src="https://github.com/user-attachments/assets/c3ffc94e-faf8-4dcb-8d49-9cf3d22329c1" />
<img width="1221" height="733" alt="image" src="https://github.com/user-attachments/assets/c52ba715-95fd-43ca-9e92-91642a62e003" />


## 🧑‍💻 Key Learning Experience
- Membangun **end-to-end data pipeline** dengan dbt  
- Mendesain **star schema** sesuai praktik industri  
- Menggunakan SQL untuk **profitability, retention, discount analysis**  
- Membuat visualisasi yang **langsung actionable untuk bisnis**  
- Menghubungkan data → **strategi bisnis nyata** (growth, promo, retention, merchandising)  


📬 Contact

👤 Muhamad Rafli Fauzi
📧 mrafiifauzi03@gmail.com
🔗 https://www.linkedin.com/in/muhamad-rafli-fauzi/
