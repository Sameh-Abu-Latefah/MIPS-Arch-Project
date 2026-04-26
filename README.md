# MIPS Assembly - Bin Packing Problem

## Course

Computer Architecture — Birzeit University

## Students

| Name                 | ID      | Section |
| -------------------- | ------- | ------- |
| Abdulrahman Sawalmeh | 1221574 | 1       |
| Sameh Abulatifeh     | 1220257 | 2       |

## Project Description

Implementation of the **Bin Packing Problem** in MIPS Assembly language using MARS simulator. The program reads a list of items (float values between 0 and 1) from an input file and packs them into bins of capacity 1.0 using two different algorithms.

## Algorithms Implemented

- **First Fit (FF):** Places each item into the first bin that has enough remaining capacity.
- **Best Fit (BF):** Places each item into the bin with the least remaining capacity that can still fit the item.

## How to Run

1. Open [MARS MIPS Simulator](http://courses.missouristate.edu/KenVollmar/MARS/)
2. Load `ArchProject.asm`
3. Assemble and run
4. Enter the input file name when prompted
5. Choose algorithm: type `FF` for First Fit, `BF` for Best Fit, or `Q` to quit

## Input Format

A text file containing float values (between 0.0 and 1.0), one per line.

## Output

The program outputs which items are packed into each bin and the total number of used bins.
