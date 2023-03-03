class uart_env_config extends uvm_object;

`uvm_object_utils(uart_env_config)

bit has_scoreboard=1;
bit has_functional_coverage=1;
bit has_agtop=1;
int no_of_agents=2;
bit has_virtual_sequencer=1;

uart_agent_config agt_cfg[];



extern function new(string name="uart_env_config");
endclass


function uart_env_config::new(string name="uart_env_config");
	super.new(name);
endfunction

