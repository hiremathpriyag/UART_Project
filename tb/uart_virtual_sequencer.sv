class uart_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

`uvm_component_utils(uart_virtual_sequencer)

uart_sequencer seqrh[];

uart_env_config e_cfg;


extern function new(string name="uart_virtual_sequencer",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass


function uart_virtual_sequencer::new(string name="uart_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction


function void uart_virtual_sequencer::build_phase(uvm_phase phase);
	if(!uvm_config_db #(uart_env_config)::get(this,"","uart_env_config",e_cfg))
	`uvm_fatal("V_SEQR","Cannot get the e_cfg from the uvm_config_db")
	
	super.build_phase(phase);
	
	seqrh=new[e_cfg.no_of_agents];
endfunction

