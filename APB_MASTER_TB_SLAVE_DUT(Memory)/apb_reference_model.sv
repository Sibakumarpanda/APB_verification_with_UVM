//--------------------------------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : apb_reference_model.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : 
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_REFERENCE_MODEL_SV
`define GUARD_APB_REFERENCE_MODEL_SV

import uvm_pkg::*;

class apb_reference_model#(parameter DEPTH = 5) extends uvm_component;
  
    `uvm_component_utils(apb_reference_model)

    const int ram_depth = 2**DEPTH;   //variables
    bit [31:0] ram_mem [];            // Memory for DEPTH defined
    
    // Constructor: new
    extern function new(string name = "apb_reference_model", uvm_component parent);
      
    //extern function get_ref_val(apb_transaction trans);
    // Function: get_ref_val()
      
   function apb_transaction get_ref_val(apb_transaction trans);
       if(trans.PRESETn == 0) begin
         foreach (ram_mem[i]) ram_mem[i] = 32'hffffffff;
           trans.PSLVERR = 0;
            //trans.PRDATA[0] = 32'b0;
           trans.PREADY = 0;
           return trans;
       end
         for(int i=0; i<trans.PADDR.size(); i++) begin
            if(trans.PADDR[i] >= ram_depth) begin
                trans.PSLVERR = 1;
                trans.PRDATA[i] = 32'b0;
                trans.PREADY = 1;
                continue;
            end

            if(trans.PWRITE == 1) begin
                if(trans.PWDATA[i] === 32'hx || trans.PWDATA[i] === 32'hz ) begin
                    trans.PRDATA[i] = 32'b0;
                    trans.PREADY = 1;
                    trans.PSLVERR = 1;
                    continue;
                end
                ram_mem [trans.PADDR[i]] = trans.PWDATA[i];
                trans.PRDATA[i] = 32'b0;
                trans.PREADY = 1;
                trans.PSLVERR = 0;
            end
            else begin
                if(ram_mem[trans.PADDR[i]] == 32'hffffffff) begin
                    trans.PRDATA[i] = 32'hffffffff;
                    trans.PREADY = 1;
                    trans.PSLVERR = 1;
                    continue;
                end
                trans.PRDATA[i] = ram_mem [trans.PADDR[i]];
                trans.PREADY = 1;
                trans.PSLVERR = 0;
            end
        end
        return trans;
  
   endfunction: get_ref_val  
      
      
endclass :apb_reference_model 
      
//===================================================================================
// New
//===================================================================================
function apb_reference_model::new(string name ="apb_reference_model", uvm_component parent);
     super.new(name, parent);
     ram_mem = new[ram_depth];
endfunction :new
  


`endif //GUARD_APB_REFERENCE_MODEL_SV 