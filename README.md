# Image_deduplication_fpga (Hardware-Based Image Deduplication using Perceptual Hashing)

## Overview

This project implements a hardware-efficient image deduplication system using perceptual hashing in Verilog. It is designed for applications such as wildlife camera traps, where multiple captured images are visually similar and need to be filtered to reduce storage and transmission costs.

The system converts grayscale image blocks into a compact 64-bit signature and compares signatures using Hamming distance to detect duplicates.

---

## Key Features

- Generates 64-bit perceptual image signatures
- Hybrid feature extraction:
  - aHash (32-bit): global intensity
  - dHash (24-bit): gradient/structure
  - Edge (8-bit): local intensity changes
- Hamming distance-based similarity comparison
- Configurable threshold for duplicate detection
- Fully synthesizable Verilog design
- Suitable for real-time embedded systems

---

## System Architecture



---

## Module Description

### pixel_loader.v
- Loads 64 pixels (8×8 image block)
- Computes average intensity
- Generates:
  - aHash (32-bit)
  - dHash (24-bit)
  - Edge features (8-bit)
- Outputs final 64-bit signature

### duplicate_detector.v
- Computes Hamming distance between two signatures
- Compares with threshold
- Outputs:
  - duplicate
  - distance

### image_dedup_top.v
- Integrates signature generation and comparison
- Provides end-to-end pipeline

### tb_top.v
- Testbench for full system verification
- Tests:
  - Identical images
  - Slight variations
  - Completely different images

---

## Simulation Results

Example output:





---

## How It Works with Images

1. Capture image from camera
2. Convert to grayscale
3. Downsample to 8×8 pixels
4. Feed pixel values into hardware
5. Generate 64-bit signature
6. Compare with stored signatures
7. Detect duplicates using threshold

---

## Advantages

- Compact representation (64 bits per image)
- Fast comparison using bitwise operations
- Robust to noise and lighting variations
- Low hardware complexity (no multipliers)
- Suitable for FPGA and ASIC implementation

---

## Challenges

- Balancing compact representation and accuracy
- Threshold selection for similarity detection
- Handling environmental variations
- Avoiding hash collisions

---

## Tools Used

- Verilog HDL
- Xilinx Vivado

---

## Future Improvements

- Pipeline optimization for higher throughput
- Parallel popcount implementation
- Adaptive thresholding
- DCT-based perceptual hashing
- Integration with real camera input

---

## Applications

- Wildlife monitoring systems
- Surveillance systems
- Image deduplication pipelines
- Edge AI and IoT devices

---

## Author

- Your Name

---

## Conclusion

This project demonstrates a hardware-friendly approach to perceptual image deduplication, achieving efficient and real-time performance using a compact 64-bit signature and simple digital logic.
