//------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : apb_fun_cov.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : 
// Author  : Siba Kumar Panda
////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_FUN_COV_SV
`define GUARD_APB_FUN_COV_SV

import uvm_pkg::*;

class apb_fun_cov extends uvm_subscriber#(apb_transaction);
  
  `uvm_component_utils(apb_fun_cov)
    
    // Variables
    apb_transaction trans;
    bit [31:0] _tempPADDR, _tempPWDATA, _tempRDATA;
  
    //Constructor: new   
    extern function new(string name = "apb_fun_cov",uvm_component parent);
   
    //Function: build_phase
    extern function void build_phase(uvm_phase phase);

    // Covergroup for Functional coverage
    covergroup apb_cg; 
      
        PSEL1: coverpoint trans.PSEL1 { bins psel1 = {1}; 
                                        illegal_bins il_psel1= {0}; }
        PWRITE: coverpoint trans.PWRITE { bins pwrite[] = {0, 1}; }
        PWDATA: coverpoint _tempPWDATA { bins pwdata[16] = {[0:32'hffffffff]}; }
        PADDR: coverpoint _tempPADDR { bins paddr[] = {[0:32'h0000001f]}; 
                                       illegal_bins il_paddr = default; }
        PREADY: coverpoint trans.PREADY { bins pready = {1};
                                          illegal_bins il_pready= {0}; }
        PRDATA: coverpoint _tempRDATA { bins prdata[16] = {[0:32'hffffffff]}; }
        PSLVERR: coverpoint trans.PSLVERR { bins pslverr[] = {0, 1}; }
        PSEL1xPWRITE: cross PSEL1, PWRITE { ignore_bins ig_bins = binsof(PSEL1) intersect{0}; }
        PSEL1xPWRITExPADDR: cross PSEL1, PWRITE, PADDR { ignore_bins ig_bins = binsof(PSEL1) intersect{0}; }
      
    endgroup

    /* Function for sampling data for coverage
       It has to be done because the trans.PADDR and other data signals are unpacked array as they have to 
       store more than one element for multiple transfer packet. Thus a loop is used and each element is stored 
       in temperory variable and then sampled.
       Advantage - Easy to implement Disadvantage - Lot of signals will be sampled more than once for same value */
  
    function void cov_sample;
        for(int j = 0; j < trans.PADDR.size(); j++) begin
            _tempRDATA = trans.PRDATA[j];
            _tempPWDATA = trans.PWDATA[j];
            _tempPADDR = trans.PADDR[j];
            apb_cg.sample();
        end
    endfunction

    function void write(T t);
        trans = t;
        cov_sample();
    endfunction

endclass : apb_fun_cov 

//===================================================================================
// New
//===================================================================================

function apb_fun_cov::new(string name ="apb_fun_cov", uvm_component parent);
    super.new(name, parent);
    apb_cg = new();
endfunction :new

//===================================================================================
// build_phase
//===================================================================================
function void apb_fun_cov::build_phase(uvm_phase phase);
    trans = new("cov_trans");
endfunction: build_phase

`endif //GUARD_APB_FUN_COV_SV