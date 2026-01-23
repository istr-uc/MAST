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
with Gtk.Window; use Gtk.Window;
with Gtk.Box; use Gtk.Box;
with Gtk.Label; use Gtk.Label;
with Gtk.Frame; use Gtk.Frame;
with Gtk.Table; use Gtk.Table;
with Gtk.GEntry; use Gtk.GEntry;
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Button; use Gtk.Button;
with Gtk.Image; use Gtk.Image;
with Gtk.Combo_Box_Text; use Gtk.Combo_Box_Text;

package Hopa_Window_Pkg is

   type Hopa_Window_Record is new Gtk_Window_Record with record
      Vbox9 : Gtk_Vbox;
      Label27 : Gtk_Label;
      Frame3 : Gtk_Frame;
      Table4 : Gtk_Table;
      Ka_Entry : Gtk_Entry;
      Kr_Entry : Gtk_Entry;
      Alignment6 : Gtk_Alignment;
      Alignment10 : Gtk_Alignment;
      Label30 : Gtk_Label;
      Alignment7 : Gtk_Alignment;
      Label20 : Gtk_Label;
      Opiter_Entry : Gtk_Entry;
      Alignment8 : Gtk_Alignment;
      Label28 : Gtk_Label;
      Alignment9 : Gtk_Alignment;
      Label29 : Gtk_Label;
      Iter_List_Entry : Gtk_Entry;
      Hbox14 : Gtk_Hbox;
      Hset_Button : Gtk_Button;
      Alignment17 : Gtk_Alignment;
      Hbox17 : Gtk_Hbox;
      Image3 : Gtk_Image;
      Label33 : Gtk_Label;
      Hget_Defaults_Button : Gtk_Button;
      Alignment18 : Gtk_Alignment;
      Hbox18 : Gtk_Hbox;
      Image4 : Gtk_Image;
      Label34 : Gtk_Label;
      Hopa_Help_Button : Gtk_Button;
      Hcancel_Button : Gtk_Button;
      Initial_Assignment_Combo : Gtk_Combo_Box_Text;
      Label_Initial : Gtk_Label;
      Alignment_Initial : Gtk_Alignment;
   end record;
   type Hopa_Window_Access is access all Hopa_Window_Record'Class;

   procedure Gtk_New (Hopa_Window : out Hopa_Window_Access);
   procedure Initialize (Hopa_Window : access Hopa_Window_Record'Class);

   Hopa_Window : Hopa_Window_Access;

end Hopa_Window_Pkg;
