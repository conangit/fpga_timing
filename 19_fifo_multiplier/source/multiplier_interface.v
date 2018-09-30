module multiplier_interface(
    input clk,
    input rst_n,
    
    input write_req,
    input [15:0]fifo_write_data,
    output [2:0]left_sig,           //给调用此模块往FIFO写入数据的模块使用
    
    output [15:0]product
    );
    
    
    /***********************/
    
    reg isRead;
    wire [15:0]fifo_read_data;
    
    fifo_module_2 u1(
        .clk(clk),
        .rst_n(rst_n),
        .write_req(write_req),
        .fifo_write_data(fifo_write_data),
        .read_req(isRead),
        .fifo_read_data(fifo_read_data),
        .left_sig(left_sig)
    );
    
    pipeline_lut_multiplier_module u2(
        .clk(clk),
        .rst_n(rst_n),
        .a(fifo_read_data[15:8]),
        .b(fifo_read_data[7:0]),
        .product(product)
    );
    
    reg [2:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            i <= 3'd0;
            isRead <= 1'b0;
        end
        else
            case(i)
            
                0:
                if(left_sig <= 3) begin //剩余3个 还有一个数据可取
                    isRead <= 1'b1;
                    i <= i + 1'b1;
                end
                
                1:
                begin
                    isRead <= 1'b0; //取出一个数据
                    i <= i + 1'b1;
                end
                
                2: //对该数据进行处理 (由于使用pipeline结构 舍去了start_sig和done_sig 不然可使用这两个信号来沟通数据的处理过程)
                begin
                    i <= 3'd0;
                end
            
            endcase
    end
    
endmodule

