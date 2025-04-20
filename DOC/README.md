# CPU2
A synchronous digital system that implements a dynamically growing N-modulo counter where N increases dynamically each counting round until it reaches the UpperBound value. It uses behavioural model design technics and implements two synchronous units and one logic unit to implement this architecture. 
The fast counter and the slow counter are two sequential units withe the logical unit being a control combinational logic unit.

There are two VHDL files in the project:

1. top.vhd: Main file containing the counter architecture.

2. aux_package.vhd: Package file that declares the top component for easier use in other modules or testbenches.

top.vhd
Entity: top
Generic:

n: Bit width of the counters (default: 8)

Inputs:

clk_i: Clock input

rst_i: Asynchronous reset input

repeat_i: If high, the counter repeats after finishing

upperBound_i: The maximum value the slow counter will reach

Outputs:

count_o: Output of the fast counter

busy_o: High when counting is active, low when done

Functionality
The fast counter counts from 0 to the value of the slow counter (control_r).

When the fast counter reaches control_r, it resets and notifies the slow counter to increment.

The slow counter increments until it reaches upperBound_i.

If repeat_i is '1', the counters reset and start again.

When repeat_i is '0', the system halts once the slow counter reaches upperBound_i and the current fast count completes.

aux_package.vhd
Defines the top component so it can be used in other VHDL files.