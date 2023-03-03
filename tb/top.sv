module top;

import uart_pkg::*;

import uvm_pkg::*;

wire w1,w2;

bit clock1,clock2;

always #5 clock1=!clock1;

always #10 clock2=!clock2;


	uart_if in0(clock1);
	uart_if in1(clock2);
	

	uart_top UART_1(.wb_clk_i(in0.clk),
			.wb_rst_i(in0.wb_rst_i), 
			.wb_adr_i(in0.wb_addr_i), 
			.wb_dat_i(in0.wb_dat_i), 
			.wb_dat_o(in0.wb_dat_o), 
			.wb_we_i(in0.wb_we_i), 
			.wb_stb_i(in0.wb_stb_i), 
			.wb_cyc_i(in0.wb_cyc_i), 
			.wb_ack_o(in0.wb_ack_o), 
			.wb_sel_i(in0.wb_sel_i), 
			.int_o(in0.int_o),
			.stx_pad_o(w1), 
			.srx_pad_i(w2),
			.baud_o(in0.baud_o));


	uart_top UART_2(.wb_clk_i(in1.clk),
			.wb_rst_i(in1.wb_rst_i), 
			.wb_adr_i(in1.wb_addr_i), 
			.wb_dat_i(in1.wb_dat_i), 
			.wb_dat_o(in1.wb_dat_o), 
			.wb_we_i(in1.wb_we_i), 
			.wb_stb_i(in1.wb_stb_i), 
			.wb_cyc_i(in1.wb_cyc_i), 
			.wb_ack_o(in1.wb_ack_o), 
			.wb_sel_i(in1.wb_sel_i), 
			.int_o(in1.int_o),
			.stx_pad_o(w2), 
			.srx_pad_i(w1),
			.baud_o(in1.baud_o));
initial
   begin
	uvm_config_db #(virtual uart_if)::set(null,"*","vif_0",in0);
	uvm_config_db #(virtual uart_if)::set(null,"*","vif_1",in1);

	
	run_test();
   end 
endmodule



