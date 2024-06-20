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

with Glib; use Glib;
with Gtk.Radio_Button; use Gtk.Radio_Button;
with Gtk.Spin_Button; use Gtk.Spin_Button;
with Gtk.Label; use Gtk.Label;
with Gtk.Tooltip; use Gtk.Tooltip;

with Var_Strings; use Var_Strings;
with Pt_Editor_Pkg; use Pt_Editor_Pkg;
with pt_editor_Intl; use pt_editor_Intl;

with Ada.Directories; use Ada.Directories;
package body Global_Options is

   System_Name : Var_String:=Null_Var_String;
   System_Name_Is_Defined : Boolean:=False;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is

   begin
      Set_Policy(FP);
      Set_Context_Switch(0.0);
      Set_Timer_Jitter(0.0);
      Unset_System_Name;
   end Initialize;


   ----------------
   -- Get_Policy --
   ----------------

   function Get_Policy return Policy is
   begin
      if Get_Active(Pt_Editor.Edf_Radiobutton) then
         return EDF;
      else
         return FP;
      end if;
   end Get_Policy;

   ----------------
   -- Set_Policy --
   ----------------

   procedure Set_Policy (P : Policy) is
   begin
      case P is
         when FP  => Set_Active(Pt_Editor.Fixed_Prio_Radiobutton,True);
         when EDF => Set_Active(Pt_Editor.EDF_Radiobutton,True);
      end case;
   end Set_Policy;

   ------------------------
   -- Get_Context_Switch --
   ------------------------

   function Get_Context_Switch return Mast.Normalized_Execution_Time is
   begin
      return Mast.Normalized_Execution_Time
        (Pt_Editor.Cswitch_Spinbutton.Get_Value);
   end Get_Context_Switch;

   ------------------------
   -- Set_Context_Switch --
   ------------------------

   procedure Set_Context_Switch (Cs : Mast.Normalized_Execution_Time) is
   begin
      Pt_Editor.Cswitch_Spinbutton.Set_Value(GDouble(Cs));
   end Set_Context_Switch;

   ----------------------
   -- Get_Timer_Jitter --
   ----------------------

   function Get_Timer_Jitter return Mast.Time is
   begin
      return Mast.Time(Pt_Editor.Ticker_Spinbutton.Get_Value);
   end Get_Timer_Jitter;

   ----------------------
   -- Set_Timer_Jitter --
   ----------------------

   procedure Set_Timer_Jitter (J : Mast.Time) is
   begin
      Pt_Editor.Ticker_Spinbutton.Set_Value(GDouble(J));
   end Set_Timer_Jitter;

   ---------------------
   -- Get_System_Name --
   ---------------------

   function Get_System_Name return String is
   begin
      return To_String(System_Name);
   end Get_System_Name;

   ---------------------
   -- Set_System_Name --
   ---------------------

   procedure Set_System_Name (Name : String) is
   begin
      if Name/="" then
         System_Name:=To_Var_String(Name);
         System_Name_Is_Defined:=True;
         Set_Text(Pt_Editor.Label9,-Simple_Name(Name));
         Set_Title(Pt_Editor,"MAST Periodic Task Editor: "&Simple_Name(Name));
         Pt_Editor.Label9.Set_Tooltip_Text(Name);
         Set_Title(Pt_Editor,"MAST Periodic Task Editor: "&Simple_Name(Name));
      end if;
   end Set_System_Name;

   ----------------------------
   -- Is_System_Name_Defined --
   ----------------------------

   function Is_System_Name_Defined return Boolean is
   begin
      return System_Name_Is_Defined;
   end Is_System_Name_Defined;

   -----------------------
   -- Unset_System_Name --
   -----------------------

   procedure Unset_System_Name is
   begin
      System_Name_Is_Defined:=False;
      System_Name:=Null_Var_String;
      Set_Text(Pt_Editor.Label9,-"");
      Pt_Editor.Label9.Set_Tooltip_Text("System name undefined");
      Set_Title(Pt_Editor,"MAST Periodic Task Editor");
   end Unset_System_Name;

end Global_Options;
