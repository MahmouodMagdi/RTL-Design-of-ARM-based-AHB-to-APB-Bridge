/////////////////////////////////////////////////////////////////////////////////////////////
//
//    AMBA Advanced High-Performance Bus to AMPA Advanced Peripheral Bus Bridge TEST Bench 
//
//    Author: Mahmoud Magdi 
//
/////////////////////////////////////////////////////////////////////////////////////////////


module tb_AHP_to_APB_Bridge #(

    parameter DATA_WIDTH = 32,
	          ADDR_WIDTH = 32,
              TRAN_WIDTH = 3,
              CLK_PER    = 10
) (

);
    
/////////////////////////////////////////////////////////////////////////////////////////
// -------------------------         Test-Bench Signals         -------------------------
/////////////////////////////////////////////////////////////////////////////////////////
logic                       H_CLK_tb      ;
logic                       H_RESET_n_tb  ;
logic                       H_WRITE_tb    ;
logic                       H_SEL_APB_tb  ;
logic                       H_READY_IN_tb ;
logic [TRAN_WIDTH - 1 : 0]  H_TRANS_tb    ;
logic [DATA_WIDTH - 1 : 0]  H_WDATA_tb    ;
logic [DATA_WIDTH - 1 : 0]  H_ADDR_tb     ;
logic [DATA_WIDTH - 1 : 0]  P_RDATA_tb    ;
logic                       H_RESP_tb     ;
logic                       H_READY_OUT_tb;
logic                       P_ENABLE_tb   ;
logic                       P_WRITE_tb    ;
logic                       P_Sel_APB_tb  ;
logic [DATA_WIDTH - 1 : 0]  P_WDATA_tb    ;
logic [DATA_WIDTH - 1 : 0]  P_ADDR_tb     ;
logic [DATA_WIDTH - 1 : 0]  H_RDATA_tb    ;





/////////////////////////////////////////////////////////////////////////////////////////
// -------------------------   Design Under Test Instantiation  -------------------------
/////////////////////////////////////////////////////////////////////////////////////////
AHP_to_APB_Bridge #(

    .DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
    .TRAN_WIDTH(TRAN_WIDTH)

) DUT (

    .H_CLK      (H_CLK_tb      )  ,
    .H_RESET_n  (H_RESET_n_tb  )  ,
    .H_WRITE    (H_WRITE_tb    )  ,
    .H_SEL_APB  (H_SEL_APB_tb  )  , 
    .H_READY_IN (H_READY_IN_tb )  ,
    .H_TRANS    (H_TRANS_tb    )  ,
    .H_WDATA    (H_WDATA_tb    )  ,
    .H_ADDR     (H_ADDR_tb     )  ,
    .P_RDATA    (P_RDATA_tb    )  ,

    .H_RESP     (H_RESP_tb     )  ,
    .H_READY_OUT(H_READY_OUT_tb)  ,
    .P_ENABLE   (P_ENABLE_tb   )  ,
    .P_WRITE    (P_WRITE_tb    )  ,
    .P_SELx     (P_Sel_APB_tb  )  ,
    .P_WDATA    (P_WDATA_tb    )  ,
    .P_ADDR     (P_ADDR_tb     )  ,
    .H_RDATA    (H_RDATA_tb    )                
    
);

////////////////////////////////////
// --- Signals Initialization --- //
////////////////////////////////////
initial begin

    H_CLK_tb      = 'b0;
    H_RESET_n_tb  = 'b1;
    H_WRITE_tb    = 'b0;
    H_SEL_APB_tb  = 'b0;
    H_READY_IN_tb = 'b0;
    H_TRANS_tb    = 'b0;
    H_WDATA_tb    = 'b0;
    H_ADDR_tb     = 'b0;
    P_RDATA_tb    = 'b0;

end


//////////////////////////////
// --- Clock Generation --- //
////////////////////////////// 
always #(CLK_PER/2) begin
    H_CLK_tb = ~H_CLK_tb;
end

//////////////////////////////
// ---    Reset Task    --- //
////////////////////////////// 
task reset();
    begin

        @(negedge H_CLK_tb)
            H_RESET_n_tb = 1'b0;

        #50;

        @(negedge H_CLK_tb)
            H_RESET_n_tb = 1'b1;
    end
endtask //reset



///////////////////////////////////////////
// --------  Single Read Transfer  --------
///////////////////////////////////////////
`ifdef Single_Read

    initial begin
        $dumpfile("Single_Read.vcd");
        $dumpvars;
    end

    initial begin

        // RESET THE SYSTEM
        reset();

        #CLK_PER;


        @(negedge H_CLK_tb) begin
            
            H_WRITE_tb    = 1'b0;
            H_SEL_APB_tb  = 1'b1;
            H_TRANS_tb    = 2'b01;
            H_ADDR_tb     = 32'h32;
        
        end

        #(CLK_PER*2);

        @(negedge H_CLK_tb) begin
            
            H_WRITE_tb    = 1'bx;
            H_SEL_APB_tb  = 1'b0;
            H_TRANS_tb    = 2'bxx;
            H_ADDR_tb     = 32'hx;
        
        end
        
        #(CLK_PER/2) P_RDATA_tb = $random;

        #(CLK_PER/2);
        assert (H_RDATA_tb == P_RDATA_tb) begin
            $display("Test Passed !\nRead Transfer is Done Successfully !");
            $display("P_RDATA = %h \t \t H_RDATA = %h \n", P_RDATA_tb, H_RDATA_tb);
        end
        else $error("%m: \t\t H_RDATA_tb does not equal to P_RDATA_tb ! \t\t\t Wrong Data = %h\t\t Expected Data = %h",H_RDATA_tb, P_RDATA_tb);
        
        #20 $stop;

    end

`endif


