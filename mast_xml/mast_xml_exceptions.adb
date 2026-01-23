-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2003-2008                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez          mgh@unican.es                  --
--          Jose Javier Gutierrez     gutierjj@unican.es             --
--          Jose Carlos Palencia      palencij@unican.es             --
--          Jose Maria Drake          drakej@unican.es               --
--          Patricia Lopez Martinez   lopezpa@unican.es              --
--          Yago Pereiro Estevan                                     --
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
with Ada.Text_IO,Var_Strings,Indexed_Lists;
use Ada.Text_IO,Var_Strings;

package body Mast_XML_Exceptions is

   package Error_Lists is new Indexed_Lists(Var_String,"=");

   List : Error_Lists.List;

   ------------------
   -- Parser_Error --
   ------------------

   procedure Parser_Error (S : String) is
   begin
      Error_Lists.Add(To_Var_String(S),List);
   end Parser_Error;

   ------------------
   -- Clear_Errors --
   ------------------

   procedure Clear_Errors is
      Empty_List : Error_Lists.List;
   begin
      List:=Empty_List;
   end Clear_Errors;

   -----------------
   -- Report_Errors --
   -----------------

   procedure Report_Errors is
      Ind : Error_Lists.Index;
      Msg : Var_String;
   begin
      if Error_Lists.Size(List)>0 then
         Put_Line("Parser errors: ");
         New_Line;
         Error_Lists.Rewind(List,Ind);
         for I in 1..Error_Lists.Size(List) loop
            Error_Lists.Get_Next_Item(Msg,List,Ind);
            Put_Line(Msg);
         end loop;
         raise Parser_Detected_Error;
      end if;
   end Report_Errors;

end Mast_XML_Exceptions;
