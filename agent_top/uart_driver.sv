class uart_driver extends uvm_driver #(uart_xtn);

`uvm_component_utils(uart_driver)

virtual uart_if.DRV vif;

uart_agent_config m_cfg;

extern function new(string name="uart_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(uart_xtn xtn);
extern function void report_phase(uvm_phase phase);
endclass


function uart_driver:: new(string name="uart_driver",uvm_component parent);
	super.new(name,parent);
endfunction


function void uart_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(uart_agent_config)::get(this,"","uart_agent_config",m_cfg))
	`uvm_fatal("WR_DRV","Cannot get the config db of m_cfg")
endfunction


function void uart_driver::connect_phase(uvm_phase phase);
	vif=m_cfg.vif;
endfunction


task uart_driver::run_phase(uvm_phase phase);

	@(vif.drv_cb);
	 	vif.drv_cb.wb_rst_i<=1'b1;
	@(vif.drv_cb);
	@(vif.drv_cb);
		vif.drv_cb.wb_rst_i<=1'b0;	
	
	
	forever 
		begin
		     seq_item_port.get_next_item(req);
		     send_to_dut(req);
		     seq_item_port.item_done();
		end
endtask


task uart_driver::send_to_dut(uart_xtn xtn);

	`uvm_info("DRV",$sformatf("printing from Driver %s",xtn.sprint()),UVM_LOW)

	@(vif.drv_cb);
 	vif.drv_cb.wb_dat_i<=xtn.data_i;
 	vif.drv_cb.wb_addr_i<=xtn.addr_i;
 	vif.drv_cb.wb_we_i<=xtn.we_i;

 	vif.drv_cb.wb_sel_i<=4'b0001;
 	vif.drv_cb.wb_stb_i<=1'b1;
 	vif.drv_cb.wb_cyc_i<=1'b1;
	

wait(vif.drv_cb.wb_ack_o)
	vif.drv_cb.wb_stb_i<=1'b0;
 	vif.drv_cb.wb_cyc_i<=1'b0;

	@(vif.drv_cb);

if(xtn.addr_i==3'd2 && xtn.we_i==0)
  begin
	 wait(vif.drv_cb.int_o)
	@(vif.drv_cb);
		xtn.iir=vif.drv_cb.wb_dat_o; 
		seq_item_port.put_response(req);
		$display("Put Response IIR: %b",xtn.iir);
		
  end
	
	m_cfg.drv_data_sent_cnt++;

endtask	


function void uart_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(),$sformatf("REPORT: Driver sent %0d transaction",m_cfg.drv_data_sent_cnt),UVM_LOW)
endfunction	
