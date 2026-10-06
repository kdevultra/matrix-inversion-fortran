# Fortran Matrix Inversion (Gauss-Jordan Method)

[![Fortran](https://img.shields.io/badge/Language-Fortran_95%2F2003-734f96.svg)](https://fortran-lang.org)
[![Compiler](https://img.shields.io/badge/Compiler-gfortran-informational.svg)](https://gcc.gnu.org/fortran/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A clean, modular Fortran implementation of dynamic matrix data structures and matrix inversion using the **Gauss-Jordan elimination algorithm with partial pivoting**.

---

## 📌 Overview

This project provides a reusable Fortran module (`matrix_module`) capable of allocating, manipulating, and inverting square matrices. It demonstrates core Fortran concepts including:
- Derived types with allocatable arrays (`matrix_type`).
- Modular programming (`module` / `use`).
- File I/O reading comma-separated value (CSV) matrix representations.
- Numerically stable matrix inversion using Gauss-Jordan elimination with row swapping (partial pivoting) and singularity detection.

---

## 📂 Project Structure

```text
.
├── matrix.f95          # Reusable module: matrix_type, creation, display, and Gauss-Jordan inversion
├── main.f95            # Main entry point: handles user input, file reading, and test runs
├── matrix_data.csv     # Sample comma-separated matrix data file
├── Makefile            # Standard build automation (all, run, clean)
├── compile_and_run.sh  # Automated compilation and execution bash script
├── .gitignore          # Git ignore rules for Fortran artifacts and binaries
├── LICENSE             # MIT License
└── README.md           # Project documentation
```

---

## 🚀 Features

- **Object-Oriented Style Type (`matrix_type`)**:
  Encapsulates matrix dimensions (`m`, `n`) and a 2D allocatable array (`data2D`).
- **Gauss-Jordan Elimination**:
  Transforms the augmented matrix \([A \mid I]\) into \([I \mid A^{-1}]\).
- **Partial Pivoting**:
  Searches for the largest pivot element in the current column to prevent division by near-zero elements and minimize floating-point roundoff errors.
- **Numerical Singularity Check**:
  Detects when a pivot's magnitude falls below a safety threshold (\(10^{-12}\)) and alerts the user without crashing.
- **CSV Matrix Reader**:
  Loads rows directly from CSV files using Fortran's implied `do`-loops.

---

## 🛠 Prerequisites

To compile and run this project, you need:
- **GFortran** (GNU Fortran compiler, part of GCC):
  ```bash
  # Ubuntu / Debian
  sudo apt-get update && sudo apt-get install gfortran make

  # macOS (via Homebrew)
  brew install gcc make

  # Fedora / RHEL
  sudo dnf install gcc-gfortran make
  ```

---

## ⚙️ Compilation & Execution

### Option 1: Using `make` (Recommended)

Build the executable:
```bash
make
```

Run the program:
```bash
make run
# or directly:
./main
```

Clean build artifacts (`.o`, `.mod`, and binary):
```bash
make clean
```

### Option 2: Using the Shell Script

You can compile and run directly with the provided shell script:
```bash
chmod +x compile_and_run.sh
./compile_and_run.sh
```

You may also specify custom source files:
```bash
./compile_and_run.sh main.f95 matrix.f95
```

---

## 💡 Usage & Example

### Input File (`matrix_data.csv`)

The data file contains rows of numbers separated by commas:
```csv
4,3,2,1
1,4,3,2
2,1,4,3
3,1,2,4
```

### Running the Program

When prompted, input the matrix dimensions (`rows cols`):
```text
$ ./main
 Enter the dimensions of the matrix in the data file :
4 4
 Now reading the matrix data from ´matrix_data.csv´...
 File read correctly.
 Data read successfully.
 Displaying the matrix A:
 4.000 3.000 2.000 1.000  
 1.000 4.000 3.000 2.000  
 2.000 1.000 4.000 3.000  
 3.000 1.000 2.000 4.000  
 Now inverting the matrix...
 Inverting the matrix...
 Displaying the inverted matrix :
 0.275-0.217 0.008 0.033  
 0.025 0.283-0.242 0.033  
 0.025-0.050 0.425-0.300  
-0.225 0.117-0.158 0.367  
```

---

## 🧮 Mathematical Background

Given an \(n \times n\) square matrix \(A\), the inversion procedure operates on the augmented matrix:
$$M = [A \mid I_n] \in \mathbb{R}^{n \times 2n}$$

1. **Pivoting**: For each column \(k \in \{1, \dots, n\}\), locate row \(p \ge k\) such that \(|M_{p, k}| = \max_{i \ge k} |M_{i, k}|\) and swap row \(k\) with row \(p\).
2. **Row Normalization**: Normalize row \(k\) so that \(M_{k, k} = 1\):
   $$M_{k, j} \leftarrow \frac{M_{k, j}}{M_{k, k}}, \quad \forall j \ge k$$
3. **Elimination**: For each row \(i \ne k\), subtract the scaled pivot row:
   $$M_{i, j} \leftarrow M_{i, j} - M_{i, k} \cdot M_{k, j}, \quad \forall j \ge k$$
4. **Extraction**: After completing all columns, the right half corresponds to \(A^{-1}\):
   $$M \longrightarrow [I_n \mid A^{-1}]$$

---

## 📄 License

This project is open-source and distributed under the [MIT License](LICENSE).
