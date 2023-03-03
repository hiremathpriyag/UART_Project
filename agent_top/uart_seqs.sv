class uart_bseqs extends uvm_sequence #(uart_xtn);

`uvm_object_utils(uart_bseqs)

extern function new(string name="uart_bseqs");
endclass


function uart_bseqs::new(string name="uart_bseqs");
	super.new(name);
endfunction




			//=====================================FULL-DUPLEX MODE==========================================//
class uart_seq1 extends uart_bseqs;

`uvm_object_utils(uart_seq1)

extern function new(string name="uart_seq1");
extern task body();
endclass


function uart_seq1::new(string name="uart_seq1");
	super.new(name);
endfunction


task uart_seq1::body();
	req=uart_xtn::type_id::create("req");
begin
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd3; data_i==8'b1000_0000 ;we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ1 DLAB",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0000 ;we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ1 DL MSB",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd0; data_i==8'd54 ; we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ1 DL LSB",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 ; data_i==8'b0000_0011 ; we_i==1;})//make the LCR 7th bit has '0' for selecting the other registers and 
	`uvm_info("SEQ1 DLAB Disable",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)   //to select the no.of bits in each character
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ1 FCR",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0001 ; we_i==1;})// Select IER and set 0 and 2 bit as'1' to enable RX data available  
	`uvm_info("SEQ1 IER Enable",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)   // RX LS interrrupt 
	finish_item(req);
repeat(30)begin	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ; we_i==1;})	// Select THR and set the data_in=10
	`uvm_info("SEQ1 THR",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})	// Select IIR and enable it  
	`uvm_info("SEQ1 IIR Enable",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("#############################################Printing the IIR from the SEQ1:%b################################################",req.iir);
	
	if(req.iir[3:1]==3'b010)
	repeat(14)	   
	    begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd0 ; we_i==0;})	// Select Rb and read it  
	     	`uvm_info("SEQ1 read Rb",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	    end

	 if(req.iir[3:1]==3'b011)
	    begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Select Rb and read it  
	     	`uvm_info("SEQ1 read Rb",$sformatf("Printing from Seq1 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	    end


	
end
endtask




class uart_seq2 extends uart_bseqs;

`uvm_object_utils(uart_seq2)

extern function new(string name="uart_seq2");
extern task body();
endclass


function uart_seq2::new(string name="uart_seq2");
	super.new(name);
endfunction


task uart_seq2::body();
	req=uart_xtn::type_id::create("req");
begin

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b1000_0000 && we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ2 DLAB",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 && data_i==8'b0000_0000 && we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ2 DL MSB",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);	
	assert(req.randomize() with {addr_i==3'd0 && data_i==8'd27 && we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ2 DL LSB",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b0000_0011 && we_i==1;})	//make the LCR 7th bit has '0' for selecting the other registers
	`uvm_info("SEQ2 DLAB Disable",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ2 FCR",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0001 ; we_i==1;})// Select IER and set 0 and 2 bit as'1' to enable RX data available  
	`uvm_info("SEQ2 IER Enable",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)   // RX LS interrrupt 
	finish_item(req);
repeat(30)begin
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ;we_i==1;})	// Select THR and set the data_in=20
	`uvm_info("SEQ2 THR",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})	// Select IIR and enable it  
	`uvm_info("SEQ2 IIR Enable",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("---------------------Printing the IIR from the SEQ2:%b------------------------------------",req.iir);

	
	if(req.iir[3:1]==3'b010)
	repeat(14)
	    begin
		start_item(req);
		//$display("Inside loop SEQ2");
		assert(req.randomize() with {addr_i==3'd0 ; we_i==0;})	// Select Rb and read it  
		`uvm_info("SEQ2 read Rb",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)   
		finish_item(req);
	    end
	
	 if(req.iir[3:1]==3'b011)
	    begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Select Rb and read it  
	     	`uvm_info("SEQ2 read Rb",$sformatf("Printing from Seq2 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	    end

	
end
endtask



			//===================================HALF-DUPLEX MODE==================================//						

class uart_seq3 extends uart_bseqs;

`uvm_object_utils(uart_seq3)

extern function new(string name="uart_seq3");
extern task body();
endclass


function uart_seq3::new(string name="uart_seq3");
	super.new(name);
endfunction


task uart_seq3::body();
	req=uart_xtn::type_id::create("req");
begin
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd3; data_i==8'b1000_0000 ;we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ3 DLAB",$sformatf("Printing from Seq3 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0000 ;we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ3 DL MSB",$sformatf("Printing from Seq3 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd0; data_i==8'd54 ; we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ3 DL LSB",$sformatf("Printing from Seq3 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 ; data_i==8'b0000_0011 ; we_i==1;})//make the LCR 7th bit has '0' for selecting the other registers and 
	`uvm_info("SEQ3 DLAB Disable",$sformatf("Printing from Seq3 %s",req.sprint()),UVM_HIGH)   //to select the no.of bits in each character
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ3 FCR",$sformatf("Printing from Seq3 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0101 ; we_i==1;})// Select IER and set 0 and 2 bit as'1' to enable RX data available  
	`uvm_info("SEQ3 IER Enable",$sformatf("Printing from Seq3 %s",req.sprint()),UVM_HIGH)   // RX LS interrrupt 
	finish_item(req);
repeat(14)begin	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ; we_i==1;})	// Select THR and set the data_in=10
	`uvm_info("SEQ3 THR",$sformatf("Printing from Seq3 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end

// NO IIR and read RB and LSR

end
endtask




class uart_seq4 extends uart_bseqs;

`uvm_object_utils(uart_seq4)

extern function new(string name="uart_seq4");
extern task body();
endclass


function uart_seq4::new(string name="uart_seq4");
	super.new(name);
endfunction


task uart_seq4::body();
	req=uart_xtn::type_id::create("req");
begin

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b1000_0000 && we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ4 DLAB",$sformatf("Printing from7 Seq4 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 && data_i==8'b0000_0000 && we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ4 DL MSB",$sformatf("Printing from Seq4 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);	
	assert(req.randomize() with {addr_i==3'd0 && data_i==8'd27 && we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ4 DL LSB",$sformatf("Printing from Seq4 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b0000_0011 && we_i==1;})	//make the LCR 7th bit has '0' for selecting the other registers
	`uvm_info("SEQ4 DLAB Disable",$sformatf("Printing from Seq4 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ4 FCR",$sformatf("Printing from Seq4 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0101 ; we_i==1;})// Select IER and set 0 and 2 bit as'1' to enable RX data available  
	`uvm_info("SEQ4 IER Enable",$sformatf("Printing from Seq4 %s",req.sprint()),UVM_HIGH)   // RX LS interrrupt 
	finish_item(req);

//for Half_duplex Mode NO TX data here 

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})	// Select IIR and enable it  
	`uvm_info("SEQ4 IIR Enable",$sformatf("Printing from Seq4 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("#########################################Printing the IIR from the SEQ4:%b#############################################",req.iir);

if(req.iir[3:1]==3'b010)
	repeat(14)
	   	begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd0 ; we_i==0;})	
// Select Rb and read it  
		`uvm_info("SEQ4 read Rb",$sformatf("Printing from Seq4 %s",req.sprint()),UVM_HIGH)   
		finish_item(req);
	   end

