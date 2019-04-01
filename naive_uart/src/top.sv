module top(
    input wire clk_in,
    input wire rst_n,

    input wire uart_rxd,
    output reg uart_txd,

    output reg[3:0] led
);

	parameter CLK_HZ = 50_000_000;
	parameter BIT_RATE = 115200;

	wire rst;
	assign rst = !rst_n;
	
	wire uart_tx_busy;
	reg uart_tx_en;
	reg [8-1:0] uart_tx_data;

	wire uart_rx_break;
	wire uart_rx_valid;
	wire uart_rx_en;
	wire [8-1:0] uart_rx_data;

	wire uart_fifo_we;
	wire [8-1:0] uart_fifo_di;
	wire uart_fifo_re;
	wire [8-1:0] uart_fifo_do;
	wire uart_fifo_empty_flag;
	wire uart_fifo_full_flag;
	
	assign uart_rx_en = !uart_fifo_full_flag;
	assign uart_fifo_we = uart_rx_en && uart_rx_valid;
	assign uart_fifo_di = uart_rx_data;

	//assign uart_tx_data = uart_fifo_do;
	assign uart_fifo_re = !uart_tx_busy && !uart_fifo_empty_flag;
	
	always begin
		// not just echo, shift by one
		uart_tx_data <= uart_fifo_do + 1'b1;
	end

	always @ (posedge clk_in) begin
		uart_tx_en <= uart_fifo_re;
	end

	uart_rx #(
	.BIT_RATE(BIT_RATE),
	.CLK_HZ(CLK_HZ)
	) i_uart_rx(
	.clk          (clk_in          ), // Top level system clock input.
	.resetn       (rst_n         ), // Asynchronous active low reset.
	.uart_rxd     (uart_rxd     ), // UART Recieve pin.
	.uart_rx_en   (uart_rx_en   ), // Recieve enable
	.uart_rx_break(uart_rx_break), // Did we get a BREAK message?
	.uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
	.uart_rx_data (uart_rx_data )  // The recieved data.
	);
	
	uart_tx #(
	.BIT_RATE(BIT_RATE),
	.CLK_HZ  (CLK_HZ  )
	) i_uart_tx(
	.clk          (clk_in       ),
	.resetn       (rst_n         ),
	.uart_txd     (uart_txd     ),
	.uart_tx_en   (uart_tx_en   ),
	.uart_tx_busy (uart_tx_busy ),
	.uart_tx_data (uart_tx_data ) 
	);

	uart_fifo i_uart_fifo(
		.WrClk(clk_in),
		.RdClk(clk_in),
		.WrReset(rst),
		.RdReset(rst),
		.WrEn(uart_fifo_we),
		.Data(uart_fifo_di),
		.RdEn(uart_fifo_re),
		.Q(uart_fifo_do),
		.Empty(uart_fifo_empty_flag),
		.Full(uart_fifo_full_flag)
	);

	reg[31:0]         clk_cnt;

	always @(posedge clk_in)
	begin
  	if(~rst_n)
		clk_cnt <= 0;
	else if(clk_cnt < 50000001)
		clk_cnt <= clk_cnt + 1;
	else
		clk_cnt <= 0;
	end

	always @(posedge clk_in)
	begin
		if(~rst_n)
			led[0] <= 1'b0;
		else if(clk_cnt > 50000000)
			led[0] <= ~led[0];
	end

endmodule
