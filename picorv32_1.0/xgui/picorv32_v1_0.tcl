# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Group
  set Addresses [ipgui::add_group $IPINST -name "Addresses" -layout horizontal]
  set PROGADDR_RESET [ipgui::add_param $IPINST -name "PROGADDR_RESET" -parent ${Addresses}]
  set_property tooltip {The start address of the program.} ${PROGADDR_RESET}
  set STACKADDR [ipgui::add_param $IPINST -name "STACKADDR" -parent ${Addresses}]
  set_property tooltip {When this parameter has a value different from 0xffffffff, then register x2 (the stack pointer) is initialized to this value on reset. (All other registers remain uninitialized.) Note that the RISC-V calling convention requires the stack pointer to be aligned on 16 bytes boundaries (4 bytes for the RV32I soft float calling convention).} ${STACKADDR}

  #Adding Group
  set Timer [ipgui::add_group $IPINST -name "Timer" -display_name {Counters} -layout horizontal]
  set_property tooltip {Counters} ${Timer}
  set ENABLE_COUNTERS [ipgui::add_param $IPINST -name "ENABLE_COUNTERS" -parent ${Timer}]
  set_property tooltip {Enables support for the RDCYCLE[H], RDTIME[H], and RDINSTRET[H] instructions. This instructions will cause a hardware trap (like any other unsupported instruction) if ENABLE_COUNTERS is set to zero.} ${ENABLE_COUNTERS}
  set ENABLE_COUNTERS64 [ipgui::add_param $IPINST -name "ENABLE_COUNTERS64" -parent ${Timer}]
  set_property tooltip {Enables support for the RDCYCLEH, RDTIMEH, and RDINSTRETH instructions. If this parameter is set to 0, and ENABLE_COUNTERS is set to 1, then only the RDCYCLE, RDTIME, and RDINSTRET instructions are available.} ${ENABLE_COUNTERS64}

  #Adding Group
  set Basic [ipgui::add_group $IPINST -name "Basic" -display_name {Performance}]
  set_property tooltip {These settings affect the performance and maximum clock frequency of the core.} ${Basic}
  set ENABLE_REGS_16_31 [ipgui::add_param $IPINST -name "ENABLE_REGS_16_31" -parent ${Basic}]
  set_property tooltip {Enables support for registers the x16..x31. The RV32E ISA excludes this registers. However, the RV32E ISA spec requires a hardware trap for when code tries to access this registers. This is not implemented in PicoRV32.} ${ENABLE_REGS_16_31}
  set TWO_CYCLE_ALU [ipgui::add_param $IPINST -name "TWO_CYCLE_ALU" -parent ${Basic}]
  set_property tooltip {This adds an additional FF stage in the ALU data path, improving timing at the cost of an additional clock cycle for all instructions that use the ALU.  Note: Enabling this parameter will be most effective when retiming (aka "register balancing") is enabled in the synthesis flow.} ${TWO_CYCLE_ALU}
  set TWO_CYCLE_COMPARE [ipgui::add_param $IPINST -name "TWO_CYCLE_COMPARE" -parent ${Basic}]
  set_property tooltip {This relaxes the longest data path a bit by adding an additional FF stage at the cost of adding an additional clock cycle delay to the conditional branch instructions.  Note: Enabling this parameter will be most effective when retiming (aka "register balancing") is enabled in the synthesis flow.} ${TWO_CYCLE_COMPARE}
  set BARREL_SHIFTER [ipgui::add_param $IPINST -name "BARREL_SHIFTER" -parent ${Basic}]
  set_property tooltip {By default shift operations are performed by successively shifting by a small amount (see Two Stage Shift above). With this option set, a barrel shifter is used instead.} ${BARREL_SHIFTER}
  set TWO_STAGE_SHIFT [ipgui::add_param $IPINST -name "TWO_STAGE_SHIFT" -parent ${Basic}]
  set_property tooltip {By default shift operations are performed in two stages: first shifts in units of 4 bits and then shifts in units of 1 bit. This speeds up shift operations, but adds additional hardware. Set this parameter to 0 to disable the two-stage shift to further reduce the size of the core.} ${TWO_STAGE_SHIFT}
  set ENABLE_REGS_DUALPORT [ipgui::add_param $IPINST -name "ENABLE_REGS_DUALPORT" -parent ${Basic}]
  set_property tooltip {The register file can be implemented with two or one read ports. A dual ported register file improves performance a bit, but can also increase the size of the core.} ${ENABLE_REGS_DUALPORT}
  set COMPRESSED_ISA [ipgui::add_param $IPINST -name "COMPRESSED_ISA" -parent ${Basic}]
  set_property tooltip {This enables support for the RISC-V Compressed Instruction Set.} ${COMPRESSED_ISA}

  #Adding Group
  set Error_Trapping [ipgui::add_group $IPINST -name "Error Trapping" -layout horizontal]
  set_property tooltip {Enables trapping when an error occurs.} ${Error_Trapping}
  set CATCH_MISALIGN [ipgui::add_param $IPINST -name "CATCH_MISALIGN" -parent ${Error_Trapping}]
  set_property tooltip {Deselect this to disable the circuitry for catching misaligned memory accesses.} ${CATCH_MISALIGN}
  set CATCH_ILLINSN [ipgui::add_param $IPINST -name "CATCH_ILLINSN" -parent ${Error_Trapping}]
  set_property tooltip {Disable this to disable the circuitry for catching illegal instructions. The core will still trap on EBREAK instructions with this option disabled. With IRQs enabled, an EBREAK normally triggers an IRQ 1. With this option disabled, an EBREAK will trap the processor without triggering an interrupt.} ${CATCH_ILLINSN}

  #Adding Group
  set PCPI_Interface [ipgui::add_group $IPINST -name "PCPI Interface"]
  set_property tooltip {These settings are related to the optional PicoRV Co-Processor Interface.} ${PCPI_Interface}
  set ENABLE_PCPI [ipgui::add_param $IPINST -name "ENABLE_PCPI" -parent ${PCPI_Interface}]
  set_property tooltip {Select this to enable the Pico Co-Processor Interface (PCPI).} ${ENABLE_PCPI}
  set ENABLE_MUL [ipgui::add_param $IPINST -name "ENABLE_MUL" -parent ${PCPI_Interface}]
  set_property tooltip {This parameter internally enables PCPI and instantiates the picorv32_pcpi_mul core that implements the MUL[H[SU|U]] instructions. The external PCPI interface only becomes functional when Enable PCPI is set as well.} ${ENABLE_MUL}
  set ENABLE_FAST_MUL [ipgui::add_param $IPINST -name "ENABLE_FAST_MUL" -parent ${PCPI_Interface}]
  set_property tooltip {This parameter internally enables PCPI and instantiates the picorv32_pcpi_fast_mul core that implements the MUL[H[SU|U]] instructions. The external PCPI interface only becomes functional when Enable PCPI is set as well. If both Enable Multiplier and Enable Fast Multiplier are set then the Enable Multiplier setting will be ignored and the fast multiplier core will be instantiated.} ${ENABLE_FAST_MUL}
  set ENABLE_DIV [ipgui::add_param $IPINST -name "ENABLE_DIV" -parent ${PCPI_Interface}]
  set_property tooltip {This parameter internally enables PCPI and instantiates the picorv32_pcpi_div core that implements the DIV[U]/REM[U] instructions. The external PCPI interface only becomes functional when Enable PCPI is set as well.} ${ENABLE_DIV}

  #Adding Group
  set IRQ [ipgui::add_group $IPINST -name "IRQ"]
  set ENABLE_IRQ [ipgui::add_param $IPINST -name "ENABLE_IRQ" -parent ${IRQ}]
  set_property tooltip {Select this to enable IRQs.} ${ENABLE_IRQ}
  set ENABLE_IRQ_QREGS [ipgui::add_param $IPINST -name "ENABLE_IRQ_QREGS" -parent ${IRQ}]
  set_property tooltip {Deselect this to disable support for the getq and setq instructions. Without the q-registers, the irq return address will be stored in x3 (gp) and the IRQ bitmask in x4 (tp), the global pointer and thread pointer registers according to the RISC-V ABI. Code generated from ordinary C code will not interact with those registers. Support for q-registers is always disabled when Enable IRQ is set to 0.} ${ENABLE_IRQ_QREGS}
  set ENABLE_IRQ_TIMER [ipgui::add_param $IPINST -name "ENABLE_IRQ_TIMER" -parent ${IRQ}]
  set_property tooltip {Deselect this to disable support for the timer instruction. Support for the timer is always disabled when Enable IRQ is set to 0.} ${ENABLE_IRQ_TIMER}
  set PROGADDR_IRQ [ipgui::add_param $IPINST -name "PROGADDR_IRQ" -parent ${IRQ}]
  set_property tooltip {The start address of the interrupt handler.} ${PROGADDR_IRQ}
  set MASKED_IRQ [ipgui::add_param $IPINST -name "MASKED_IRQ" -parent ${IRQ}]
  set_property tooltip {A 1 bit in this bitmask corresponds to a permanently disabled IRQ.} ${MASKED_IRQ}
  set LATCHED_IRQ [ipgui::add_param $IPINST -name "LATCHED_IRQ" -parent ${IRQ}]
  set_property tooltip {A 1 bit in this bitmask indicates that the corresponding IRQ is "latched", i.e. when the IRQ line is high for only one cycle, the interrupt will be marked as pending and stay pending until the interrupt handler is called (aka "pulse interrupts" or "edge-triggered interrupts"). Set a bit in this bitmask to 0 to convert an interrupt line to operate as "level sensitive" interrupt.} ${LATCHED_IRQ}

  #Adding Group
  set Debugging [ipgui::add_group $IPINST -name "Debugging" -layout horizontal]
  set ENABLE_TRACE [ipgui::add_param $IPINST -name "ENABLE_TRACE" -parent ${Debugging}]
  set_property tooltip {Produce an execution trace using the trace_valid and trace_data output ports.} ${ENABLE_TRACE}
  set REGS_INIT_ZERO [ipgui::add_param $IPINST -name "REGS_INIT_ZERO" -parent ${Debugging}]
  set_property tooltip {Select this to initialize all registers to zero (using a Verilog initial block). This can be useful for simulation or formal verification.} ${REGS_INIT_ZERO}


}

