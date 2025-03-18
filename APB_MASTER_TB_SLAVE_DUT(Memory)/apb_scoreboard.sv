//------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : apb_scoreboard.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : 
// Author  : Siba Kumar Panda
/////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_SCOREBOARD_SV
`define GUARD_APB_SCOREBOARD_SV

import uvm_pkg::*;

class apb_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(apb_scoreboard)

   // Components
   apb_reference_model rm;
   uvm_analysis_imp#(apb_transaction, apb_scoreboard) ap_exp;

   // Variable
   apb_transaction act_trans, exp_trans;
   int passCnt, failCnt;
  
   // Constructor: new
   extern function new(string name = "apb_scoreboard", uvm_component parent);
   //  Function: build_phase
   extern function void build_phase(uvm_phase phase);
   // Function: report_phase
   extern function void report_phase(uvm_phase phase);
     
   extern function void check();
   extern function void write(apb_transaction trans); 
  
endclass : apb_scoreboard 
 
//===================================================================================
// New
//===================================================================================
          
function apb_scoreboard::new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name, parent);
endfunction : new
     
//===================================================================================
// build_phase
//===================================================================================
function void apb_scoreboard::build_phase(uvm_phase phase);
  
    rm = apb_reference_model#()::type_id::create("rm", this);
    act_trans = new("act_trans");
    ap_exp = new("ap_exp", this);
  
endfunction: build_phase     
     
//  Below Functions are used for scoreboard comparision and check purpose
     
// Fuction: check()
function void apb_scoreboard::check();
     if(act_trans.compare(exp_trans)) begin
        //`uvm_info("SCB", $sformatf("%s\nTESTCASE Status -> PASSED", act_trans.convert2string()), UVM_NONE)
       `uvm_info("SCB", $sformatf("Actual Packet: %s\nExpected Packet: %s\nPACKET Status -> PACKET_MATCHED", act_trans.convert2string(), exp_trans.convert2string()), UVM_NONE)
         passCnt++;
     end
     else begin
       `uvm_error("SCB", $sformatf("Actual Packet: %s\nExpected Packet: %s\nPACKET Status -> PACKET_MISMATCHED", act_trans.convert2string(), exp_trans.convert2string()))
        failCnt++;
     end
endfunction: check

// Fuction: write()
function void apb_scoreboard::write(apb_transaction trans);
     act_trans.copy(trans);
     exp_trans = rm.get_ref_val(trans);
     check();
endfunction: write
//===================================================================================
// report_phase -Report phase to summarize results at the end of simulation
//===================================================================================
     
function void apb_scoreboard::report_phase(uvm_phase phase);
     $display("\n**************APB Scoreboard comparison Summary***************\n");
     $display("Number of successful comparisons = %0d,Number of Unsuccessful comparisons = %0d\n",passCnt,failCnt);
     $display("-----------------------------------------------------------------\n");
endfunction : report_phase     

`endif //GUARD_APB_SCOREBOARD_SV