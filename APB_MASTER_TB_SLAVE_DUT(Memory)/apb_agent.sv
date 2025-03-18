//------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : apb_agent.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : 
// Author  : Siba Kumar Panda
////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_AGENT_SV
`define GUARD_APB_AGENT_SV

import uvm_pkg::*;

class apb_agent extends uvm_agent;
  
  `uvm_component_utils(apb_agent) 
  
   apb_driver drv;
   apb_monitor mon;
   uvm_sequencer#(apb_transaction) seqr;
  
   apb_fun_cov fc;
   uvm_analysis_port#(apb_transaction) ap;
  
   //  Group: Variables
   apb_random_sequence seq;
   apb_agent_config agnt_cfg;

   //  Constructor: new
    extern function new(string name ="apb_agent", uvm_component parent);
    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Function: connect_phase
    extern function void connect_phase(uvm_phase phase);
    
endclass :apb_agent 

//===================================================================================
// New
//===================================================================================
      
function apb_agent::new(string name ="apb_agent", uvm_component parent);
     super.new(name, parent);
endfunction :new
      
//===================================================================================
// build_phase
//===================================================================================
function void apb_agent::build_phase(uvm_phase phase);
  
  if(!uvm_config_db#(apb_agent_config)::get(this, "*", "agnt_cfg", agnt_cfg))
        `uvm_fatal(get_name(), "agnt_cfg cannot be found in ConfigDB!")
    
    mon = apb_monitor::type_id::create("mon", this);
  
    if(agnt_cfg.active) begin
        drv = apb_driver::type_id::create("drv", this);
      seqr = uvm_sequencer#(apb_transaction)::type_id::create("seqr", this);
    end
    
    if(agnt_cfg.has_fun_cov) begin
        fc = apb_fun_cov::type_id::create("fc", this);
    end
  
endfunction: build_phase

//===================================================================================
// connect_phase
//===================================================================================

function void apb_agent::connect_phase(uvm_phase phase);
  
    super.connect_phase(phase);
    mon.intf = agnt_cfg.intf;
    ap = mon.ap;

    if(agnt_cfg.active) begin
        drv.seq_item_port.connect(seqr.seq_item_export);
        drv.drv_intf = agnt_cfg.intf;
    end

    if(agnt_cfg.has_fun_cov) begin
        mon.ap.connect(fc.analysis_export);
    end
  
endfunction: connect_phase

`endif //GUARD_APB_AGENT_SV 