proc update_PARAM_VALUE.BARREL_SHIFTER { PARAM_VALUE.BARREL_SHIFTER } {
	# Procedure called to update BARREL_SHIFTER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BARREL_SHIFTER { PARAM_VALUE.BARREL_SHIFTER } {
	# Procedure called to validate BARREL_SHIFTER
	return true
}

proc update_PARAM_VALUE.CATCH_ILLINSN { PARAM_VALUE.CATCH_ILLINSN } {
	# Procedure called to update CATCH_ILLINSN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CATCH_ILLINSN { PARAM_VALUE.CATCH_ILLINSN } {
	# Procedure called to validate CATCH_ILLINSN
	return true
}

proc update_PARAM_VALUE.CATCH_MISALIGN { PARAM_VALUE.CATCH_MISALIGN } {
	# Procedure called to update CATCH_MISALIGN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CATCH_MISALIGN { PARAM_VALUE.CATCH_MISALIGN } {
	# Procedure called to validate CATCH_MISALIGN
	return true
}

proc update_PARAM_VALUE.COMPRESSED_ISA { PARAM_VALUE.COMPRESSED_ISA } {
	# Procedure called to update COMPRESSED_ISA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COMPRESSED_ISA { PARAM_VALUE.COMPRESSED_ISA } {
	# Procedure called to validate COMPRESSED_ISA
	return true
}

