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
--          Yago Pereiro                                             --
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
with System; use System;
with Glib; use Glib;
with Gdk.Event; use Gdk.Event;
with Gdk.Types; use Gdk.Types;
with Gtk.Accel_Group; use Gtk.Accel_Group;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Style; use Gtk.Style;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Gentry; use Gtk.Gentry;
with Mast.Transactions;
with Mast_Actions;
with Draw_Timing_Results;
with Clear_Timing_Results;
with Var_Strings; use Var_Strings;

package body Dialog_Event_Pkg.Callbacks is

   use Gtk.Arguments;

   --------------------------------
   -- On_Button_Close_Tr_Clicked --
   --------------------------------

   procedure On_Button_Close_Tr_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Set_Modal(Dialog_Event,False);
      Destroy(Dialog_Event);
   end On_Button_Close_Tr_Clicked;

   -------------------------------------
   -- On_Combo_Tr_Transaction_Changed --
   -------------------------------------

   procedure On_Combo_Tr_Transaction_Changed
     (Object : access Gtk_Combo_Box_Text_Record'Class)
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Mast.Transactions.Lists.Index;
   begin
      Clear_Timing_Results;
      declare
         Trans_Name : String:=
	   Get_Active_Text(Dialog_Event.Combo_Tr_Transaction);
      begin
         if Trans_Name="<View All>" then
            Mast.Transactions.Lists.Rewind
              (Mast_Actions.The_System.Transactions,Iterator);
            for I in 1..Mast.Transactions.Lists.Size
              (Mast_Actions.The_System.Transactions)
            loop
               Mast.Transactions.Lists.Get_Next_Item
                 (Trans_Ref,Mast_Actions.The_System.Transactions,Iterator);
               Draw_Timing_Results
                 (To_String(Mast.Transactions.Name(Trans_Ref)));
            end loop;
         else
            Draw_Timing_Results
	      (Get_Active_Text(Dialog_Event.Combo_Tr_Transaction));
         end if;
      end;
   end On_Combo_Tr_Transaction_Changed;

   ---------------------------
   -- On_Button_All_Clicked --
   ---------------------------

   procedure On_Button_All_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Set_Active(Dialog_Event.Combo_Tr_Transaction,0);
   end On_Button_All_Clicked;

end Dialog_Event_Pkg.Callbacks;
