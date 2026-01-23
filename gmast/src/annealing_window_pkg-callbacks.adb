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
with Error_Window_Pkg; use Error_Window_Pkg;
with Help_Annealing_Pkg; use Help_Annealing_Pkg;
with Mast.Annealing_Parameters;
with Mast.Sched_Param_Assignment_Parameters;
with Parameters_Handling;

package body Annealing_Window_Pkg.Callbacks is

   use Gtk.Arguments;

   ---------------------------
   -- On_Set_Button_Clicked --
   ---------------------------

   procedure On_Set_Button_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
      type Check_State is (M_Iter, O_Iter);
   begin
      declare
         Max_Iter : String:=Get_Text(Annealing_Window.Entry_Max_Iterations);
         Max_Iterations : Mast.Annealing_Parameters.Iteration_Type;
         Over_Iter : String:=Get_Text(Annealing_Window.Entry_Iterations_To_Op);
         Overiterations : Mast.Annealing_Parameters.Iteration_Type;
         State : Check_State :=M_Iter;
      begin
         Max_Iterations:=Mast.Annealing_Parameters.Iteration_Type'Value
           (Max_Iter);
         State:=O_Iter;
         Overiterations:=Mast.Annealing_Parameters.Iteration_Type'Value
           (Over_Iter);
         Mast.Annealing_Parameters.Set_Max_Iterations(Max_Iterations);
         Mast.Annealing_Parameters.Set_Overiterations(Overiterations);
         Mast.Sched_Param_Assignment_Parameters.Store_Parameters;
         Destroy(Annealing_Window);
      exception
         when Constraint_Error =>
            Gtk_New (Error_Window);
            Set_Position(Error_Window,Win_Pos_Mouse);
            Show_All (Error_Window);
            case State is
               when M_Iter =>
                  Set_Text(Error_Window.Label_Error,
                          "Format Error in Max Iterations");
               when O_Iter =>
                  Set_Text(Error_Window.Label_Error,
                           "Format Error in Optimization Iterations");
            end case;
            Set_Modal(Error_Window,True);
      end;
   end On_Set_Button_Clicked;

   -------------------------------
   -- On_Default_Button_Clicked --
   -------------------------------

   procedure On_Default_Button_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Mast.Annealing_Parameters.Load_Default_Parameters;
      Parameters_Handling.Load_Annealing;
   end On_Default_Button_Clicked;

   --------------------------------
   -- On_Ann_Help_Button_Clicked --
   --------------------------------

   procedure On_Ann_Help_Button_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Gtk_New (Help_Annealing);
      Show_All (Help_Annealing);
   end On_Ann_Help_Button_Clicked;

   ------------------------------
   -- On_Cancel_Button_Clicked --
   ------------------------------

   procedure On_Cancel_Button_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Destroy(Annealing_Window);
   end On_Cancel_Button_Clicked;

end Annealing_Window_Pkg.Callbacks;