proc update_PARAM_VALUE.ENABLE_COUNTERS { PARAM_VALUE.ENABLE_COUNTERS } {
	# Procedure called to update ENABLE_COUNTERS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_COUNTERS { PARAM_VALUE.ENABLE_COUNTERS } {
	# Procedure called to validate ENABLE_COUNTERS
	return true
}

proc update_PARAM_VALUE.ENABLE_COUNTERS64 { PARAM_VALUE.ENABLE_COUNTERS64 } {
	# Procedure called to update ENABLE_COUNTERS64 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_COUNTERS64 { PARAM_VALUE.ENABLE_COUNTERS64 } {
	# Procedure called to validate ENABLE_COUNTERS64
	return true
}

proc update_PARAM_VALUE.ENABLE_DIV { PARAM_VALUE.ENABLE_DIV } {
	# Procedure called to update ENABLE_DIV when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_DIV { PARAM_VALUE.ENABLE_DIV } {
	# Procedure called to validate ENABLE_DIV
	return true
}

proc update_PARAM_VALUE.ENABLE_FAST_MUL { PARAM_VALUE.ENABLE_FAST_MUL } {
	# Procedure called to update ENABLE_FAST_MUL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_FAST_MUL { PARAM_VALUE.ENABLE_FAST_MUL } {
	# Procedure called to validate ENABLE_FAST_MUL
	return true
}

