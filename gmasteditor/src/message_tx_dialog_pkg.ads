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
-- Authors : Pilar del Rio                                           --
--           Michael Gonzalez                                        --
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
with Gtk.Dialog;    use Gtk.Dialog;
with Gtk.Box;       use Gtk.Box;
with Gtk.Button;    use Gtk.Button;
with Gtk.Table;     use Gtk.Table;
with Gtk.Label;     use Gtk.Label;
with Gtk.Combo_Box_Text;     use Gtk.Combo_Box_Text;
with Gtk.GEntry;    use Gtk.GEntry;
with Glib.Unicode;  use Glib.Unicode;
package Message_Tx_Dialog_Pkg is

   type Message_Tx_Dialog_Record is new Gtk_Dialog_Record with record
      Hbox102                  : Gtk_Hbox;
      Ok_Button                : Gtk_Button;
      Cancel_Button            : Gtk_Button;
      Vbox26                   : Gtk_Vbox;
      Table37                  : Gtk_Table;
      Label380                 : Gtk_Label;
      Label381                 : Gtk_Label;
      Op_Type_Combo            : Gtk_Combo_Box_Text;
      Op_Name_Entry            : Gtk_Entry;
      Label384                 : Gtk_Label;
      Overrid_Param_Type_Combo : Gtk_Combo_Box_Text;
      Label385                 : Gtk_Label;
      Label391                 : Gtk_Label;
      Max_Message_Size_Entry   : Gtk_Entry;
      Label392                 : Gtk_Label;
      Avg_Message_Size_Entry   : Gtk_Entry;
      Label393                 : Gtk_Label;
      Min_Message_Size_Entry   : Gtk_Entry;
      Overrid_Prior_Table      : Gtk_Table;
      Label394                 : Gtk_Label;
      Overrid_Prior_Entry      : Gtk_Entry;
   end record;
   type Message_Tx_Dialog_Access is access all Message_Tx_Dialog_Record'Class;

   procedure Gtk_New (Message_Tx_Dialog : out Message_Tx_Dialog_Access);
   procedure Initialize
     (Message_Tx_Dialog : access Message_Tx_Dialog_Record'Class);

end Message_Tx_Dialog_Pkg;
