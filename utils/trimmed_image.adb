-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2000-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--          Jose Javier Gutierrez  gutierjj@unican.es                --
--          Jose Carlos Palencia   palencij@unican.es                --
--          Jose Maria Drake       drakej@unican.es                  --
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
with  Ada.Text_IO, Ada.Strings.Fixed, Ada.Float_Text_IO;

package body trimmed_image is


   function img (Number : Integer) return String is
   begin
      return Ada.Strings.Fixed.Trim(Number'Img,Ada.Strings.Left);
   end img;


   function img (Number : Float; Decimals : Natural := 1) return String is
      temp : string(1..50);
   begin
      Ada.Float_Text_IO.Put(To   => temp,
                            Item => Number,
                            Aft  => Decimals,
                            Exp  => 0);
      return Ada.Strings.Fixed.Trim(temp,Ada.Strings.Left);
   end img;


   function img (Number : Time; Decimals : Natural := 1) return String is
      temp : string(1..50);
   begin
      Ada.Float_Text_IO.Put(To   => temp,
                            Item => Float(Number),
                            Aft  => Decimals,
                            Exp  => 0);
      return Ada.Strings.Fixed.Trim(temp,Ada.Strings.Left);
   end img;


end trimmed_image;