proc update_PARAM_VALUE.ENABLE_IRQ { PARAM_VALUE.ENABLE_IRQ } {
	# Procedure called to update ENABLE_IRQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_IRQ { PARAM_VALUE.ENABLE_IRQ } {
	# Procedure called to validate ENABLE_IRQ
	return true
}

proc update_PARAM_VALUE.ENABLE_IRQ_QREGS { PARAM_VALUE.ENABLE_IRQ_QREGS } {
	# Procedure called to update ENABLE_IRQ_QREGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_IRQ_QREGS { PARAM_VALUE.ENABLE_IRQ_QREGS } {
	# Procedure called to validate ENABLE_IRQ_QREGS
	return true
}

proc update_PARAM_VALUE.ENABLE_IRQ_TIMER { PARAM_VALUE.ENABLE_IRQ_TIMER } {
	# Procedure called to update ENABLE_IRQ_TIMER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_IRQ_TIMER { PARAM_VALUE.ENABLE_IRQ_TIMER } {
	# Procedure called to validate ENABLE_IRQ_TIMER
	return true
}

proc update_PARAM_VALUE.ENABLE_MUL { PARAM_VALUE.ENABLE_MUL } {
	# Procedure called to update ENABLE_MUL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_MUL { PARAM_VALUE.ENABLE_MUL } {
	# Procedure called to validate ENABLE_MUL
	return true
}

proc update_PARAM_VALUE.ENABLE_PCPI { PARAM_VALUE.ENABLE_PCPI } {
	# Procedure called to update ENABLE_PCPI when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_PCPI { PARAM_VALUE.ENABLE_PCPI } {
	# Procedure called to validate ENABLE_PCPI
	return true
}

proc update_PARAM_VALUE.ENABLE_REGS_16_31 { PARAM_VALUE.ENABLE_REGS_16_31 } {
	# Procedure called to update ENABLE_REGS_16_31 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_REGS_16_31 { PARAM_VALUE.ENABLE_REGS_16_31 } {
	# Procedure called to validate ENABLE_REGS_16_31
	return true
}

proc update_PARAM_VALUE.ENABLE_REGS_DUALPORT { PARAM_VALUE.ENABLE_REGS_DUALPORT } {
	# Procedure called to update ENABLE_REGS_DUALPORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_REGS_DUALPORT { PARAM_VALUE.ENABLE_REGS_DUALPORT } {
	# Procedure called to validate ENABLE_REGS_DUALPORT
	return true
}

proc update_PARAM_VALUE.ENABLE_TRACE { PARAM_VALUE.ENABLE_TRACE } {
	# Procedure called to update ENABLE_TRACE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_TRACE { PARAM_VALUE.ENABLE_TRACE } {
	# Procedure called to validate ENABLE_TRACE
	return true
}

proc update_PARAM_VALUE.LATCHED_IRQ { PARAM_VALUE.LATCHED_IRQ } {
	# Procedure called to update LATCHED_IRQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LATCHED_IRQ { PARAM_VALUE.LATCHED_IRQ } {
	# Procedure called to validate LATCHED_IRQ
	return true
}

proc update_PARAM_VALUE.MASKED_IRQ { PARAM_VALUE.MASKED_IRQ } {
	# Procedure called to update MASKED_IRQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MASKED_IRQ { PARAM_VALUE.MASKED_IRQ } {
	# Procedure called to validate MASKED_IRQ
	return true
}

proc update_PARAM_VALUE.PROGADDR_IRQ { PARAM_VALUE.PROGADDR_IRQ } {
	# Procedure called to update PROGADDR_IRQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PROGADDR_IRQ { PARAM_VALUE.PROGADDR_IRQ } {
	# Procedure called to validate PROGADDR_IRQ
	return true
}

proc update_PARAM_VALUE.PROGADDR_RESET { PARAM_VALUE.PROGADDR_RESET } {
	# Procedure called to update PROGADDR_RESET when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PROGADDR_RESET { PARAM_VALUE.PROGADDR_RESET } {
	# Procedure called to validate PROGADDR_RESET
	return true
}

proc update_PARAM_VALUE.REGS_INIT_ZERO { PARAM_VALUE.REGS_INIT_ZERO } {
	# Procedure called to update REGS_INIT_ZERO when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REGS_INIT_ZERO { PARAM_VALUE.REGS_INIT_ZERO } {
	# Procedure called to validate REGS_INIT_ZERO
	return true
}

