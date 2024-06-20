-----------------------------------------------------------------------
--                MAST Graphical Periodic Task Editor                --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 3 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, see                      --
-- <http://www.gnu.org/licenses/>.                                   --
--                                                                   --
-----------------------------------------------------------------------

package body Changes_Control is

   Changes_Since_Last_Save : Boolean:=False;
   Changes_Since_Last_Model : Boolean:=True;

   ----------------------------------
   -- Changes_Made_Since_Last_Save --
   ----------------------------------

   function Changes_Made_Since_Last_Save return Boolean is
   begin
      return Changes_Since_Last_Save;
   end Changes_Made_Since_Last_Save;

   ---------------------------------------------
   -- Changes_Made_Since_Last_Model_Generated --
   ---------------------------------------------

   function Changes_Made_Since_Last_Model_Generated return Boolean is
   begin
      return Changes_Since_Last_Model;
   end Changes_Made_Since_Last_Model_Generated;

   ---------------------
   -- Change_Was_Made --
   ---------------------

   procedure Change_Was_Made is
   begin
      Changes_Since_Last_Model:=True;
      Changes_Since_Last_Save:=True;
   end Change_Was_Made;

   -------------------------
   -- Save_Operation_Made --
   -------------------------

   procedure Save_Operation_Made is
   begin
      Changes_Since_Last_Save:=False;
   end Save_Operation_Made;

   ---------------------
   -- Model_Generated --
   ---------------------

   procedure Model_Generated is
   begin
      Changes_Since_Last_Model:=False;
   end Model_Generated;

   -----------
   -- Reset --
   -----------

   procedure Reset is
   begin
      Changes_Since_Last_Model:=True;
      Changes_Since_Last_Save:=False;
   end Reset;



end Changes_Control;
