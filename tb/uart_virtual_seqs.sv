class uart_virtual_bseqs extends uvm_sequence #(uvm_sequence_item);

`uvm_object_utils(uart_virtual_bseqs)

uart_sequencer seqrh[];

uart_virtual_sequencer v_seqrh;

uart_env_config e_cfg;


extern function new(string name="uart_virtual_bseqs");
extern task body();
endclass


function uart_virtual_bseqs::new(string name="uart_virtual_bseqs");
	super.new(name);
endfunction


task uart_virtual_bseqs::body();
	if(!uvm_config_db #(uart_env_config)::get(null,get_full_name(),"uart_env_config",e_cfg))
	`uvm_fatal("V_SEQS","cannot get the e_cfg from uvm_config_db")

	seqrh=new[e_cfg.no_of_agents];

	assert($cast(v_seqrh,m_sequencer))
		else
		    `uvm_error("V_SEQS","error in $casting V_Sequencer")
		
	foreach(seqrh[i])
		seqrh[i]=v_seqrh.seqrh[i];
endtask


			//==================================FULL-DUPLEX V_SEQ======================================//

class uart_fd_vseq extends uart_virtual_bseqs;

`uvm_object_utils(uart_fd_vseq)

uart_seq1 seq1;
uart_seq2 seq2;

extern function new(string name="uart_fd_vseq");
extern task body();
endclass


function uart_fd_vseq::new(string name="uart_fd_vseq");
	super.new(name);
endfunction


task uart_fd_vseq::body();
	super.body();

	seq1=uart_seq1::type_id::create("seq1");
	seq2=uart_seq2::type_id::create("seq2");

	fork
	    seq1.start(seqrh[0]);
	    seq2.start(seqrh[1]);
	join 
endtask




			//==================================HALF-DUPLEX V_SEQ======================================//

class uart_hd_vseq extends uart_virtual_bseqs;

`uvm_object_utils(uart_hd_vseq)

uart_seq3 seq3;
uart_seq4 seq4;

extern function new(string name="uart_hd_vseq");
extern task body();
endclass


function uart_hd_vseq::new(string name="uart_hd_vseq");
	super.new(name);
endfunction


task uart_hd_vseq::body();
	super.body();

	seq3=uart_seq3::type_id::create("seq3");
	seq4=uart_seq4::type_id::create("seq4");

	fork
	    seq3.start(seqrh[0]);
	    seq4.start(seqrh[1]);
	join 
endtask



	//==================================PARITY ERROR V_SEQ======================================//

class uart_parityERR_vseq extends uart_virtual_bseqs;

`uvm_object_utils(uart_parityERR_vseq)

uart_seq5 seq5;
uart_seq6 seq6;

extern function new(string name="uart_parityERR_vseq");
extern task body();
endclass


function uart_parityERR_vseq::new(string name="uart_parityERR_vseq");
	super.new(name);
endfunction


task uart_parityERR_vseq::body();
	super.body();

	seq5=uart_seq5::type_id::create("seq5");
	seq6=uart_seq6::type_id::create("seq6");

	fork
	    seq5.start(seqrh[0]);
	    seq6.start(seqrh[1]);
	join 
endtask



			//==================================OVERRUN ERROR V_SEQ======================================//

class uart_overrun_vseq extends uart_virtual_bseqs;

`uvm_object_utils(uart_overrun_vseq)

uart_seq7 seq7;
uart_seq8 seq8;

extern function new(string name="uart_overrun_vseq");
extern task body();
endclass


function uart_overrun_vseq::new(string name="uart_overrun_vseq");
	super.new(name);
endfunction


task uart_overrun_vseq::body();
	super.body();

	seq7=uart_seq7::type_id::create("seq7");
	seq8=uart_seq8::type_id::create("seq8");

	fork
	    seq7.start(seqrh[0]);
	    seq8.start(seqrh[1]);
	join 
endtask



			//==================================FRAMING ERROR V_SEQ======================================//

class uart_framing_vseq extends uart_virtual_bseqs;

`uvm_object_utils(uart_framing_vseq)

uart_seq9 seq9;
uart_seq10 seq10;

extern function new(string name="uart_framing_vseq");
extern task body();
endclass


function uart_framing_vseq::new(string name="uart_framing_vseq");
	super.new(name);
endfunction


task uart_framing_vseq::body();
	super.body();

	seq9=uart_seq9::type_id::create("seq9");
	seq10=uart_seq10::type_id::create("seq10");

	fork
	    seq9.start(seqrh[0]);
	    seq10.start(seqrh[1]);
	join 
endtask



	

			//==================================BREAK INTERRUPT V_SEQ======================================//

class uart_break_vseq extends uart_virtual_bseqs;

`uvm_object_utils(uart_break_vseq)

uart_seq11 seq11;
uart_seq12 seq12;

extern function new(string name="uart_break_vseq");
extern task body();
endclass


function uart_break_vseq::new(string name="uart_break_vseq");
	super.new(name);
endfunction


task uart_break_vseq::body();
	super.body();

	seq11=uart_seq11::type_id::create("seq11");
	seq12=uart_seq12::type_id::create("seq12");

	fork
	    seq11.start(seqrh[0]);
	    seq12.start(seqrh[1]);
	join 
endtask




	//==================================THR EMPTY  V_SEQ======================================//

class uart_thr_empty_vseq extends uart_virtual_bseqs;

`uvm_object_utils(uart_thr_empty_vseq)

uart_seq13 seq13;
uart_seq14 seq14;

extern function new(string name="uart_thr_empty_vseq");
extern task body();
endclass


function uart_thr_empty_vseq::new(string name="uart_thr_empty_vseq");
	super.new(name);
endfunction


task uart_thr_empty_vseq::body();
	super.body();

	seq13=uart_seq13::type_id::create("seq13");
	seq14=uart_seq14::type_id::create("seq14");

	fork
	    seq13.start(seqrh[0]);
	    seq14.start(seqrh[1]);
	join 
endtask


	//================================== LOOP BACK MODE V_SEQ======================================//

class uart_loop_back extends uart_virtual_bseqs;

`uvm_object_utils(uart_loop_back)


uart_seq15 seq15;

extern function new(string name="uart_loop_back");
extern task body();
endclass


function uart_loop_back::new(string name="uart_loop_back");
	super.new(name);
endfunction


task uart_loop_back::body();
	super.body();

	seq15=uart_seq15::type_id::create("seq14");

	fork
	    seq15.start(seqrh[0]);
	    
	join 
endtask



	