proc update_PARAM_VALUE.STACKADDR { PARAM_VALUE.STACKADDR } {
	# Procedure called to update STACKADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STACKADDR { PARAM_VALUE.STACKADDR } {
	# Procedure called to validate STACKADDR
	return true
}

proc update_PARAM_VALUE.TWO_CYCLE_ALU { PARAM_VALUE.TWO_CYCLE_ALU } {
	# Procedure called to update TWO_CYCLE_ALU when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TWO_CYCLE_ALU { PARAM_VALUE.TWO_CYCLE_ALU } {
	# Procedure called to validate TWO_CYCLE_ALU
	return true
}

proc update_PARAM_VALUE.TWO_CYCLE_COMPARE { PARAM_VALUE.TWO_CYCLE_COMPARE } {
	# Procedure called to update TWO_CYCLE_COMPARE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TWO_CYCLE_COMPARE { PARAM_VALUE.TWO_CYCLE_COMPARE } {
	# Procedure called to validate TWO_CYCLE_COMPARE
	return true
}

proc update_PARAM_VALUE.TWO_STAGE_SHIFT { PARAM_VALUE.TWO_STAGE_SHIFT } {
	# Procedure called to update TWO_STAGE_SHIFT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TWO_STAGE_SHIFT { PARAM_VALUE.TWO_STAGE_SHIFT } {
	# Procedure called to validate TWO_STAGE_SHIFT
	return true
}


proc update_MODELPARAM_VALUE.ENABLE_COUNTERS { MODELPARAM_VALUE.ENABLE_COUNTERS PARAM_VALUE.ENABLE_COUNTERS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_COUNTERS}] ${MODELPARAM_VALUE.ENABLE_COUNTERS}
}

proc update_MODELPARAM_VALUE.ENABLE_COUNTERS64 { MODELPARAM_VALUE.ENABLE_COUNTERS64 PARAM_VALUE.ENABLE_COUNTERS64 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_COUNTERS64}] ${MODELPARAM_VALUE.ENABLE_COUNTERS64}
}

proc update_MODELPARAM_VALUE.ENABLE_REGS_16_31 { MODELPARAM_VALUE.ENABLE_REGS_16_31 PARAM_VALUE.ENABLE_REGS_16_31 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_REGS_16_31}] ${MODELPARAM_VALUE.ENABLE_REGS_16_31}
}

proc update_MODELPARAM_VALUE.ENABLE_REGS_DUALPORT { MODELPARAM_VALUE.ENABLE_REGS_DUALPORT PARAM_VALUE.ENABLE_REGS_DUALPORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_REGS_DUALPORT}] ${MODELPARAM_VALUE.ENABLE_REGS_DUALPORT}
}

proc update_MODELPARAM_VALUE.TWO_STAGE_SHIFT { MODELPARAM_VALUE.TWO_STAGE_SHIFT PARAM_VALUE.TWO_STAGE_SHIFT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TWO_STAGE_SHIFT}] ${MODELPARAM_VALUE.TWO_STAGE_SHIFT}
}

proc update_MODELPARAM_VALUE.BARREL_SHIFTER { MODELPARAM_VALUE.BARREL_SHIFTER PARAM_VALUE.BARREL_SHIFTER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BARREL_SHIFTER}] ${MODELPARAM_VALUE.BARREL_SHIFTER}
}

proc update_MODELPARAM_VALUE.TWO_CYCLE_COMPARE { MODELPARAM_VALUE.TWO_CYCLE_COMPARE PARAM_VALUE.TWO_CYCLE_COMPARE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TWO_CYCLE_COMPARE}] ${MODELPARAM_VALUE.TWO_CYCLE_COMPARE}
}

proc update_MODELPARAM_VALUE.TWO_CYCLE_ALU { MODELPARAM_VALUE.TWO_CYCLE_ALU PARAM_VALUE.TWO_CYCLE_ALU } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TWO_CYCLE_ALU}] ${MODELPARAM_VALUE.TWO_CYCLE_ALU}
}

proc update_MODELPARAM_VALUE.COMPRESSED_ISA { MODELPARAM_VALUE.COMPRESSED_ISA PARAM_VALUE.COMPRESSED_ISA } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COMPRESSED_ISA}] ${MODELPARAM_VALUE.COMPRESSED_ISA}
}

proc update_MODELPARAM_VALUE.CATCH_MISALIGN { MODELPARAM_VALUE.CATCH_MISALIGN PARAM_VALUE.CATCH_MISALIGN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CATCH_MISALIGN}] ${MODELPARAM_VALUE.CATCH_MISALIGN}
}

