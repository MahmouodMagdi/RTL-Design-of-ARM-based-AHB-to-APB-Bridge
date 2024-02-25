/////////////////////////////////////////////////////////////////////////////////////////////
//
//    AMBA Advanced High-Performance Bus to AMPA Advanced Peripheral Bus Bridge RTL Design
//
//    Author: Mahmoud Magdi 
//
/////////////////////////////////////////////////////////////////////////////////////////////


module AHP_to_APB_Bridge #(

    parameter DATA_WIDTH = 32,
	            ADDR_WIDTH = 32,
              TRAN_WIDTH = 3

) (

    input   logic                       H_CLK        ,
    input   logic                       H_RESET_n    ,
    input   logic                       H_WRITE      ,
    input   logic                       H_SEL_APB    , 
    input   logic                       H_READY_IN   ,
    input   logic [TRAN_WIDTH - 1 : 0]  H_TRANS      ,
    input   logic [DATA_WIDTH - 1 : 0]  H_WDATA      ,
    input   logic [DATA_WIDTH - 1 : 0]  H_ADDR       ,
    input   logic [DATA_WIDTH - 1 : 0]  P_RDATA      ,

    output  logic                       H_RESP       ,
    output  logic                       H_READY_OUT  ,
    output  logic                       P_ENABLE     ,
    output  logic                       P_WRITE      ,
    output  logic                       P_SELx       ,
    output  logic [DATA_WIDTH - 1 : 0]  P_WDATA      ,
    output  logic [DATA_WIDTH - 1 : 0]  P_ADDR       ,
    output  logic [DATA_WIDTH - 1 : 0]  H_RDATA                    
    
    
);

typedef enum logic [2:0] { 
    
                IDLE     ,
                READ     ,
                W_WAIT   ,
                WRITE    ,
                WRITEP   ,
                WENABLE  ,
                WENABLEP ,
                RENABLE 
                
                         } state;


state current_state, next_state;
logic valid, H_Write_Reg;
logic [ADDR_WIDTH - 1 : 0] ADDR_REG, DATA_REG;