////////////////////////////////////////////
// --------  Single Write Transfer  --------
////////////////////////////////////////////

`ifdef Single_Write

    initial
    begin
        $dumpfile("Single_Write.vcd");
        $dumpvars;
    end

    initial begin


        // RESET THE SYSTEM
        reset();

        #CLK_PER;

        @(negedge H_CLK_tb) begin
        
            H_WRITE_tb    = 1'b1;
            H_SEL_APB_tb  = 1'b1;
            H_TRANS_tb    = 2'b11;
            H_ADDR_tb     = 32'hA0F;
        
        end

        #(CLK_PER*2);

        @(negedge H_CLK_tb) begin
            
            H_WRITE_tb    = 1'b1;
            H_SEL_APB_tb  = 1'b0;
            H_TRANS_tb    = 2'bxx;
            H_ADDR_tb     = 32'hxx;
        
        end

        #(CLK_PER/2) H_WDATA_tb = $random;

        @(posedge P_WRITE_tb);
            assert (P_WDATA_tb == H_WDATA_tb) begin
                $display(" TEST PASSED ! \t Successful Single Data Write Transfer !");
            end
            else   $display("ERROR ! \t Write Test Failed !\n");

        #20 $stop;
    end

`endif 




//////////////////////////////////////////
// --------  Burst Read Transfer  --------
//////////////////////////////////////////
`ifdef Burst_Read

    initial begin
        $dumpfile("Burst_Read.vcd");
        $dumpvars;
    end

    initial begin

        // RESET THE SYSTEM
        reset();

        #CLK_PER;


        @(negedge H_CLK_tb) begin
            
            H_WRITE_tb    = 1'b0;
            H_SEL_APB_tb  = 1'b1;
            H_TRANS_tb    = 2'b10;
            H_ADDR_tb     = 32'h0;
        
        end


        @(negedge H_CLK_tb) begin
            
            H_TRANS_tb    = 2'b11;
            H_ADDR_tb     = 32'h4;
        
        end
        

        @(negedge H_CLK_tb) begin

            for (int i = 0; i < 5 ; i++ ) begin
                
                #(CLK_PER*2);
                H_ADDR_tb  = $random;
                P_RDATA_tb = $random;
                @(posedge P_ENABLE_tb)
                assert (H_RDATA_tb == P_RDATA_tb) begin
                    $display("Test Passed !\nRead Transfer is Done Successfully !");
                    $display("P_RDATA = %h \t \t H_RDATA = %h \n", P_RDATA_tb, H_RDATA_tb);
                end
                else $error("%m: \t\t H_RDATA_tb does not equal to P_RDATA_tb ! \t\t\t Wrong Data = %h\t\t Expected Data = %h",H_RDATA_tb, P_RDATA_tb);
                
            end

        end


        #20 $stop;

    end

`endif


/////////////////////////////////////////////
// --------   Burst Write Transfer   --------
/////////////////////////////////////////////

`ifdef Burst_Write

    initial
    begin
        $dumpfile("Burst_Write.vcd");
        $dumpvars;
    end

    initial begin


        // RESET THE SYSTEM
        reset();

        #CLK_PER;

        @(negedge H_CLK_tb) begin
        
            H_WRITE_tb    = 1'b1;
            H_SEL_APB_tb  = 1'b1;
            H_TRANS_tb    = 2'b10;
            H_ADDR_tb     = 32'h0;
        
        end

        @(negedge H_CLK_tb) begin
        
            H_TRANS_tb    = 2'b11;
            H_ADDR_tb     = 32'h3;
        
        end
    
        @(negedge H_CLK_tb)
         H_WDATA_tb = $random;
         H_ADDR_tb  = $random;
         #(CLK_PER*2)
         assert (P_WDATA_tb == H_WDATA_tb) begin
                $display(" TEST PASSED ! \t Successful Data Write Transfer !");
            end
            else   $display("ERROR ! \t Write Test Failed !\n");

        #(CLK_PER*2)
         H_WDATA_tb = $random;
         H_ADDR_tb  = $random;
         #(CLK_PER*2)
         assert (P_WDATA_tb == H_WDATA_tb) begin
                $display(" TEST PASSED ! \t Successful Data Write Transfer !");
            end
            else   $display("ERROR ! \t Write Test Failed !\n");

        #(CLK_PER*2)
         H_WDATA_tb = $random;
         H_ADDR_tb  = $random;
         #(CLK_PER*2)
         assert (P_WDATA_tb == H_WDATA_tb) begin
                $display(" TEST PASSED ! \t Successful Data Write Transfer !");
            end
            else   $display("ERROR ! \t Write Test Failed !\n");

        #(CLK_PER*2);
        @(negedge H_CLK_tb) begin
            
            H_WRITE_tb    = 1'bx;
            H_SEL_APB_tb  = 1'bx;
            H_TRANS_tb    = 2'bxx;
            H_ADDR_tb     = 32'hxx;
        
        end

        #20 $stop;
    end


`endif 

endmodule
