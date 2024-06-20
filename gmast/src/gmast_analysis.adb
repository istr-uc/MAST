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

with Gtk; use Gtk;
with Gtk.Main;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Check_Button; use Gtk.Check_Button;
with Mast_Analysis_Pkg; use Mast_Analysis_Pkg;
with Error_Window_Pkg; use Error_Window_Pkg;
with Error_Inputfile_Pkg; use Error_Inputfile_Pkg;
with Read_Past_Values;
with Help_Pkg; use Help_Pkg;
with Annealing_Window_Pkg; use Annealing_Window_Pkg;
with Hopa_Window_Pkg; use Hopa_Window_Pkg;
with Help_Hopa_Pkg; use Help_Hopa_Pkg;
with Help_Annealing_Pkg; use Help_Annealing_Pkg;
with Gnat.Float_Control;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;

procedure Gmast_Analysis is
   Bad_Arguments : Boolean:=False;
begin
   Gtk.Main.Init;
   -- This is required because of a bug in some Windows 2000 drivers
   -- delete if using another compiler
   Gnat.Float_Control.Reset;
   
   if Argument_Count >0 then
      if Argument(1)="-n" or else Argument(1)="--non_editable_files"
      then
	 MAST_Pro:=True;
      else 
	 Bad_Arguments:=True;
      end if;
   end if;
   if Bad_Arguments then
	 -- Unrecognized option
	 Put_Line("Unrecognized option: "&Argument(1));
	 Put_Line("Usage: gmast");
	 Put_Line("       gmast -n");
	 Put_Line("       gmast --non_editable_files");
   else
      Gtk_New (Mast_Analysis);
      Show_All (Mast_Analysis);
      if MAST_Pro then
	 -- Non editable files option implies making the file
	 -- manimulaption widgets insensitive
	 Mast_Analysis.Directory_Entry.Set_Sensitive(False);
	 Mast_Analysis.Input_File.Set_Sensitive(False);
	 Mast_Analysis.Output_File.Set_Sensitive(False);
	 Mast_Analysis.Default.Set_Sensitive(False);
	 Mast_Analysis.Blank.Set_Sensitive(False);
	 Mast_Analysis.Input_File_Selection.Set_Sensitive(False);
	 Mast_Analysis.Destination_File.Set_Sensitive(False);
	 -- Mast_Analysis.Destination.Set_Sensitive(False);
      end if;
      Set_Active(Mast_Analysis.View_Results,False);
      Set_Sensitive(Mast_Analysis.View_Results,False);
      Read_Past_Values;
      Gtk.Main.Main;
   end if;      
end Gmast_Analysis;
