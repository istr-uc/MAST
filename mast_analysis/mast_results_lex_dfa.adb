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

with mast_results_lex_dfa; use mast_results_lex_dfa; 
package body mast_results_lex_dfa is
function YYText return string is
    i : integer;
    str_loc : integer := 1;
    buffer : string(1..1024);
    EMPTY_STRING : constant string := "";
begin
    -- find end of buffer
    i := yytext_ptr;
    while ( yy_ch_buf(i) /= ASCII.NUL ) loop
    buffer(str_loc ) := yy_ch_buf(i);
        i := i + 1;
    str_loc := str_loc + 1;
    end loop;
--    return yy_ch_buf(yytext_ptr.. i - 1);

    if (str_loc < 2) then
        return EMPTY_STRING;
    else
      return buffer(1..str_loc-1);
    end if;

end;

-- returns the length of the matched text
function YYLength return integer is
begin
    return yy_cp - yy_bp;
end YYLength;

-- done after the current pattern has been matched and before the
-- corresponding action - sets up yytext

procedure YY_DO_BEFORE_ACTION is
begin
    yytext_ptr := yy_bp;
    yy_hold_char := yy_ch_buf(yy_cp);
    yy_ch_buf(yy_cp) := ASCII.NUL;
    yy_c_buf_p := yy_cp;
end YY_DO_BEFORE_ACTION;

end mast_results_lex_dfa;
