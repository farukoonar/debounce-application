# VHDL Parametric Debounce Filter (FSM & 2-Stage Synchronizer)

**[TR]** Mekanik kontak sıçramalarını (bouncing) ve metastabiliteyi önleyen, FSM ve zamanlayıcı tabanlı, generic parametreli VHDL Debounce modülü.  
**[EN]** A robust, generic VHDL debounce filter designed to eliminate mechanical contact bounces and metastability using an FSM, timer, and a 2-stage synchronizer.

---

## Özellikler / Features

| Parametre / Parameter | Değer / Value | Açıklama (TR) | Description (EN) |
| :--- | :--- | :--- | :--- |
| **Clock Input** | 100 MHz | Dahili sistem osilatörü | On-board system oscillator |
| **Debounce Time** | 10 ms | Kararlı durum eşik süresi | Stable state threshold time |
| **Synchronizer** | 2-Stage FF | Metastabilite koruması | Double flip-flop synchronizer |
| **Target Board** | Digilent Basys 3 
| **Outputs** | 16 LEDs | 8-bit Filtreli + 8-bit Filtresiz Sayaç | 8-bit Debounced + 8-bit Raw Counter |

---

## Çalışma Prensibi / Working Principle

**[TR]**
1. **2 Kademeli Senkronizör:** Dış dünyadan gelen asenkron buton sinyali, metastabilite riskini ortadan kaldırmak için durum makinesine girmeden önce 2 saat vuruşu boyunca bekletilip saat işaretine senkronize edilir.
2. **Durum Makinesi (FSM):** Sinyal seviye değiştirdiğinde ($0 \rightarrow 1$ veya $1 \rightarrow 0$) durum makinesi geçiş durumuna girer ve zamanlayıcıyı başlatır.
3. **Zamanlayıcı (Timer):** Sinyal $10\text{ ms}$ boyunca kesintisiz sabit kalırsa çıkış güncellenir. Eğer $10\text{ ms}$ dolmadan sinyal tekrar sıçrarsa zamanlayıcı sıfırlanır ve sahte tetiklemeler tamamen engellenir.

**[EN]**
1. **2-Stage Synchronizer:** The asynchronous external input is passed through a 2-flip-flop chain to prevent metastability and align with the system clock before entering the FSM.
2. **Finite State Machine (FSM):** Detects logic level transitions ($0 \rightarrow 1$ or $1 \rightarrow 0$), moves to a transitional state, and activates the internal counter.
3. **Timer:** Validates the input only if it stays continuously stable for $10\text{ ms}$. If a bounce occurs before $10\text{ ms}$ elapses, the timer resets, completely suppressing false triggers.

---

## Simülasyon Doğrulaması / Simulation Verification

**[TR]** Vivado Simulator ile yapılan testte, $10\text{ ms}$ altındaki tüm mekanik sıçramaların filtrelendiği, durum geçişlerinin ve çıkışın yalnızca kesintisiz $10\text{ ms}$ stabil kalındığında tetiklendiği doğrulanmıştır.  
**[EN]** Verified with Vivado Simulator. All mechanical bounces shorter than $10\text{ ms}$ are filtered out; state transitions and output updates only occur after $10\text{ ms}$ of continuous stable input.

<img width="2560" height="382" alt="image" src="https://github.com/user-attachments/assets/517a7640-6e5a-4508-8c0d-cee8bcc2fee5" />

---

## Donanım Doğrulaması / Hardware Verification

**[TR]** Tasarım **Basys 3** geliştirme kartına yüklenmiş ve fiziksel switchler üzerinde test edilmiştir:
* **Sol LED'ler (`LED[7:0]`):** Filtrelenmiş switch (`SW[0]`) ile sürülür
* **Sağ LED'ler (`LED[15:8]`):** Filtresiz switch (`SW[1]`) ile sürülür

**[EN]** Implemented on the **Digilent Basys 3** FPGA board and verified using physical switches:
* **Left LEDs (`LED[7:0]`):** Driven by debounced switch (`SW[0]`)
* **Right LEDs (`LED[15:8]`):** Driven by raw switch (`SW[1]`)

[debounce.webm](https://github.com/user-attachments/assets/ecf15d7e-2015-4e23-ab78-7b3d9a6584e5)

---

## Dosya Yapısı / Project Structure

```text
├── constrs_1/
│   └── Basys-3-Master.xdc    # FPGA pin bağlantıları / Constraints file
├── sim_1/
│   └── tb_debounce.vhd       # Simülasyon testbench dosyası / Testbench module
├── sources_1/
│   ├── debounce.vhd          # Debounce filtresi çekirdek modülü / Debounce IP core
│   └── top.vhd               # Test ve LED sayıcı üst modülü / Top-level test module
└── README.md                 # Proje dokümantasyonu / Project documentation
