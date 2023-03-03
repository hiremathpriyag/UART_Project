class uart_scoreboard extends uvm_scoreboard;

`uvm_component_utils(uart_scoreboard)

uvm_tlm_analysis_fifo #(uart_xtn) fifo_0;
uvm_tlm_analysis_fifo #(uart_xtn) fifo_1;

static int uart_xtn_0,uart_xtn_1,xtns_compared,xtns_dropped;


uart_env_config e_cfg;

uart_xtn uart_data_0,uart_data_1;

extern function new(string name="uart_scoreboard",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
//extern function void check_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);
endclass


function uart_scoreboard::new(string name="uart_scoreboard",uvm_component parent);
	super.new(name,parent);
	fifo_0=new("fifo_0",this);
	fifo_1=new("fifo_1",this);
endfunction


function void uart_scoreboard::build_phase(uvm_phase phase);
	uart_data_0=uart_xtn::type_id::create("uart_data_0");
	uart_data_1=uart_xtn::type_id::create("uart_data_1");
endfunction


task uart_scoreboard::run_phase(uvm_phase phase);
fork
    forever
	   begin
		fifo_0.get(uart_data_0);
		uart_xtn_0 ++;
		fifo_1.get(uart_data_1);
		uart_xtn_1 ++;


		`uvm_info("SB",$sformatf("Data from UART_1 to SB:",uart_data_0.sprint()),UVM_LOW)
		
		`uvm_info("SB",$sformatf("Data from UART_2 to SB:",uart_data_1.sprint()),UVM_LOW)

		if(uart_data_0.thr==uart_data_1.rx_buf) 
		   begin 
		     $display("DATA MATCHES");
	             xtns_compared ++;
		   end
		else
		   begin
		    	$display("DATA MIS-MATCH");
			xtns_dropped ++;
		   end



		if(uart_data_1.thr==uart_data_0.rx_buf)
		   begin 
		     $display("DATA MATCHES");
	             xtns_compared ++;
		   end
		else
		   begin
		    	$display("DATA MIS-MATCH");
			xtns_dropped ++;
		   end

		if(uart_data_1.lsr[2]==1'b1 || uart_data_0.lsr[2]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ PARITY ERROR /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end

		if(uart_data_1.lsr[1]==1'b1 || uart_data_0.lsr[1]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ OVER_RUN ERROR /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end


		if(uart_data_1.lsr[3]==1'b1 || uart_data_0.lsr[3]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ FRAMING ERROR /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end
		
		
		if(uart_data_1.lsr[4]==1'b1 || uart_data_0.lsr[4]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ BREAK INTERRUPT /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end

		
		if(uart_data_1.iir[3:1]==3'b110 || uart_data_0.iir[3:1]==3'b110)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ TIME_OUT INDICATION /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end

		if(uart_data_1.iir[3:1]==3'b001 || uart_data_0.iir[3:1]==3'b001)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ TRANSMITTER HOLDING REGISTER EMPTY /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
			$stop;
		end
		
		if(uart_data_1.lsr[5]==1'b1 || uart_data_0.lsr[5]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ TRANSMITTER FIFO EMPTY /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end

		
		if(uart_data_1.lsr[6]==1'b1 || uart_data_0.lsr[6]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ TRANSMITTER FIFO & SHIFT REGISTER EMPTY /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end



	   end
join
endtask

/*
function void uart_scoreboard::check_phase(uvm_phase phase);
//forever
begin
	foreach(uart_data_0.thr[i])
	if(uart_data_0.thr[i]==uart_data_1.rx_buf[i])
//	if(uart_data_1.thr==uart_data_0.rx_buf)

	  begin
	  $display(" THR & RB DATA MATCHES");
		xtns_compared ++;
	  end
	else
	  begin
	  $display("THR & RB DATA MIS-MATCH");
		xtns_dropped ++;
	  end
foreach(uart_data_1.thr[i])
	if(uart_data_1.thr[i]==uart_data_0.rx_buf[i])
	  begin
	  $display(" THR & RB DATA MATCHES");
		xtns_compared ++;
	  end
	else
	  begin
	  $display("THR & RB DATA MIS-MATCH");
		xtns_dropped ++;
	  end
end
endfunction*/


function void uart_scoreboard::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Simulation Report from ScoreBoard \n\t\t\t Number of Transactions from UART_0: %0d \n\t\t\t Number of Write Transactions from UART_1: %0d \n\t\t\t Number of Transactions Dropped: %0d \n\t\t\t Number of Transactions compared: %0d \n\n",uart_xtn_0,uart_xtn_1,xtns_dropped,xtns_compared), UVM_LOW)

endfunction