proc update_MODELPARAM_VALUE.CATCH_ILLINSN { MODELPARAM_VALUE.CATCH_ILLINSN PARAM_VALUE.CATCH_ILLINSN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CATCH_ILLINSN}] ${MODELPARAM_VALUE.CATCH_ILLINSN}
}

proc update_MODELPARAM_VALUE.ENABLE_PCPI { MODELPARAM_VALUE.ENABLE_PCPI PARAM_VALUE.ENABLE_PCPI } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_PCPI}] ${MODELPARAM_VALUE.ENABLE_PCPI}
}

proc update_MODELPARAM_VALUE.ENABLE_MUL { MODELPARAM_VALUE.ENABLE_MUL PARAM_VALUE.ENABLE_MUL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_MUL}] ${MODELPARAM_VALUE.ENABLE_MUL}
}

proc update_MODELPARAM_VALUE.ENABLE_FAST_MUL { MODELPARAM_VALUE.ENABLE_FAST_MUL PARAM_VALUE.ENABLE_FAST_MUL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_FAST_MUL}] ${MODELPARAM_VALUE.ENABLE_FAST_MUL}
}

proc update_MODELPARAM_VALUE.ENABLE_DIV { MODELPARAM_VALUE.ENABLE_DIV PARAM_VALUE.ENABLE_DIV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_DIV}] ${MODELPARAM_VALUE.ENABLE_DIV}
}

proc update_MODELPARAM_VALUE.ENABLE_IRQ { MODELPARAM_VALUE.ENABLE_IRQ PARAM_VALUE.ENABLE_IRQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_IRQ}] ${MODELPARAM_VALUE.ENABLE_IRQ}
}

proc update_MODELPARAM_VALUE.ENABLE_IRQ_QREGS { MODELPARAM_VALUE.ENABLE_IRQ_QREGS PARAM_VALUE.ENABLE_IRQ_QREGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_IRQ_QREGS}] ${MODELPARAM_VALUE.ENABLE_IRQ_QREGS}
}

proc update_MODELPARAM_VALUE.ENABLE_IRQ_TIMER { MODELPARAM_VALUE.ENABLE_IRQ_TIMER PARAM_VALUE.ENABLE_IRQ_TIMER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_IRQ_TIMER}] ${MODELPARAM_VALUE.ENABLE_IRQ_TIMER}
}

proc update_MODELPARAM_VALUE.ENABLE_TRACE { MODELPARAM_VALUE.ENABLE_TRACE PARAM_VALUE.ENABLE_TRACE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_TRACE}] ${MODELPARAM_VALUE.ENABLE_TRACE}
}

proc update_MODELPARAM_VALUE.REGS_INIT_ZERO { MODELPARAM_VALUE.REGS_INIT_ZERO PARAM_VALUE.REGS_INIT_ZERO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REGS_INIT_ZERO}] ${MODELPARAM_VALUE.REGS_INIT_ZERO}
}

proc update_MODELPARAM_VALUE.MASKED_IRQ { MODELPARAM_VALUE.MASKED_IRQ PARAM_VALUE.MASKED_IRQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MASKED_IRQ}] ${MODELPARAM_VALUE.MASKED_IRQ}
}

proc update_MODELPARAM_VALUE.LATCHED_IRQ { MODELPARAM_VALUE.LATCHED_IRQ PARAM_VALUE.LATCHED_IRQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LATCHED_IRQ}] ${MODELPARAM_VALUE.LATCHED_IRQ}
}

proc update_MODELPARAM_VALUE.PROGADDR_RESET { MODELPARAM_VALUE.PROGADDR_RESET PARAM_VALUE.PROGADDR_RESET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PROGADDR_RESET}] ${MODELPARAM_VALUE.PROGADDR_RESET}
}

proc update_MODELPARAM_VALUE.PROGADDR_IRQ { MODELPARAM_VALUE.PROGADDR_IRQ PARAM_VALUE.PROGADDR_IRQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PROGADDR_IRQ}] ${MODELPARAM_VALUE.PROGADDR_IRQ}
}

proc update_MODELPARAM_VALUE.STACKADDR { MODELPARAM_VALUE.STACKADDR PARAM_VALUE.STACKADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STACKADDR}] ${MODELPARAM_VALUE.STACKADDR}
}

