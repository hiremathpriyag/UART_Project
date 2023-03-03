class uart_env extends uvm_env;

`uvm_component_utils(uart_env)

uart_agent_top agt_top;
uart_env_config e_cfg;
uart_virtual_sequencer v_sequencer;
uart_scoreboard sb;

extern function new(string name="uart_env",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

//new constructor
function uart_env::new(string name="uart_env",uvm_component parent);
	super.new(name,parent);
endfunction

//build_phase
function void uart_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(uart_env_config)::get(this,"","uart_env_config",e_cfg))
	`uvm_fatal("ENV","cannot get the e_cfg from the uart_env_config DB")
if(e_cfg.has_agtop)
	agt_top=uart_agent_top::type_id::create("agt_top",this);

if(e_cfg.has_virtual_sequencer)
	v_sequencer=uart_virtual_sequencer::type_id::create("v_sequencer",this);

if(e_cfg.has_scoreboard)
	sb=uart_scoreboard::type_id::create("sb",this);
endfunction


function void uart_env::connect_phase(uvm_phase phase);
	if(e_cfg.has_virtual_sequencer)
	begin
	     if(e_cfg.has_agtop)
	     begin
		  foreach(v_sequencer.seqrh[i])
			v_sequencer.seqrh[i]=agt_top.agnth[i].m_sequencer;
	     end
	end

	
	if(e_cfg.has_scoreboard)
	begin
	     if(e_cfg.has_agtop)
	     begin
		  agt_top.agnth[0].monh.mon_port.connect(sb.fifo_0.analysis_export);
		  agt_top.agnth[1].monh.mon_port.connect(sb.fifo_1.analysis_export);
	     end
	end

endfunction
	
