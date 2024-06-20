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

with Gtk; use Gtk;
with Gtk; use Gtk;
with Gtk.Main;
with Gtk.Widget; use Gtk.Widget;
with Pt_Editor_Pkg; use Pt_Editor_Pkg;
with Aboutdialog1_Pkg; use Aboutdialog1_Pkg;
with Dialog1_Pkg; use Dialog1_Pkg;
with Filechooserdialog1_Pkg; use Filechooserdialog1_Pkg;
with Progress_Dialog_Pkg; use Progress_Dialog_Pkg;
with Usage_Dialog_Pkg; use Usage_Dialog_Pkg;

with Task_Table;
with Mutex_Table;
with Usage_Table;
with Results_Table;
with File_Operations;
with Changes_Control;
with Global_Options;

with Ada.Command_Line; use Ada.Command_Line;
with Ada.Directories; use Ada.Directories;

procedure Pt_Editor is

begin
   Gtk.Main.Init;
   Gtk_New (Pt_Editor_Pkg.Pt_Editor);
   Show_All (Pt_Editor_Pkg.Pt_Editor);
   Task_Table.Initialize;
   Mutex_Table.Initialize;
   Usage_Table.Initialize;
   Results_Table.Initialize;
   Gtk_New (Filechooserdialog1_Pkg.Filechooserdialog1);
   Gtk_New (Usage_Dialog_Pkg.Usage_Dialog);
   -- Check arguments
   if Argument_Count>=1 then
      declare
         Filename : String:=
           Full_Name(File_Operations.Get_Complete_Filename(Argument(1)));
      begin
         File_Operations.Read(Filename);
         Changes_Control.Reset;
         Global_Options.Set_System_Name(Filename);
         Usage_Table.Set_Buttons;
      end;
   end if;
   Gtk.Main.Main;
end Pt_Editor;
