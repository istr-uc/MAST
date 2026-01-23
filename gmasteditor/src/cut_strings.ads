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



with Ada.Text_IO;                     use Ada;


package Cut_Strings is


   -- Cut returns a max_chars of characters in name.
   -- If name has more characters of those shown, is indicated by writing the
   -- character "~" at the end of the string.
   -- Arguments: name , max_chars (maximum length in characters)

   function Cut (name: String; max_chars: Integer) return String;


   -- Next Cut returns "name: mast_type_long" if the sum of
   -- characters name and mast_type_long don't exceeds of max_chars.
   -- Else it calls the previous function to cut "name",
   -- returns "name~: mast_type_short"
   -- Arguments: name , mast_type_long (type of MAST object, long),
   -- mast_type_short (type of MAST object, short),
   -- and max_chars (maximum length in characters)

   function Cut (name: String;
                 mast_type_long: String;
                 mast_type_short: String;
                 max_chars: Integer)

                return String;

end Cut_Strings;

