-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                           GMastEditor                             --
--          Graphical Editor for Modelling and Analysis              --
--                    of Real-Time Applications                      --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors : Michael Gonzalez                                        --
--           Felisa Hidalgo                                          --
--                                                                   --
-- Contact info: Michael Gonzalez       mgh@unican.es                --
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


with Ada;                        use Ada;
with Ada.Text_IO;                use Ada.Text_IO;
with Ada.Characters.Handling;    use Ada.Characters.Handling;
with Ada.Characters.Latin_1;     use Ada.Characters.Latin_1;

with Ada.Strings.Unbounded;      use Ada.Strings.Unbounded;

with Ada.Strings.Bounded;        use Ada.Strings.Bounded;
with Ada.Strings.Maps;           use Ada.Strings.Maps;
with Ada.Characters.Handling;    use Ada.Characters.Handling;


with glib.unicode;              use  glib.unicode;

with Ada.Strings;               use Ada.Strings;


package body Cut_Strings is


   function Cut (name: String; max_chars: integer) return string is

   begin

      if Name'Length> max_chars then
         return name(Name'First..Name'First+Max_Chars-1) & TILDE;
      else
         return name;
      end if;

   end Cut;



   function Cut (name: String;
                 mast_type_long: String;
                 mast_type_short: String;
                 max_chars: Integer) return String is

   begin

      if Name'Length + 1 + mast_type_long'length <= max_chars then

         return name & ": " & mast_type_long;
      else
         return cut (name, max_chars - mast_type_short'length -1)
           & ":" & mast_type_short;

      end if;

   end Cut;

end Cut_Strings;
