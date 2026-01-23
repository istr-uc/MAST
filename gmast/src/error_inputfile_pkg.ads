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
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Button; use Gtk.Button;
package Error_Inputfile_Pkg is

   type Error_Inputfile_Record is new Gtk_Window_Record with record
      Vbox6 : Gtk_Vbox;
      Label13 : Gtk_Label;
      Alignment14 : Gtk_Alignment;
      Button_Ok : Gtk_Button;
   end record;
   type Error_Inputfile_Access is access all Error_Inputfile_Record'Class;

   procedure Gtk_New (Error_Inputfile : out Error_Inputfile_Access);
   procedure Initialize (Error_Inputfile : access Error_Inputfile_Record'Class);

   Error_Inputfile : Error_Inputfile_Access;

end Error_Inputfile_Pkg;
