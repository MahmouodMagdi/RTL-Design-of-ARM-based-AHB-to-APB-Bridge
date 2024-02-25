# Design-of-ARM-based-AHB-to-APB-Bridge

## Abstract
The Advanced Microcontroller Bus Architecture (AMBA) is an open System-on-Chip bus protocol for high performance buses to communicate with low-power devices. In the AMBA High-performance Bus (AHB) a system bus is used to connect a processor, a DSP, and high-performance memory controllers where as the AMBA Advanced Peripheral Bus (APB) is used to connect (Universal Asynchronous Receiver Transmitter) UART. It also contains a Bridge, which connects the AHB and APB buses. Bridges are standard bus-to-bus interfaces that allow IPs connected to different buses to communicate with each other in a standardized way.



## 1. AMBA (Advanced Microcontroller Bus Architecture) :

![image](https://github.com/MahmouodMagdi/RTL-Design-of-ARM-based-AHB-to-APB-Bridge/assets/72949261/e4826773-1bf6-465e-8d44-9aaf1e4b9b20)

AMBA is a freely-available, open standard for the connection and management of functional blocks in a system-on-chip (SoC). It facilitates right-first-time development of multi-processor designs, with large numbers of controllers and peripherals. AMBA specifications are royalty-free, platform-independent and can be used with any processor architecture. Due to its widespread adoption, AMBA has a robust ecosystem of partners that ensures compatibility and scalability between IP components from different design teams and vendors.



## 2. AHB (AMBA High-performance Bus) :

AMBA AHB is a bus interface suitable for high-performance synthesizable designs. It defines the interface between components, such as masters, interconnects, and slaves.
AMBA AHB implements the features required for high-performance, high clock frequency systems including:
  • Burst transfers.
  • Single clock-edge operation.
  • Non-tristate implementation.
  • Wide data bus configurations, 64, 128, 256, 512, and 1024 bits.
  
The most common AHB slaves are internal memory devices, external memory interfaces, and high-bandwidth peripherals. Although low-bandwidth peripherals can be included as AHB slaves, for system performance reasons, they typically reside on the AMBA Advanced Peripheral Bus (APB). Bridging between the higher performance AHB and APB is done using an AHB slave, known as an APB bridge.
