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

![image](https://github.com/MahmouodMagdi/RTL-Design-of-ARM-based-AHB-to-APB-Bridge/assets/72949261/d1650a6e-1afa-408c-a8e9-507cddb409cd)

The figure above shows a single master AHB system design with the AHB master and three AHB slaves. The bus interconnect logic consists of one address decoder and a slave-to-master multiplexor. The decoder monitors the address from the master so that the appropriate slave is selected and the multiplexor routes the corresponding slave output data back to the master. AHB also supports multi-master designs by the use of an interconnect component that provides arbitration and routing signals from different masters to the appropriate slaves.


## 3. APB (Advanced Peripheral Bus) :

The Advanced Peripheral Bus (APB) is part of the Advanced Microcontroller Bus Architecture (AMBA) protocol family. It defines a low-cost interface that is optimized for minimal power consumption and reduced interface complexity.The APB protocol is not pipelined, use it to connect to low-bandwidth peripherals that do not require the high performance of the AXI protocol. The APB protocol relates a signal transition to the rising edge of the clock, to simplify the integration of APB peripherals into any design flow. Every transfer takes at least two cycles.
The APB can interface with:
• AMBA Advanced High-performance Bus (AHB)
• AMBA Advanced High-performance Bus Lite (AHB-Lite)
• AMBA Advanced Extensible Interface (AXI)
• AMBA Advanced Extensible Interface Lite (AXI4-Lite)
You can use it to access the programmable control registers of peripheral devices.
