class uart_base_test extends uvm_test;

`uvm_component_utils(uart_base_test)

uart_env envh;
uart_env_config e_cfg;

uart_agent_config m_cfg[];


bit has_agtop=1;
int no_of_agents=2;


extern function new(string name="uart_base_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void config_uart();
endclass

//new constructor
function uart_base_test::new(string name="uart_base_test",uvm_component parent);
	super.new(name,parent);
endfunction

//build_phase
function void uart_base_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
		
	e_cfg=uart_env_config::type_id::create("e_cfg");

	if(has_agtop)
		e_cfg.agt_cfg=new[no_of_agents];
		
	
	config_uart();

	uvm_config_db #(uart_env_config)::set(this,"*","uart_env_config",e_cfg);

	envh=uart_env::type_id::create("envh",this);
endfunction


function void uart_base_test::config_uart();
	if(has_agtop)
	   begin
		m_cfg=new[no_of_agents];		
		foreach(m_cfg[i])
			begin
			m_cfg[i]=uart_agent_config::type_id::create($sformatf("m_cfg[%0d]",i));	

			if(!uvm_config_db #(virtual uart_if)::get(this,"",$sformatf("vif_%0d",i),m_cfg[i].vif))
			`uvm_fatal("TEST","cannot get the virtual interface vif to wr_cfg ")
	
			m_cfg[i].is_active=UVM_ACTIVE;
	
			e_cfg.agt_cfg[i]=m_cfg[i];
    			end
	   end

	
	e_cfg.has_agtop=has_agtop;
	e_cfg.no_of_agents=no_of_agents;

endfunction			


			//////////////////////////////////// FULL_DUPLEX TESTCASE "uart_test_1" ////////////////////////////////////

class uart_test_1 extends uart_base_test;

`uvm_component_utils(uart_test_1)


uart_fd_vseq seq;

extern function new(string name = "uart_test_1" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass
	

function uart_test_1::new(string name = "uart_test_1" , uvm_component parent);
	super.new(name,parent);
endfunction


function void uart_test_1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


 task uart_test_1::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq=uart_fd_vseq::type_id::create("seq");
	seq.start(envh.v_sequencer);
	#3000000;
	phase.drop_objection(this);
endtask   


			//////////////////////////////////// HALF_DUPLEX TESTCASE "uart_test_2" ////////////////////////////////////


class uart_test_2 extends uart_base_test; 

`uvm_component_utils(uart_test_2)


uart_hd_vseq seq;

extern function new(string name = "uart_test_2" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass
	

function uart_test_2::new(string name = "uart_test_2" , uvm_component parent);
	super.new(name,parent);
endfunction


function void uart_test_2::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


task uart_test_2::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq=uart_hd_vseq::type_id::create("seq");
	seq.start(envh.v_sequencer);
	#3000000;
	phase.drop_objection(this);
endtask 



			//////////////////////////////////// PARITY_ERROR TESTCASE "uart_test_3" ////////////////////////////////////


class uart_test_3 extends uart_base_test; 

`uvm_component_utils(uart_test_3)


uart_parityERR_vseq seq;

extern function new(string name = "uart_test_3" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass
	

function uart_test_3::new(string name = "uart_test_3" , uvm_component parent);
	super.new(name,parent);
endfunction


function void uart_test_3::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


task uart_test_3::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq=uart_parityERR_vseq::type_id::create("seq");
	seq.start(envh.v_sequencer);
	#3000000;
	phase.drop_objection(this);
endtask   




			//////////////////////////////////// OVER_RUN TESTCASE "uart_test_4" ////////////////////////////////////


class uart_test_4 extends uart_base_test; 

`uvm_component_utils(uart_test_4)


uart_overrun_vseq seq;

extern function new(string name = "uart_test_4" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass
	

function uart_test_4::new(string name = "uart_test_4" , uvm_component parent);
	super.new(name,parent);
endfunction


function void uart_test_4::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


task uart_test_4::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq=uart_overrun_vseq::type_id::create("seq");
	seq.start(envh.v_sequencer);
	#3000000;
	phase.drop_objection(this);
endtask  






			//////////////////////////////////// FRAMING ERROR TESTCASE "uart_test_5" ////////////////////////////////////


class uart_test_5 extends uart_base_test; 

`uvm_component_utils(uart_test_5)


uart_framing_vseq seq;

extern function new(string name = "uart_test_5" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass
	

function uart_test_5::new(string name = "uart_test_5" , uvm_component parent);
	super.new(name,parent);
endfunction


function void uart_test_5::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


task uart_test_5::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq=uart_framing_vseq::type_id::create("seq");
	seq.start(envh.v_sequencer);
	#3000000;
	phase.drop_objection(this);
endtask  





//////////////////////////////////// BREAK INTERRUPT TESTCASE "uart_test_6" ////////////////////////////////////


class uart_test_6 extends uart_base_test; 

`uvm_component_utils(uart_test_6)


uart_break_vseq seq;

extern function new(string name = "uart_test_6" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass
	

function uart_test_6::new(string name = "uart_test_6" , uvm_component parent);
	super.new(name,parent);
endfunction


function void uart_test_6::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


task uart_test_6::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq=uart_break_vseq::type_id::create("seq");
	seq.start(envh.v_sequencer);
	#3000000;
	phase.drop_objection(this);
endtask  



			/////////////////////////////////////// THR EMPTY TESTCASE "uart_test_7"///////////////////////////////////////

class uart_test_7 extends uart_base_test;

`uvm_component_utils(uart_test_7)

uart_thr_empty_vseq seq;

extern function new(string name = "uart_test_7",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function uart_test_7::new(string name ="uart_test_7",uvm_component parent);
	super.new(name,parent);
endfunction

function void uart_test_7::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task uart_test_7::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq=uart_thr_empty_vseq::type_id::create("seq");
	seq.start(envh.v_sequencer);
	#30000;
	phase.drop_objection(this);
endtask




			/////////////////////////////////////// THR EMPTY TESTCASE "uart_test_7"///////////////////////////////////////

class uart_test_8 extends uart_base_test;

`uvm_component_utils(uart_test_8)

uart_loop_back seq;

extern function new(string name = "uart_test_8",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function uart_test_8::new(string name ="uart_test_8",uvm_component parent);
	super.new(name,parent);
endfunction

function void uart_test_8::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task uart_test_8::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq=uart_loop_back::type_id::create("seq");
	seq.start(envh.v_sequencer);
	#30000;
	phase.drop_objection(this);
endtask

