`include "defines.sv"

class alu_transaction;
        rand bit ce, mode, cin;
        rand bit [`CMD_WIDTH-1:0] cmd;
        rand bit [1:0] inp_valid;
        rand bit [`DATA_WIDTH-1:0]opa, opb;
        logic [2*`DATA_WIDTH:0]res;
        logic oflow, cout, g, l, e, err;

        constraint ce_c {ce == 1;}
        constraint inp_valid_c {inp_valid inside {[0:3]};}
        constraint cmd_c {if(mode == 1) cmd inside {[0:10]};
                                else cmd inside {[0:13]};
                        }

        /*constraint range { opa inside {[0:(2**`DATA_WIDTH) - 1]};
                                opb inside {[0:(2**`DATA_WIDTH) - 1]};
                        }*/
        constraint value_a {opa dist{0:=20, 255:=20, 170:=20, 85:=20, [0:255]:/20};}
        constraint value_b {opb dist{0:=20, 255:=20, 170:=20, 85:=20, [0:255]:/20};}

        virtual function alu_transaction copy();
                copy = new();
                copy.ce = this.ce;
                copy.mode = this.mode;
                copy.cmd = this.cmd;
                copy.inp_valid = this.inp_valid;
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;
                copy.res = this.res;
                copy.cout = this.res;
                copy.oflow = this.oflow;
                copy.err = this.err;
                copy.e = this.e;
                copy.g = this.g;
                copy.l = this.l;
                return copy;
        endfunction
endclass

//logical operation with single inputs
class alu_transaction_1 extends alu_transaction;
        constraint mode_c {mode == 0;}
        constraint cmd_c {cmd inside {[6:11]};}
        constraint inp_valid_c {inp_valid == 2'b11;}

        virtual function alu_transaction_1 copy();
                copy = new();
                copy.ce = this.ce;
                copy.mode = this.mode;
                copy.cmd = this.cmd;
                copy.inp_valid = this.inp_valid;
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;
                copy.res = this.res;
                copy.cout = this.res;
                copy.oflow = this.oflow;
                copy.err = this.err;
                copy.e = this.e;
                copy.g = this.g;
                copy.l = this.l;
                return copy;
        endfunction
endclass

//arithmetic operation with single inputs
class alu_transaction_2 extends alu_transaction;
        constraint mode_c {mode == 1;}
        constraint cmd_c {cmd inside {[4:7]};}
        constraint inp_valid_c {inp_valid == 2'b11;}

        virtual function alu_transaction_2 copy();
                copy = new();
                copy.ce = this.ce;
                copy.mode = this.mode;
                copy.cmd = this.cmd;
                copy.inp_valid = this.inp_valid;
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;
                copy.res = this.res;
                copy.cout = this.res;
                copy.oflow = this.oflow;
                copy.err = this.err;
                copy.e = this.e;
                copy.g = this.g;
                copy.l = this.l;
                return copy;
        endfunction
endclass

//logical operation with two operands
class alu_transaction_3 extends alu_transaction;
        constraint mode_c{mode == 0;}
        constraint cmd_c {cmd inside {[0:6],12,13};}
        constraint inp_valid_c {inp_valid == 2'b11;}

        virtual function alu_transaction_3 copy();
                copy = new();
                copy.ce = this.ce;
                copy.mode = this.mode;
                copy.cmd = this.cmd;
                copy.inp_valid = this.inp_valid;
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;
                copy.res = this.res;
                copy.cout = this.res;
                copy.oflow = this.oflow;
                copy.err = this.err;
                copy.e = this.e;
                copy.g = this.g;
                copy.l = this.l;
                return copy;
        endfunction
endclass

//arithmetic operation with two operands
class alu_transaction_4 extends alu_transaction;
        constraint mode_c{mode == 1;}
        constraint cmd_c {cmd inside {[0:3], [8:10]};}
        constraint inp_valid_c {inp_valid == 2'b11;}

        virtual function alu_transaction_4 copy();
                copy = new();
                copy.ce = this.ce;
                copy.mode = this.mode;
                copy.cmd = this.cmd;
                copy.inp_valid = this.inp_valid;
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;
                copy.res = this.res;
                copy.cout = this.res;
                copy.oflow = this.oflow;
                copy.err = this.err;
                copy.e = this.e;
                copy.g = this.g;
                copy.l = this.l;
                return copy;
        endfunction
endclass
