/////////////////////////////////////////////////////////////////////////////////////////////
//
//    AMBA Advanced High-Performance Bus to AMPA Advanced Peripheral Bus Bridge TEST Bench 
//
//    Author: Mahmoud Magdi 
//
/////////////////////////////////////////////////////////////////////////////////////////////


module AHB_TO_APB_BRIDGE_tb #(

    parameter DATA_WIDTH = 32,
	          ADDR_WIDTH = 32,
              TRAN_WIDTH = 3,
              CLK_PER    = 10

) (

);

logic                       H_CLK_tb       ;
logic                       H_RESET_n_tb   ;
logic                       H_WRITE_tb     ;
logic                       H_SEL_APB_tb   ;
logic                       H_READY_IN_tb  ;
logic [TRAN_WIDTH - 1 : 0]  H_TRANS_tb     ;
logic [DATA_WIDTH - 1 : 0]  H_WDATA_tb     ;
logic [DATA_WIDTH - 1 : 0]  H_ADDR_tb      ;
logic [DATA_WIDTH - 1 : 0]  P_RDATA_tb     ;

logic                       H_RESP_tb      ;
logic                       H_READY_OUT_tb ;
logic                       P_ENABLE_tb    ;
logic                       P_WRITE_tb     ;
logic                       P_SELx_tb      ;
logic [DATA_WIDTH - 1 : 0]  P_WDATA_tb     ;
logic [DATA_WIDTH - 1 : 0]  P_ADDR_tb      ;
logic [DATA_WIDTH - 1 : 0]  H_RDATA_tb     ;



// Clock Genreation 
always begin
    #(CLK_PER/2) H_CLK_tb = ~H_CLK_tb;
end 


// Initialization 
initial begin

    H_CLK_tb      = 1'b0;
    H_RESET_n_tb  = 'bx;
    H_WRITE_tb    = 'bx;
    H_SEL_APB_tb  = 'bx;
    H_READY_IN_tb = 'bx;
    H_TRANS_tb    = 'bx;


    #(CLK_PER-2) 
    H_RESET_n_tb   = 'b0;
    H_WRITE_tb     = 'b0;
    H_SEL_APB_tb   = 'b0;
    H_READY_IN_tb  = 'b0;
    H_TRANS_tb     = 'b0; 


    #(CLK_PER) H_RESET_n_tb = 'b1;


    #(CLK_PER*5)
    for (int i = 0; i < 200; i++ ) begin
        H_WRITE_tb    = $random;
        H_SEL_APB_tb  = $random;
        H_READY_IN_tb = $random;
        H_TRANS_tb    = $random;
        H_WDATA_tb    = $random;
        H_ADDR_tb     = $random;
        P_RDATA_tb    = $random;
        #(CLK_PER/2);
    end

    #CLK_PER H_RESET_n_tb = 'b0;

    #(CLK_PER * 20) H_RESET_n_tb = 'b1;

    for (int i = 0; i < 30; i++ ) begin
        H_WRITE_tb    = $random;
        H_SEL_APB_tb  = $random;
        H_READY_IN_tb = $random;
        H_TRANS_tb    = $random;
        H_WDATA_tb    = $random;
        H_ADDR_tb     = $random;
        P_RDATA_tb    = $random;
        #(CLK_PER*3);
    end

    #100 $stop;

end





// DUT Instantiation
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
    .P_SELx     (P_SELx_tb     )  ,
    .P_WDATA    (P_WDATA_tb    )  ,
    .P_ADDR     (P_ADDR_tb     )  ,
    .H_RDATA    (H_RDATA_tb    )                
    
    
);


endmodule