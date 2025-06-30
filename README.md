# Hierarchical-off-line-optimization

Implementation of the algorithm proposed in

> **“Explicit Hierarchical Measurement Scheduling for Multi-UAV Cooperative Navigation.”**  
> * *

The repository contains **all source code (pure MATLAB)** *plus* the complete set of simulation data and reference results used in the paper.

---

## ✨ Highlights
* **One-click examples** under `Some_Examples/`; nothing else to download.  
* **Examples 18 – 22** exactly reproduce the simulation cases reported in the paper.  
* **Fully parallelised**: exploits MATLAB’s Parallel Computing Toolbox for faster runs.

---

## Directory layout
```text
├── Hierarchical-off-line-optimization/
│  ├── Some_Examples/ # ⇦ All example inputs + reference results
│  │ ├── Example1/
│  │ ├── ...
│  │ └── Example21/
│  ├── code/ # Core algorithm (MATLAB functions)
│  ├── main.m
│  └── LICENSE
└── README.md # ← you are here
```

---

## Requirements  <a name="requirements"></a>

| Tool / Toolbox               | Version tested | Notes                                                     |
| ---------------------------- | -------------- | --------------------------------------------------------- |
| **MATLAB**                   | **R2022b**     | *Every line of code is written in MATLAB*                 |
| Parallel Computing Toolbox   | R2022b         | Must be installed **and** a parallel pool must be opened  |

> ⚠️ Trying to run without the Parallel Computing Toolbox (or with the pool closed) will raise errors related to parallel workers.

---

## Quick Start / Usage

1. **Clone and fetch files**

   ```bash
   git clone https://github.com/YourUser/Hierarchical-off-line-optimization.git
   cd Hierarchical-off-line-optimization

2. **Open MATLAB R2022b and load main.m**

3. **Start the parallel pool**

   ```bash
   parpool;   % or click “Parallel” → “Start Parallel Pool”

4. **Run a specific example**
   In main.m line 22, change

   ```bash
   Example_name = 'Example21';
   ```

    to whichever examples you want (e.g. 'Example19'), then press Run.

## Contact

  Questions, feature requests, or bug reports:
  file an issue
  or email shitingyuan@sjtu.edu.cn

