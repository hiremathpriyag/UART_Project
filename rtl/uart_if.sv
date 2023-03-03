interface uart_if(input bit clk);

//bit clk;
logic       wb_rst_i;
logic [2:0] wb_addr_i;
logic [3:0] wb_sel_i;
logic [7:0] wb_dat_i;
logic [7:0] wb_dat_o;
bit wb_we_i;
bit wb_stb_i;
bit wb_cyc_i;
bit wb_ack_o;
bit baud_o;
bit int_o;


clocking drv_cb@(posedge clk);
	default input #1 output #1;
output wb_rst_i;
output wb_addr_i;
output wb_sel_i;
output wb_dat_i;   
output wb_we_i;
output wb_stb_i;
output wb_cyc_i;
input wb_dat_o;
input wb_ack_o;
input baud_o;
input int_o;
endclocking

clocking mon_cb@(posedge clk);
	default input #1 output #1;
input wb_rst_i;
input wb_addr_i;
input wb_sel_i;
input wb_dat_i;
input wb_we_i;
input wb_stb_i;
input wb_cyc_i;
input wb_dat_o;
input wb_ack_o;
input baud_o;
input int_o;
endclocking


modport DRV(clocking drv_cb);
modport MON(clocking mon_cb);

endinterface
