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

with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Label; use Gtk.Label;
with Gtk.GEntry; use Gtk.GEntry;
with Glib.Unicode; use Glib.Unicode;
--with Gtk.Tooltip; use Gtk.Tooltip;
with Gtk.Button; use Gtk.Button;
with Gtk.Box; use Gtk.Box;
with Gtk.Combo_Box_Text; use Gtk.Combo_Box_Text;

package Usage_Dialog_Pkg is

   type Usage_Dialog_Record is new Gtk_Dialog_Record with record
      Alignment11 : Gtk_Alignment;
      Vbox10 : Gtk_Vbox;
      Hbox8 : Gtk_Hbox;
      Label13 : Gtk_Label;
      Operation_Entry : Gtk_Entry;
      Hbox9 : Gtk_Hbox;
      Label14 : Gtk_Label;
      Taskname_Combobox : Gtk_Combo_Box_Text;
      Hbox10 : Gtk_Hbox;
      Label15 : Gtk_Label;
      Mutexname_Combobox : Gtk_Combo_Box_Text;
      Hbox11 : Gtk_Hbox;
      Label16 : Gtk_Label;
      Wcet_Entry : Gtk_Entry;
      Usage_Cancel_Ebutton : Gtk_Button;
      Usage_Ok_Button : Gtk_Button;
   end record;
   type Usage_Dialog_Access is access all Usage_Dialog_Record'Class;

   Usage_Dialog : Usage_Dialog_Access;

   procedure Gtk_New (Usage_Dialog : out Usage_Dialog_Access);
   procedure Initialize (Usage_Dialog : access Usage_Dialog_Record'Class);

end Usage_Dialog_Pkg;
