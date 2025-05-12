# Open Source Analytics Platform

This project is a low-cost, modular analytics platform developed on a Raspberry Pi 5 running Raspberry Pi OS Lite in a headless configuration. It is inspired by the spirit of Maker Faire and intended as a learning-oriented, fully open-source experiment in hands-on data engineering. The system design emphasizes simplicity, observability, and reproducibility, while promoting best practices in infrastructure automation and modern data stack tooling.

## Purpose and Philosophy

The project demonstrates how a complete analytics stack can be constructed using open-source software and infrastructure-as-code (IaC) principles for approximately $200 in total hardware cost. By combining lightweight services, declarative setup scripts and Python, the platform allows researchers, educators, and technologists to iterate quickly, deploy repeatably, and learn actively in constrained environments.

It leverages generative AI (GenAI) tools to accelerate development and emphasizes prompt engineering and quality assurance testing as key capabilities for modern data workflows.

## Development Practices

- **Infrastructure as Code**: All services are installed and configured through modular, version-controlled Bash scripts. This approach supports repeatable system provisioning and reduces manual configuration errors.
  
- **Open-Source Only**: All core components are freely available and widely used in production environments. This ensures transparency, extensibility, and long-term viability.

- **Version Control**: Git is used to track all Python code, shell scripts, configuration files, and custom assets. The local repository is restricted to a single directory to streamline backups and maintain clean system boundaries.

## Use Cases

This platform is suited for:

- Hands-on learning in modern data engineering
- Prototyping and testing pipeline orchestration
- Teaching open-source analytics stack design
- Exploring GenAI-supported development workflows

Its minimalist hardware footprint and educational emphasis make it ideal for STEM classrooms, bootcamps, independent learners, and civic technologists.

# Raspberry Pi 5 – 16GB RAM

## Overview
A powerful single-board computer designed for edge computing, prototyping, and embedded analytics — this version is configured with an upgraded 16GB LPDDR4X RAM module for high-demand workloads such as data orchestration, pipelines, or local inference.

## Core Specs

- **CPU:** Broadcom BCM2712, 4× ARM Cortex-A76 @ 2.4GHz
- **GPU:** Broadcom VideoCore VII (OpenGL ES 3.1 / Vulkan 1.2)
- **RAM:** 16GB LPDDR4X-4267 SDRAM (unofficial/custom board)
- **Storage:** 64Gb MicroSD + PCIe 2.0 (via FFC connector), USB 3.0 SSDs
- **Networking:**
  - Gigabit Ethernet (real, not USB-attached)
  - Wi-Fi 802.11ac dual-band
  - Bluetooth 5.0

## I/O

- 2 × USB 3.0
- 2 × USB 2.0
- 2 × Micro HDMI ports (up to 4Kp60)
- PCIe Gen 2 single-lane connector (via FFC)
- GPIO: 40-pin standard header (backward compatible)
- CSI/DSI camera/display ports (MIPI)

## Power

- USB-C PD (Power Delivery) input
- Typical draw: ~3A @ 5V under full load
- Active cooling

## Software

- **OS Support:**
  - Raspberry Pi OS Lite / Desktop (Bookworm)
  - Ubuntu Server 22.04+
  - Debian ARM64
- **Kernel:** Linux 6.1+
- **Bootloader:** UEFI support + standard EEPROM configuration
- **Extras:**
  - Works with VS Code (Remote SSH)
  - Supports Git, Python, PostgreSQL, MetaData, Grafana, dbt, Dagster, Prometheus, Node_Exporter, MkDocs, and Nginx

## Notes

- Common among compute-focused lab boards or modified CM5 variants.
- Suitable for low-footprint AI, data engineering demos, or running full observability stacks.