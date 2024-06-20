-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--          Jose Javier Gutierrez  gutierjj@unican.es                --
--          Jose Carlos Palencia   palencij@unican.es                --
--          Jose Maria Drake       drakej@unican.es                  --
--          Julio Luis Medina      medinajl@unican.es                --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-----------------------------------------------------------------------
package mast_lex_dfa is
aflex_debug : boolean := false;
yytext_ptr : integer; -- points to start of yytext in buffer

-- yy_ch_buf has to be 2 characters longer than YY_BUF_SIZE because we need
-- to put in 2 end-of-buffer characters (this is explained where it is
-- done) at the end of yy_ch_buf
YY_READ_BUF_SIZE : constant integer :=  8192;
YY_BUF_SIZE : constant integer := YY_READ_BUF_SIZE * 2; -- size of input buffer
type unbounded_character_array is array(integer range <>) of character;
subtype ch_buf_type is unbounded_character_array(0..YY_BUF_SIZE + 1);
yy_ch_buf : ch_buf_type;
yy_cp, yy_bp : integer;

-- yy_hold_char holds the character lost when yytext is formed
yy_hold_char : character;
yy_c_buf_p : integer;   -- points to current character in buffer

function YYText return string;
function YYLength return integer;
procedure YY_DO_BEFORE_ACTION;
--These variables are needed between calls to YYLex.
yy_init : boolean := true; -- do we need to initialize YYLex?
yy_start : integer := 0; -- current start state number
subtype yy_state_type is integer;
yy_last_accepting_state : yy_state_type;
yy_last_accepting_cpos : integer;
end mast_lex_dfa;