/////////////////////////////////////////////////////////////////////////////////////////
// -------------------------             VALID LOGIC            -------------------------
/////////////////////////////////////////////////////////////////////////////////////////
always_comb begin : VALID_LOGIC
    
    if(H_SEL_APB == 1'b1 && (H_TRANS == 2'b01 || H_TRANS == 2'b11)) begin
        
        valid = 1'b1;

    end
    else begin
        
        valid = 1'b0;
    
    end

end


/////////////////////////////////////////////////////////////////////////////////////////
// -------------------------        Current State Logic         -------------------------
/////////////////////////////////////////////////////////////////////////////////////////

always_ff @( posedge H_CLK or negedge H_RESET_n ) begin : blockName
    
    if (!H_RESET_n) begin
        
        current_state <= IDLE;

    end else begin
        
        current_state <= next_state;

    end

end



/////////////////////////////////////////////////////////////////////////////////////////
// -------------------------          Next State Logic          -------------------------
/////////////////////////////////////////////////////////////////////////////////////////

always_comb begin : next_state_logic
    
    case (current_state)

        IDLE    :begin

            if (valid == 1'b0) begin

                next_state = IDLE;

            end else if( valid == 1'b1 && H_WRITE == 'b0 ) begin
                
                next_state = READ;

            end else if( valid == 1'b1 && H_WRITE == 'b1 ) begin
                
                next_state = W_WAIT;

            end

        end
        
        READ    :begin
            
            next_state = RENABLE;

        end
        
        W_WAIT   :begin
            
            if (valid == 1'b0) begin
                
                next_state = WRITE;

            end else begin
                
                next_state = WRITEP;

            end

        end
        
        WRITE   :begin

            if (valid == 1'b0) begin
                
                next_state = WENABLE;

            end else begin
                
                next_state = WENABLEP;

            end

        end
        
        WRITEP  :begin
            
            next_state = WENABLEP;

        end
        
        WENABLE  :begin
            if (valid == 1'b0) begin

                next_state = IDLE;

            end else if( valid == 1'b1 && H_WRITE == 1'b0 ) begin
                
                next_state = READ;
            
            end else if( valid == 1'b1 && H_WRITE == 1'b1 ) begin
                
                next_state = W_WAIT;

            end
        end

        WENABLEP :begin
            
            if (valid == 1'b0 && H_Write_Reg == 1'b1) begin
                
                next_state = WRITE;
            
            end else if(valid == 1'b1 && H_Write_Reg == 1'b1) begin

                next_state = WRITEP;

            end

        end
        
        RENABLE :begin

            if (valid == 1'b0) begin

                next_state = IDLE;
            
            end else if( valid == 1'b1 && H_WRITE == 1'b1 ) begin

                next_state = W_WAIT;

            end else if(valid == 1'b1 && H_WRITE == 1'b0) begin

                next_state = READ;

            end

        end

        default: next_state = current_state;

    endcase

end

/////////////////////////////////////////////////////////////////////////////////////////
// -----------------------        Synchronous Output Logic        -----------------------
/////////////////////////////////////////////////////////////////////////////////////////
always_ff @( posedge H_CLK or negedge H_RESET_n ) begin : Output_Logic
    
    if (!H_RESET_n) begin

        H_RESP      <= 'b0;
        H_READY_OUT <= 'b0;
        P_ENABLE    <= 'b0;
        P_WRITE     <= 'b0;
        P_SELx      <= 'b0;
        P_WDATA     <= 'b0;
        P_ADDR      <= 'b0;
        H_RDATA     <= 'b0;  

    end else begin

        case (current_state)

            IDLE     : begin

                P_SELx      <= 1'b0;
                P_ENABLE    <= 1'b0;
                H_READY_OUT <= 1'b1;

            end

            READ     : begin

                P_ADDR      <= H_ADDR;
                P_SELx      <= 1'b1;
                P_WRITE     <= 1'b0;
                P_ENABLE    <= 1'b0;
                H_READY_OUT <= 1'b0;

            end
            
            W_WAIT   : begin

                ADDR_REG    <= H_ADDR;
                H_Write_Reg <= H_WRITE;
                P_ENABLE    <= 1'b0;
                P_ENABLE    <= 1'b0;
                H_READY_OUT <= 1'b0;

            end
            
            WRITE    : begin

                P_ADDR      <= ADDR_REG;
                P_WDATA     <= H_WDATA;
                P_SELx      <= 1'b1;
                P_WRITE     <= 1'b1;
                P_ENABLE    <= 1'b0;
                H_READY_OUT <= 1'b0;

            end
            
            WRITEP   : begin

                P_ADDR      <= ADDR_REG;
                P_WDATA     <= H_WDATA;
                ADDR_REG    <= H_ADDR;
                H_Write_Reg <= H_WRITE;
                P_SELx      <= 1'b1;
                P_WRITE     <= 1'b1;
                P_ENABLE    <= 1'b0;
                H_READY_OUT <= 1'b0;

            end
            
            WENABLE  : begin

                P_ENABLE    <= 1'b1;
                H_READY_OUT <= 1'b1;
                
            end
            
            WENABLEP : begin

                P_ENABLE    <= 1'b1;
                H_READY_OUT <= 1'b1; 

            end
            
            RENABLE  : begin

                P_ENABLE    <= 1'b1;
                H_READY_OUT <= 1'b1;
                H_RDATA     <= P_RDATA;
                
            end 
            
            default: begin
                
                    H_RESP      <= 'b0;
                    H_READY_OUT <= 'b0;
                    P_ENABLE    <= 'b0;
                    P_WRITE     <= 'b0;
                    P_SELx      <= 'b0;
                    P_WDATA     <= 'b0;
                    P_ADDR      <= 'b0;
                    H_RDATA     <= 'b0;  

            end

        endcase
    end

end
    
endmodule
