class uart_xtn extends uvm_sequence_item;

`uvm_object_utils(uart_xtn)

rand bit [7:0]data_i;
rand bit [2:0]addr_i;
rand bit we_i;
bit ack_o;
bit [7:0]data_o;

int rx_buf[$];
int thr[$];
bit [7:0]ier;
bit [7:0]iir;
bit [7:0]fcr;
bit [7:0]lcr;
bit [7:0]lsr;
bit [7:0]dl_msb;
bit [7:0]dl_lsb;

extern function new(string name="uart_xtn");
extern function void do_print(uvm_printer printer);
endclass


function uart_xtn::new(string name="uart_xtn");
	super.new(name);
endfunction 


function void uart_xtn::do_print(uvm_printer printer);
	super.do_print(printer);

		printer.print_field("Data_in",		this.data_i,	8,UVM_DEC);
		printer.print_field("Address_in",	this.addr_i,	3,UVM_DEC);
		printer.print_field("Write_enb",	this.we_i,	1,UVM_BIN);
		printer.print_field("ACK",		this.ack_o,	1,UVM_BIN);
		printer.print_field("Data_out",		this.data_o,	8,UVM_BIN);
				
		foreach(rx_buf[i])
		printer.print_field($sformatf("RX_BUFF [%0d]",i),		this.rx_buf[i],	8,UVM_DEC);


		foreach(thr[i])
		printer.print_field($sformatf("THR [%0d]",i),		this.thr[i],	8,UVM_DEC);


		printer.print_field("IER",		this.ier,	8,UVM_BIN);
		printer.print_field("IIR",		this.iir,	8,UVM_BIN);
		printer.print_field("FCR",		this.fcr,	8,UVM_BIN);
		printer.print_field("LCR",		this.lcr,	8,UVM_BIN);
		printer.print_field("LSR",		this.lsr,	8,UVM_BIN);
		printer.print_field("DL_MSB",		this.dl_msb,	8,UVM_BIN);
		printer.print_field("DL_LSB",		this.dl_lsb,	8,UVM_BIN);
endfunction
