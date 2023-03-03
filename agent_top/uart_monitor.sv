class uart_monitor extends uvm_monitor;

`uvm_component_utils(uart_monitor)

virtual uart_if.MON vif;

uart_agent_config m_cfg;

uvm_analysis_port #(uart_xtn) mon_port;


extern function new(string name="uart_monitior",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
extern function void report_phase(uvm_phase phase);
endclass

//constructor new 
function uart_monitor::new(string name="uart_monitor",uvm_component parent);
	super.new(name,parent);
	mon_port=new("mon_port",this);
endfunction

//build phase
function void uart_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
		if(!uvm_config_db #(uart_agent_config)::get(this,"","uart_agent_config",m_cfg))
		`uvm_fatal("WR MON","cannot get the m_cfg from uart_agent_config")
endfunction

//connect phase
function void uart_monitor::connect_phase(uvm_phase phase);
	vif=m_cfg.vif;
endfunction


task uart_monitor::run_phase(uvm_phase phase);
forever
	collect_data();
endtask 


task uart_monitor::collect_data();
	
	uart_xtn xtn;
	xtn=uart_xtn::type_id::create("xtn");

		
	xtn.data_i=vif.mon_cb.wb_dat_i;
	xtn.addr_i=vif.mon_cb.wb_addr_i;
	xtn.we_i=vif.mon_cb.wb_we_i;

	
	@(vif.mon_cb);
wait(vif.mon_cb.wb_ack_o)

				//////////////////  LCR   ///////////////////////
	if(vif.mon_cb.wb_addr_i==3'd3 && vif.mon_cb.wb_we_i==1)
		begin
		xtn.lcr=vif.mon_cb.wb_dat_i;
		end
				/////////////////  DL MSB  //////////////////////
	if(xtn.lcr[7]==1 && vif.mon_cb.wb_addr_i==3'd1 && vif.mon_cb.wb_we_i==1)
		begin
		xtn.dl_msb=vif.mon_cb.wb_dat_i;
		end

				/////////////////  DL LSB  //////////////////////
	if(xtn.lcr[7]==1 && vif.mon_cb.wb_addr_i==3'd0 && vif.mon_cb.wb_we_i==1)
		begin
		xtn.dl_lsb=vif.mon_cb.wb_dat_i;
		end

				/////////////////  FCR  //////////////////////
	if(vif.mon_cb.wb_addr_i==3'd2 && vif.mon_cb.wb_we_i==1)
		begin
		xtn.fcr=vif.mon_cb.wb_dat_i;
		end

				///////////////	 IER	///////////////////  
	if(xtn.lcr[7]==0 && vif.mon_cb.wb_addr_i==3'd1 && vif.mon_cb.wb_we_i==1)
		begin
		xtn.ier=vif.mon_cb.wb_dat_i;
		end

				///////////////   IIR	///////////////////  
	if(vif.mon_cb.wb_addr_i==3'd2 && vif.mon_cb.wb_we_i==0)
		begin
		wait(vif.mon_cb.int_o)
		xtn.iir=vif.mon_cb.wb_dat_o;
		end

			///////////////  LSR	///////////////////  
	if(vif.mon_cb.wb_addr_i==3'd5 && vif.mon_cb.wb_we_i==0)
		begin 	
		xtn.lsr=vif.mon_cb.wb_dat_o;
		end

			///////////////   THR	///////////////////  
	if(xtn.lcr[7]==0 && vif.mon_cb.wb_addr_i==3'd0 && vif.mon_cb.wb_we_i==1)
		begin
		xtn.thr.push_back(vif.mon_cb.wb_dat_i);
		end

			///////////////   RB	///////////////////  
	if(xtn.lcr[7]==0 && vif.mon_cb.wb_addr_i==3'd0 && vif.mon_cb.wb_we_i==0)	
		begin
		xtn.rx_buf.push_back(vif.mon_cb.wb_dat_o);
		end
	@(vif.mon_cb);


			
	`uvm_info("MON",$sformatf("printing from Monitor %s",xtn.sprint()),UVM_LOW)

	mon_port.write(xtn);

	m_cfg.mon_rcvd_xtn_cnt ++;

endtask

function void uart_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(),$sformatf("REPORT: Monitor Received %0d transaction",m_cfg.mon_rcvd_xtn_cnt),UVM_LOW)
endfunction
