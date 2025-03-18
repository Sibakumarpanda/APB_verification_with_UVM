//------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : testbench.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : tb_top file
// Author  : Siba Kumar Panda
////////////////////////////////////////////////////////////////////////////////////////////////////////

// Top level testbench module to instantiate design and interface
// start clocks and run the test

`include "apb_interface.sv"
`include "apb_package.sv"
 import   apb_package::*;

module tb_top;
  
    bit clk;

    apb_interface intf(clk);

    apb_mem dut(._PCLK(clk), ._PRESETn(intf.PRESETn), ._PSEL1(intf.PSEL1), ._PWRITE(intf.PWRITE), 
                ._PENABLE(intf.PENABLE), ._PADDR(intf.PADDR), ._PWDATA(intf.PWDATA),
                ._PRDATA(intf.PRDATA), ._PREADY(intf.PREADY), ._PSLVERR(intf.PSLVERR)
               );

    always #5 clk = ~clk;

    initial begin
      uvm_config_db#(virtual apb_interface)::set(null, "*", "vif", intf);
      run_test("apb_base_test");
      
    end
  
    initial begin
       $dumpfile("dump.vcd");
       $dumpvars;
    end
  
endmodule


