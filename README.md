# 🧮 Matrix Operations Tool (x86 Assembly)

A console-based matrix calculator written in x86 assembly (MASM syntax) using the **Irvine32** library — built as an assembly-language course project.

**By Muzamil & Harsh**

---

## 🧩 What It Does

A menu-driven program that lets you configure two matrices (**A** and **B**) and run a set of operations on them, printing results straight to the console:

| # | Operation | Notes |
|---|-----------|-------|
| 1 | Configure Matrix A | Enter rows, columns, then each element |
| 2 | Configure Matrix B | Same, for Matrix B |
| 3 | Matrix Addition | A + B — requires matching dimensions |
| 4 | Matrix Subtraction | A − B — requires matching dimensions |
| 5 | Element Square | Squares every element of the chosen matrix |
| 6 | Element Cube | Cubes every element of the chosen matrix |
| 7 | Add Constant | Adds a constant to every element of the chosen matrix |
| 8 | Subtract Constant | Subtracts a constant from every element |
| 9 | Multiply by Constant | Scales every element by a constant |
| 10 | Divide by Constant | Divides every element by a constant |
| 11 | Transpose | 3×3 matrices only |
| 12 | 2×2 Determinant | For a matrix sized exactly 2×2 |
| 13 | 3×3 Determinant | For a matrix sized exactly 3×3 (cofactor expansion) |
| 14 | Display Matrix A | Prints the current Matrix A |
| 15 | Display Matrix B | Prints the current Matrix B |
| 16 | Exit | Quits the program |

After configuring A and/or B, most operations ask which matrix (A or B) to apply to, then print the result and wait for a keypress before returning to the main menu.

---

## 📐 Constraints

- Matrices can be up to **6×6** (36 elements), and must have at least 1 row/column — the program validates this on entry and re-prompts on invalid sizes.
- Each element is stored as a **signed byte (`sbyte`)**, so valid values are roughly **-128 to 127**. Operations like squaring, cubing, or multiplying can silently overflow this range for anything but small inputs (see [Limitations](#-known-limitations) below).
- **Transpose** and the **determinant** operations are hardcoded to fixed sizes: transpose expects a 3×3 matrix, the 2×2 determinant expects a 2×2 matrix, and the 3×3 determinant expects a 3×3 matrix — running them against a mismatched size shows a "dimensions incompatible" error.
- Addition and subtraction require A and B to have identical dimensions.

---

## 🛠️ Requirements

This program targets **32-bit x86 assembly** and depends on **Kip Irvine's `Irvine32` library** (`Irvine32.inc`), the standard teaching library used with the *Assembly Language for x86 Processors* textbook.

- **Windows** (Irvine32 relies on Win32 console APIs)
- An x86 assembler/toolchain set up with the Irvine32 library — either:
  - **Visual Studio** (with MASM / the Irvine32 project template), or
  - **MASM32 SDK** with the Irvine32 include/lib files added to your include and lib paths

## ▶️ Build & Run

1. Install the Irvine32 library and add it to your assembler/linker's include and library search paths (see the [Irvine32 setup guide](https://kipirvine.com/asm/) if you don't already have it configured).
2. Add `project.asm` to a new 32-bit console MASM project (Visual Studio) or assemble/link it directly with `ml.exe`, e.g.:
   ```
   ml /c /coff project.asm
   link /SUBSYSTEM:CONSOLE project.obj irvine32.lib kernel32.lib user32.lib
   ```
3. Run the resulting `project.exe` in a console window and follow the on-screen menu.

---

## 📌 Known Limitations

- **Byte-sized arithmetic**: matrix elements and results are single signed bytes, so multiplication, squaring, cubing, and even addition can overflow/wrap silently rather than erroring — fine for small teaching-scale inputs, not for general-purpose use.
- **Fixed-size transpose/determinant**: these three operations only work on the exact matrix size they were written for (3×3 or 2×2), not on whatever size you configured.
- **No persistence**: matrices exist only for the current run; there's no save/load.
- **Single source file**: the whole program lives in `project.asm` with no modular build — fine for a course project, but would need splitting up for anything larger.

---

## 📄 License

Course project