else if(req.iir[3:1]==3'b011)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Read LSR  
	     	`uvm_info("SEQ4 read Rb",$sformatf("Printing from Seq4 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end

end
endtask



			///////////////////////////////////////// PARITY ERROR /////////////////////////////////////////


class uart_seq5 extends uart_bseqs;

`uvm_object_utils(uart_seq5)

extern function new(string name="uart_seq5");
extern task body();
endclass


function uart_seq5::new(string name="uart_seq5");
	super.new(name);
endfunction


task uart_seq5::body();
	req=uart_xtn::type_id::create("req");
begin
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd3; data_i==8'b1000_0000 ;we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ5 DLAB",$sformatf("Printing from Seq5 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0000 ;we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ5 DL MSB",$sformatf("Printing from Seq5 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd0; data_i==8'd54 ; we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ5 DL LSB",$sformatf("Printing from Seq5 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 ; data_i==8'b0001_1011 ; we_i==1;}) //Enable parity and configure it to EVEN PARITY
	`uvm_info("SEQ5 DLAB Disable",$sformatf("Printing from Seq5 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})
	`uvm_info("SEQ5 FCR",$sformatf("Printing from Seq5 %s",req.sprint()),UVM_HIGH) //Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0100 ; we_i==1;}) // Select IER and Enable RB and LSR Interrupt
	`uvm_info("SEQ5 IER Enable",$sformatf("Printing from Seq5 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
repeat(14)begin	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ; we_i==1;})	
	`uvm_info("SEQ5 THR",$sformatf("Printing from Seq5 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})  	// Select IIR and enable it 
	`uvm_info("SEQ5 IIR Enable",$sformatf("Printing from Seq5 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("#############################################Printing the IIR from the SEQ5:%b################################################",req.iir);
	
	
	if(req.iir[3:1]==3'b011)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Read LSR  
	     	`uvm_info("SEQ5 read Rb",$sformatf("Printing from Seq5 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end

end
endtask





class uart_seq6 extends uart_bseqs;

`uvm_object_utils(uart_seq6)

extern function new(string name="uart_seq6");
extern task body();
endclass


function uart_seq6::new(string name="uart_seq6");
	super.new(name);
endfunction


task uart_seq6::body();
	req=uart_xtn::type_id::create("req");
begin

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b1000_0000 && we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ6 DLAB",$sformatf("Printing from7 Seq6 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 && data_i==8'b0000_0000 && we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ6 DL MSB",$sformatf("Printing from Seq6 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);	
	assert(req.randomize() with {addr_i==3'd0 && data_i==8'd27 && we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ6 DL LSB",$sformatf("Printing from Seq6 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b0000_1011 && we_i==1;})	//Enable parity and configure it to EVEN PARITY
	`uvm_info("SEQ6 DLAB Disable",$sformatf("Printing from Seq6 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ6 FCR",$sformatf("Printing from Seq6 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0100 ; we_i==1;})// Select IER and Enable RB and LSR Interrupt 
	`uvm_info("SEQ6 IER Enable",$sformatf("Printing from Seq6 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
repeat(14)begin
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ;we_i==1;})	// Select THR
	`uvm_info("SEQ6 THR",$sformatf("Printing from Seq6 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})	// Select IIR and enable it  
	`uvm_info("SEQ6 IIR Enable",$sformatf("Printing from Seq6 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("---------------------Printing the IIR from the SEQ6:%b------------------------------------",req.iir);

	if(req.iir[3:1]==3'b011)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Read LSR  
	     	`uvm_info("SEQ6 read Rb",$sformatf("Printing from Seq6 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end

end
endtask




			///////////////////////////////////////// OVERRUN ERROR /////////////////////////////////////////


class uart_seq7 extends uart_bseqs;

`uvm_object_utils(uart_seq7)

extern function new(string name="uart_seq7");
extern task body();
endclass


function uart_seq7::new(string name="uart_seq7");
	super.new(name);
endfunction


task uart_seq7::body();
	req=uart_xtn::type_id::create("req");
begin
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd3; data_i==8'b1000_0000 ;we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ7 DLAB",$sformatf("Printing from Seq7 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0000 ;we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ7 DL MSB",$sformatf("Printing from Seq7 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd0; data_i==8'd54 ; we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ7 DL LSB",$sformatf("Printing from Seq7 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 ; data_i==8'b0000_0011 ; we_i==1;}) //Disable parity to check overrun condition
	`uvm_info("SEQ7 DLAB Disable",$sformatf("Printing from Seq7 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})
	`uvm_info("SEQ7 FCR",$sformatf("Printing from Seq7 %s",req.sprint()),UVM_HIGH)//Select FCR and Set trigger level as'1'bit by selecting FCR[7:6]==00
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0100 ; we_i==1;}) // Select IER and Enable RB and LSR Interrupt
	`uvm_info("SEQ7 IER Enable",$sformatf("Printing from Seq7 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
repeat(25)begin	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ; we_i==1;})	
	`uvm_info("SEQ7 THR",$sformatf("Printing from Seq7 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})  	// Select IIR and enable it 
	`uvm_info("SEQ7 IIR Enable",$sformatf("Printing from Seq7 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("#############################################Printing the IIR from the SEQ7:%b################################################",req.iir);
	

	if(req.iir[3:1]==3'b011)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Read LSR  
	     	`uvm_info("SEQ7 read Rb",$sformatf("Printing from Seq7 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end

end
endtask





class uart_seq8 extends uart_bseqs;

`uvm_object_utils(uart_seq8)

extern function new(string name="uart_seq8");
extern task body();
endclass


function uart_seq8::new(string name="uart_seq8");
	super.new(name);
endfunction


task uart_seq8::body();
	req=uart_xtn::type_id::create("req");
begin

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b1000_0000 && we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ8 DLAB",$sformatf("Printing from7 Seq8 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 && data_i==8'b0000_0000 && we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ8 DL MSB",$sformatf("Printing from Seq8 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);	
	assert(req.randomize() with {addr_i==3'd0 && data_i==8'd27 && we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ8 DL LSB",$sformatf("Printing from Seq8 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b0000_0011 && we_i==1;})	//Disable parity  for overrun condition
	`uvm_info("SEQ8 DLAB Disable",$sformatf("Printing from Seq8 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ8 FCR",$sformatf("Printing from Seq8 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0100 ; we_i==1;})// Select IER and Enable RB and LSR Interrupt 
	`uvm_info("SEQ8 IER Enable",$sformatf("Printing from Seq8 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
repeat(30)begin
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ;we_i==1;})	// Select THR
	`uvm_info("SEQ8 THR",$sformatf("Printing from Seq8 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})	// Select IIR and enable it  
	`uvm_info("SEQ8 IIR Enable",$sformatf("Printing from Seq8 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("---------------------Printing the IIR from the SEQ8:%b------------------------------------",req.iir);

	if(req.iir[3:1]==3'b011)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Read LSR  
	     	`uvm_info("SEQ8 read Rb",$sformatf("Printing from Seq8 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end
end
endtask





			///////////////////////////////////////// FRAMING ERROR /////////////////////////////////////////


class uart_seq9 extends uart_bseqs;

`uvm_object_utils(uart_seq9)

extern function new(string name="uart_seq9");
extern task body();
endclass


function uart_seq9::new(string name="uart_seq9");
	super.new(name);
endfunction


task uart_seq9::body();
	req=uart_xtn::type_id::create("req");
begin
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd3; data_i==8'b1000_0000 ;we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ9 DLAB",$sformatf("Printing from Seq9 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0000 ;we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ9 DL MSB",$sformatf("Printing from Seq9 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd0; data_i==8'd54 ; we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ9 DL LSB",$sformatf("Printing from Seq9 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 ; data_i==8'b0000_0011 ; we_i==1;}) //Disable parity to check overrun condition
	`uvm_info("SEQ9 DLAB Disable",$sformatf("Printing from Seq9 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})
	`uvm_info("SEQ9 FCR",$sformatf("Printing from Seq9 %s",req.sprint()),UVM_HIGH)//Select FCR and Set trigger level as'1'bit by selecting FCR[7:6]==00
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0100 ; we_i==1;}) // Select IER and Enable RB and LSR Interrupt
	`uvm_info("SEQ9 IER Enable",$sformatf("Printing from Seq9 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
repeat(14)begin	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ; we_i==1;})	
	`uvm_info("SEQ9 THR",$sformatf("Printing from Seq9 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})  	// Select IIR and enable it 
	`uvm_info("SEQ9 IIR Enable",$sformatf("Printing from Seq9 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("#############################################Printing the IIR from the SEQ9:%b################################################",req.iir);
	
	

	if(req.iir[3:1]==3'b011)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Read LSR  
	     	`uvm_info("SEQ9 read Rb",$sformatf("Printing from Seq9 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end

end
endtask





class uart_seq10 extends uart_bseqs;

`uvm_object_utils(uart_seq10)

extern function new(string name="uart_seq10");
extern task body();
endclass


function uart_seq10::new(string name="uart_seq10");
	super.new(name);
endfunction


task uart_seq10::body();
	req=uart_xtn::type_id::create("req");
begin

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b1000_0000 && we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ10 DLAB",$sformatf("Printing from7 Seq10 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 && data_i==8'b0000_0000 && we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ10 DL MSB",$sformatf("Printing from Seq10 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);	
	assert(req.randomize() with {addr_i==3'd0 && data_i==8'd27 && we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ10 DL LSB",$sformatf("Printing from Seq10 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b0000_0010 && we_i==1;})	//Disable parity  for overrun condition
	`uvm_info("SEQ10 DLAB Disable",$sformatf("Printing from Seq10 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ10 FCR",$sformatf("Printing from Seq10 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0100 ; we_i==1;})// Select IER and Enable RB and LSR Interrupt 
	`uvm_info("SEQ10 IER Enable",$sformatf("Printing from Seq10 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
repeat(14)begin
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ;we_i==1;})	// Select THR
	`uvm_info("SEQ10 THR",$sformatf("Printing from Seq10 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})	// Select IIR and enable it  
	`uvm_info("SEQ10 IIR Enable",$sformatf("Printing from Seq10 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("---------------------Printing the IIR from the SEQ10:%b------------------------------------",req.iir);
	
	
	if(req.iir[3:1]==3'b011)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Read LSR  
	     	`uvm_info("SEQ10 read Rb",$sformatf("Printing from Seq10 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end
end
endtask




			///////////////////////////////////////// BREAK INTERRUPT /////////////////////////////////////////


class uart_seq11 extends uart_bseqs;

`uvm_object_utils(uart_seq11)

extern function new(string name="uart_seq11");
extern task body();
endclass


function uart_seq11::new(string name="uart_seq11");
	super.new(name);
endfunction


task uart_seq11::body();
	req=uart_xtn::type_id::create("req");
begin
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd3; data_i==8'b1000_0000 ;we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ11 DLAB",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0000 ;we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ11 DL MSB",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd0; data_i==8'd54 ; we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ11 DL LSB",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 ; data_i==8'b0100_0011 ; we_i==1;}) //Disable parity to check overrun condition
	`uvm_info("SEQ11 DLAB Disable",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})
	`uvm_info("SEQ11 FCR",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)//Select FCR and Set trigger level as'1'bit by selecting FCR[7:6]==00
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0100 ; we_i==1;}) // Select IER and Enable RB and LSR Interrupt
	`uvm_info("SEQ11 IER Enable",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
repeat(14)begin	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ; we_i==1;})	
	`uvm_info("SEQ11 THR",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})  	// Select IIR and enable it 
	`uvm_info("SEQ11 IIR Enable",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("#############################################Printing the IIR from the SEQ11:%b################################################",req.iir);
	
	

	if(req.iir[3:1]==3'b011)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Read LSR  
	     	`uvm_info("SEQ11 read Rb",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end

end
endtask





class uart_seq12 extends uart_bseqs;

`uvm_object_utils(uart_seq12)

extern function new(string name="uart_seq12");
extern task body();
endclass


function uart_seq12::new(string name="uart_seq12");
	super.new(name);
endfunction


task uart_seq12::body();
	req=uart_xtn::type_id::create("req");
begin

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b1000_0000 && we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ12 DLAB",$sformatf("Printing from7 Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 && data_i==8'b0000_0000 && we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ12 DL MSB",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);	
	assert(req.randomize() with {addr_i==3'd0 && data_i==8'd27 && we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ12 DL LSB",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b0100_0011 && we_i==1;})	//Disable parity  for overrun condition
	`uvm_info("SEQ12 DLAB Disable",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ12 FCR",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0100 ; we_i==1;})// Select IER and Enable RB and LSR Interrupt 
	`uvm_info("SEQ12 IER Enable",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
repeat(14)begin
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ;we_i==1;})	// Select THR
	`uvm_info("SEQ12 THR",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})	// Select IIR and enable it  
	`uvm_info("SEQ12 IIR Enable",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("---------------------Printing the IIR from the SEQ10:%b------------------------------------",req.iir);
	
	
	if(req.iir[3:1]==3'b011)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd5 ; we_i==0;})	// Read LSR  
	     	`uvm_info("SEQ12 read Rb",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end
end
endtask




			///////////////////////////////////////// THR EMPTY /////////////////////////////////////////


class uart_seq13 extends uart_bseqs;

`uvm_object_utils(uart_seq13)

extern function new(string name="uart_seq13");
extern task body();
endclass


function uart_seq13::new(string name="uart_seq13");
	super.new(name);
endfunction


task uart_seq13::body();
	req=uart_xtn::type_id::create("req");
begin
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd3; data_i==8'b1000_0000 ;we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ13 DLAB",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0000 ;we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ13 DL MSB",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd0; data_i==8'd54 ; we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ13 DL LSB",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 ; data_i==8'b0000_0011 ; we_i==1;}) //Disable parity to check overrun condition
	`uvm_info("SEQ13 DLAB Disable",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})
	`uvm_info("SEQ13 FCR",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)//Select FCR and Set trigger level as'1'bit by selecting FCR[7:6]==00
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0010 ; we_i==1;}) // Select IER and Enable RB and LSR Interrupt
	`uvm_info("SEQ13 IER Enable",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
/*repeat(14)begin	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ; we_i==1;})	
	`uvm_info("SEQ13 THR",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end*/
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})  	// Select IIR and enable it 
	`uvm_info("SEQ13 IIR Enable",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("#############################################Printing the IIR from the SEQ13:%b################################################",req.iir);
	
	

	if(req.iir[3:1]==3'b001)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd0 ; we_i==1;})	// Write to THR 
	     	`uvm_info("SEQ13 read Rb",$sformatf("Printing from Seq11 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end	
end
endtask





class uart_seq14 extends uart_bseqs;

`uvm_object_utils(uart_seq14)

extern function new(string name="uart_seq14");
extern task body();
endclass


function uart_seq14::new(string name="uart_seq14");
	super.new(name);
endfunction


task uart_seq14::body();
	req=uart_xtn::type_id::create("req");
begin

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b1000_0000 && we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ14 DLAB",$sformatf("Printing from7 Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 && data_i==8'b0000_0000 && we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ14 DL MSB",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);	
	assert(req.randomize() with {addr_i==3'd0 && data_i==8'd27 && we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ14 DL LSB",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b0000_0011 && we_i==1;})	//Disable parity  for overrun condition
	`uvm_info("SEQ14 DLAB Disable",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ14 FCR",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0010 ; we_i==1;})// Select IER and Enable RB and LSR Interrupt 
	`uvm_info("SEQ14 IER Enable",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
/*repeat(14)begin
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ;we_i==1;})	// Select THR
	`uvm_info("SEQ14 THR",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end*/
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})	// Select IIR and enable it  
	`uvm_info("SEQ14 IIR Enable",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("---------------------Printing the IIR from the SEQ14:%b------------------------------------",req.iir);
	
	
	if(req.iir[3:1]==3'b001)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd0 ; we_i==1;})	// write to THR  
	     	`uvm_info("SEQ14 read Rb",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end

	 end
endtask





			//////////////////////////////////////// LOOP BACK MODE //////////////////////////////////////


class uart_seq15 extends uart_bseqs;

`uvm_object_utils(uart_seq15)

extern function new(string name="uart_seq15");
extern task body();
endclass


function uart_seq15::new(string name="uart_seq15");
	super.new(name);
endfunction


task uart_seq15::body();
	req=uart_xtn::type_id::create("req");
begin

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b1000_0000 && we_i==1;})	//To select the DLAB make the LCR bit 7 as 1
	`uvm_info("SEQ14 DLAB",$sformatf("Printing from7 Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 && data_i==8'b0000_0000 && we_i==1;})	//select the DLB MSB by addr '1' and load the MSB of DLB as 0
	`uvm_info("SEQ14 DL MSB",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);	
	assert(req.randomize() with {addr_i==3'd0 && data_i==8'd27 && we_i==1;})	//select the DLB LSB by addr '0' and load the LSB with the DLV
	`uvm_info("SEQ14 DL LSB",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd3 && data_i==8'b0000_0011 && we_i==1;})	//Disable parity  for overrun condition
	`uvm_info("SEQ14 DLAB Disable",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	start_item(req);
	assert(req.randomize() with {addr_i==3'd4 ; data_i==8'b0001_0000 ; we_i==1;})//LOOP BACK MODE ENABLE
	`uvm_info("SEQ14 FCR",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);


	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b1100_0000 ; we_i==1;})//Select FCR and Set trigger level as '1'bit by selecting FCR[7:6]==00
	`uvm_info("SEQ14 FCR",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)  
	finish_item(req);
	
	start_item(req);
	assert(req.randomize() with {addr_i==3'd1 ; data_i==8'b0000_0001 ; we_i==1;})// Select IER and Enable RB and LSR Interrupt 
	`uvm_info("SEQ14 IER Enable",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
repeat(14)begin
	start_item(req);
	assert(req.randomize() with {addr_i==3'd0 ;we_i==1;})	// Select THR
	`uvm_info("SEQ14 THR",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)    
	finish_item(req);
end
	start_item(req);
	assert(req.randomize() with {addr_i==3'd2 ; data_i==8'b0000_0000 ; we_i==0;})	// Select IIR and enable it  
	`uvm_info("SEQ14 IIR Enable",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)   
	finish_item(req);

	

get_response(req);
	$display("---------------------Printing the IIR from the SEQ15:%b------------------------------------",req.iir);
	
	
	if(req.iir[3:1]==3'b010)
	   begin
		start_item(req);
		assert(req.randomize() with {addr_i==3'd0 ; we_i==0;})	// read Rb 
	     	`uvm_info("SEQ14 read Rb",$sformatf("Printing from Seq12 %s",req.sprint()),UVM_HIGH)   
	     	finish_item(req);
	   end

	 end
endtask	
