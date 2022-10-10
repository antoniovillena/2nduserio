module acia (
	// cpu register interface
	input clk,
	input E,
	input reset,
	input [7:0] din,
	input sel,
	input rs,
	input rw,
	output reg [7:0] dout,
	output irq,

	output tx,
	input rx,

	// parallel data out strobe to io controller
	output dout_strobe
);

reg E_d;
always @(posedge clk) E_d <= E;
wire clk_en = ~E_d & E;

assign dout_strobe = clk_en && sel && ~rw && rs;

// the control register
reg [7:0] serial_cr;
 
assign irq = serial_irq;

// ---------------- CPU read interface ------------

always @(sel, rw, rs, serial_status, serial_rx_data) begin
	dout = 8'h00;

	if(sel && rw) begin
		if(~rs) dout = serial_status;
		if( rs) dout = serial_rx_data;
	end
end

// ------------------------------ serial UART ---------------------------------
wire serial_irq = (serial_cr[7] && serial_rx_data_available) ||    // rx irq
	((serial_cr[6:5] == 2'b01) && serial_tx_empty);               // tx irq

wire [7:0] serial_status = { serial_irq, 1'b0 /* parity err */, serial_rx_overrun, serial_rx_frame_error,
									2'b00 /* CTS & DCD */, serial_tx_empty, serial_rx_data_available};

// implemented bitrates:
// - 500kHz/64 = 7812.5 bps (ST iKBD)
// - 500kHz/16 = 31250 bps  (ST MIDI)
// only 8N1 framing

// 32MHz/4096 = 7812.5Hz
reg [11:0] serial_clk;
always @(posedge clk)
	serial_clk <= serial_clk + 1'd1;

// --------------------------- serial receiver -----------------------------
reg [7:0] serial_rx_cnt;         // bit + sub-bit counter
reg [7:0] serial_rx_shift_reg;   // shift register used during reception
reg [7:0] serial_rx_data;  
reg [3:0] serial_rx_filter;      // filter to reduce noise
reg serial_rx_frame_error;
reg serial_rx_overrun;
reg serial_rx_data_available;
reg serial_in_filtered;

always @(posedge clk) begin
	if(reset) begin
		serial_rx_cnt <= 8'd0;
		serial_rx_data_available <= 1'b0;
		serial_rx_filter <= 4'b1111;
		serial_in_filtered <= 1'b1;
		serial_rx_overrun <= 1'b0;
		serial_rx_frame_error <= 1'b0;
	end else begin
	
		// read on serial data register
		if(clk_en && sel && rw && rs) begin
			serial_rx_data_available <= 1'b0;   // read on serial data clears rx status
			serial_rx_overrun <= 1'b0;
		end

		// serial acia master reset
		if(serial_cr[1:0] == 2'b11) begin
			serial_rx_cnt <= 8'd0;
			serial_rx_data_available <= 1'b0;
			serial_rx_filter <= 4'b1111;
			serial_rx_overrun <= 1'b0;
			serial_rx_frame_error <= 1'b0;
		end

		serial_rx_filter <= { serial_rx_filter[2:0], rx};
		
		// serial input must be stable for 4 cycles to change state
		if(serial_rx_filter == 4'b0000) serial_in_filtered <= 1'b0;
		if(serial_rx_filter == 4'b1111) serial_in_filtered <= 1'b1;
			
		// 16 times serial clock
		if((serial_cr[1:0] == 2'b01 && serial_clk[5:0] == 6'd0) || // 31250 bps
		   (serial_cr[1:0] == 2'b10 && serial_clk[7:0] == 8'd0))   // 7812.5 bps
		begin
			// receiver not running
			if(serial_rx_cnt == 8'd0) begin
				// seeing start bit?
				if(serial_in_filtered == 1'b0) begin
					// expecing 10 bits starting half a bit time from now
					serial_rx_cnt <= { 4'd9, 4'd7 };
				end
			end else begin
				// receiver is running
				serial_rx_cnt <= serial_rx_cnt - 8'd1;

			   // received a bit
				if(serial_rx_cnt[3:0] == 4'd0) begin
					// in the middle of the bit -> shift new bit into msb
					serial_rx_shift_reg <= { serial_in_filtered, serial_rx_shift_reg[7:1] };
				end

				// receiving last (stop) bit
				if(serial_rx_cnt[7:0] == 8'd1) begin
					if(serial_in_filtered == 1'b1) begin
						if (serial_rx_data_available)
							// previous data still not read? report overrun
							serial_rx_overrun <= 1'b1;
						else
							// copy data into rx register 
							serial_rx_data <= serial_rx_shift_reg;  // pure data w/o start and stop bits
						serial_rx_data_available <= 1'b1;
						serial_rx_frame_error <= 1'b0;
					end else
						// report frame error via status register
						serial_rx_frame_error <= 1'b1;

				end
			end
		end
	end
end   

// --------------------------- serial transmitter -----------------------------
assign tx = serial_tx_empty ? 1'b1: serial_tx_shift_reg[0];
reg serial_tx_empty;
reg [7:0] serial_tx_cnt;
reg [7:0] serial_tx_data;
reg serial_tx_data_valid;
reg [10:0] serial_tx_shift_reg;

always @(posedge clk) begin

	// 16 times serial clock
	if((serial_cr[1:0] == 2'b01 && serial_clk[5:0] == 6'd0) || // 31250 bps
	   (serial_cr[1:0] == 2'b10 && serial_clk[7:0] == 8'd0))   // 7812.5 bps
	begin
		if(serial_tx_cnt[3:0] == 4'h0) begin
			// shift down one bit, fill with 1 bits
			serial_tx_shift_reg <= { 1'b1, serial_tx_shift_reg[10:1] };
		end

		// decrease transmit counter
		if(serial_tx_cnt != 8'd0) begin
			serial_tx_cnt <= serial_tx_cnt - 8'd1;
			if(serial_tx_cnt == 1)
				serial_tx_empty <= 1'b1;
		end

		// restart immediately if another byte is in tx buffer 
		if((serial_tx_cnt == 8'd1) && serial_tx_data_valid) begin
			serial_tx_shift_reg <= { 1'b1, serial_tx_data, 1'b0, 1'b1 };  // 8N1, lsb first
			serial_tx_cnt <= { 4'd10, 4'd1 };   // 10 bits to go
			serial_tx_data_valid <= 1'b0;
			serial_tx_empty <= 1'b0;
		end
	end

	if(reset) begin
		serial_tx_cnt <= 8'd0;
		serial_tx_empty <= 1'b1;
		serial_tx_data_valid <= 1'b0;
		serial_tx_shift_reg[0] <= 1'b1;
	end else if(clk_en && sel && ~rw) begin

		// write to serial control register
		if(~rs) begin
			serial_cr <= din;
			if (din[1:0] == 2'b11) begin
				serial_tx_cnt <= 8'd0;
				serial_tx_empty <= 1'b1;
				serial_tx_data_valid <= 1'b0;
				serial_tx_shift_reg[0] <= 1'b1;
			end
		end

		// write to serial data register
		if(rs) begin
			if(serial_tx_cnt == 8'd0) begin
				// transmitter idle? start immediately ...
				serial_tx_shift_reg <= { 1'b1, din, 1'b0, 1'b1 };  // 8N1, lsb first
				serial_tx_cnt <= { 4'd10, 4'd1 };   // 10 bits to go
				serial_tx_empty <= 1'b0;
			end else begin
				// ... otherwise store in data buffer
				serial_tx_data <= din;
				serial_tx_data_valid <= 1'b1;
			end
		end
	end
end

endmodule
