//-------------------------------------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File       : apb_monitor.sv 
// Project    : APB design & verification Infra Development, where Master is TB and Slave is DUT(a memory)
// Purpose    : 
// Author     : Siba Kumar Panda
// GithubLink : https://github.com/Sibakumarpanda
/////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_MONITOR_SV
`define GUARD_APB_MONITOR_SV

import uvm_pkg::*;

class apb_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_monitor)
   uvm_analysis_port#(apb_transaction) ap;

   // Variables
   virtual apb_interface.MON intf;
   apb_transaction trans;
   int ip_pntr, op_pntr;
   bit sampled;
   bit pck_complete;
  
   // Constructor: new
   extern function new(string name = "apb_monitor", uvm_component parent);
   //  Function: build_phase
   extern function void build_phase(uvm_phase phase);    
   //  Function: run_phase
   extern task run_phase(uvm_phase phase);
     
   extern task ip_mon();
   extern task op_mon(); 
    
endclass :apb_monitor 
     
//===================================================================================
// New
//===================================================================================

function apb_monitor::new(string name = "apb_monitor", uvm_component parent);
     super.new(name, parent);
endfunction //new()
     
//===================================================================================
// build_phase
//===================================================================================
function void apb_monitor::build_phase(uvm_phase phase);
   if(!uvm_config_db#(virtual apb_interface)::get(this, "*", "vif", intf))
        `uvm_fatal(get_name(), "Cant get interface") 
    ap = new("ap", this);
    trans = new("sam_trans");
endfunction: build_phase

//===================================================================================
// run_phase
//===================================================================================
task apb_monitor::run_phase(uvm_phase phase);
    forever begin
        fork
            ip_mon();
            op_mon();
        join
        `uvm_info(get_name(), $sformatf("pck_complete: %b, PSEL1: %b", pck_complete, intf.mon_cb.PSEL1), UVM_HIGH)
      
        if((pck_complete && !intf.mon_cb.PSEL1) || !intf.mon_cb.PRESETn) begin
            `uvm_info(get_name(), $sformatf("Sampled Packet is: %s", trans.convert2string()), UVM_HIGH)
            ap.write(trans);
            trans = new("sam_trans");
            ip_pntr = 0;
            op_pntr = 0;
            pck_complete = 0;
        end
    end
endtask: run_phase  

//  Below tasks are used inside the run phase task     
     
task apb_monitor::ip_mon();
     @(intf.mon_cb);
       if(intf.mon_cb.PENABLE == 1 && !sampled) begin
            trans.PWRITE    = intf.mon_cb.PWRITE;
            trans.PSEL1     = intf.mon_cb.PSEL1;
            trans.PRESETn   = intf.mon_cb.PRESETn;
            trans.increaseSize();
            trans.PADDR[ip_pntr]  = intf.mon_cb.PADDR;
            trans.PWDATA[ip_pntr] = intf.mon_cb.PWDATA;
            ip_pntr++;
            sampled = 1;
       end
       if(intf.mon_cb.PENABLE == 0) 
           sampled = 0;
endtask: ip_mon

task apb_monitor::op_mon();
     @(intf.mon_cb);
       if(intf.mon_cb.PREADY == 1 && intf.mon_cb.PENABLE == 1) begin
            trans.PREADY = intf.mon_cb.PREADY;
            trans.PSLVERR = intf.mon_cb.PSLVERR;
            trans.PRDATA[op_pntr]  = intf.mon_cb.PRDATA;
            op_pntr++;
            pck_complete = 1;
       end 
endtask: op_mon

`endif //GUARD_APB_MONITOR_SV