`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:17:50 11/06/2016 
// Design Name: 
// Module Name:    memory_basepair 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module memory_basepair(clk,reference,reset,shortread,index,sequence);

input clk,reset;    
input [99:0] reference;
input [15:0] shortread;
output reg [19:0] sequence;   
reg[7:0] count=  0;
reg[7:0] countshortread = 0;
integer a_pointer,t_pointer,c_pointer,g_pointer,count_max=93,count_shortreadmax = 17;
reg done;
output reg[7:0] index;
reg start = 0;
integer i=0,j=0,k=0,l=0;   

  
reg [99:0] ref;
reg [15:0]short_read;

reg [15:0] mem_a [0:60];    
reg [15:0] mem_t [0:60];     
reg [15:0] mem_g [0:60];   
reg [15:0] mem_c [0:60];
reg [15:0] tempreg_a;   
reg [15:0] tempreg_t;
reg [15:0] tempreg_g;
reg [15:0] tempreg_c;


always@(posedge clk)
begin
if(reset)
begin
ref <= reference;
a_pointer<=0;t_pointer<=0;c_pointer<=0;g_pointer<=0;
short_read <= shortread;
tempreg_a=0;   
tempreg_t=0;
tempreg_g=0;
tempreg_c=0;

end
else
begin
	if (count<count_max)   
	begin
	
	  
	case(ref[count +: 2])
	2'b00:
	begin
	mem_a[a_pointer] <= {ref[count  +:8] , count};
	a_pointer <= a_pointer + 1;  
	end
	2'b10:
	begin  
	mem_c[c_pointer] <= {ref[count  +:8] , count};
	c_pointer <= c_pointer + 1;
	end
	2'b01:
	begin
	mem_g[g_pointer] <= {ref[count  +:8] , count};
	g_pointer <= g_pointer + 1;
	end
	default:
	begin
	mem_t[t_pointer] <= {ref[count  +:8] , count};
	t_pointer <= t_pointer + 1;
	end
	endcase
	count <= count + 2'b10;
	end
	else  
	begin
	count <= count;
	done <= 1'b1;
	
	end
end	
end  
   



always@(posedge clk)
	if (done == 1'b1)
	begin
	if(reset)
	begin
	index = 8'b00000000;
	sequence = 0;
	countshortread = 0;
	end
	else
	begin
	start <= 0;
	i = 0;
	j = 0;
	k = 0;
	l = 0;
	tempreg_a = 0;
	tempreg_t = 0;
	tempreg_g = 0;
	tempreg_c = 0;
	
		if (countshortread <count_shortreadmax)
		begin
		
		
		case(short_read[countshortread +: 2])
		
		2'b00:   
		begin
		for (  l = 0;l <61; l = l+1)
		begin
		tempreg_a = mem_a[l];
		if(short_read[countshortread +: 8]==tempreg_a[8 +:8])
		begin
		if(tempreg_a[7:0] - countshortread >= 0 & tempreg_a[7:0] - countshortread <= 80)
		index = tempreg_a[7:0] - countshortread;
		sequence = ref[index +: 20];
		start <= 1;
		end
		end
		end  
		
		
		2'b10:
		begin
		for (  i = 0;i <61; i = i+1)
		begin
		tempreg_c = mem_c[i];
		if(short_read[countshortread +: 8]==tempreg_c[8 +:8])
		begin
		if(tempreg_c[7:0] - countshortread >= 0 & tempreg_c[7:0] - countshortread <= 80)
		index = tempreg_c[7:0] - countshortread;
		sequence = ref[index +: 20];
		start <= 1;
		
		
		end
		end
		end  
		
		2'b01:
		begin
		for (  j = 0;j <61; j = j+1)
		begin
		tempreg_g = mem_g[j];
		if(short_read[countshortread +: 8]==tempreg_g[8 +:8])
		begin
		if(tempreg_g[7:0] - countshortread >= 0 & tempreg_g[7:0] - countshortread <=80)
		index = tempreg_g[7:0] - countshortread;
		sequence = ref[index +: 20];
		start <= 1;
		end
		end
		end
		
		default:
		begin
		for (  k = 0;k <61; k = k+1)
		begin  
		tempreg_t = mem_t[k];
		if(short_read[countshortread +: 8]==tempreg_t[8 +:8])
		begin
		if(tempreg_t[7:0] - countshortread >= 0 & tempreg_t[7:0] - countshortread <= 80)
		index = tempreg_t[7:0]- countshortread;
		sequence = ref[index +: 20];
		start <= 1;
		end	   
		end 
		end            
		   
endcase
countshortread <= countshortread + 2'b10;
end  
else
begin
countshortread <= countshortread ;
end   
end
end

endmodule
