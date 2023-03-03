class uart_agent_top extends uvm_env;

`uvm_component_utils(uart_agent_top)

uart_agent agnth[];

uart_env_config e_cfg;

extern function new(string name="uart_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

//new constructor
function uart_agent_top::new(string name="uart_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

//build_phase
function void uart_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(uart_env_config)::get(this,"","uart_env_config",e_cfg))
	`uvm_fatal("AGT TOP","cannot get the e_cfg from uart_env_config DB")
	
	if(e_cfg.has_agtop)
	agnth=new[e_cfg.no_of_agents];
	foreach(agnth[i])
	begin
		uvm_config_db #(uart_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"uart_agent_config",e_cfg.agt_cfg[i]);
		agnth[i]=uart_agent::type_id::create($sformatf("agnth[%0d]",i),this);
	end

endfunction

task uart_agent_top::run_phase(uvm_phase phase);
	uvm_top.print_topology();
endtask
