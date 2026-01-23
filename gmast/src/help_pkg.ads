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
with Gtk.Scrolled_Window; use Gtk.Scrolled_Window;
with Gtk.Text_View; use Gtk.Text_View;
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Button; use Gtk.Button;
package Help_Pkg is

   type Help_Record is new Gtk_Window_Record with record
      Vbox7 : Gtk_Vbox;
      Scrolledwindow1 : Gtk_Scrolled_Window;
      Text_View1 : Gtk_Text_View;
      Alignment4 : Gtk_Alignment;
      Help_Ok : Gtk_Button;
   end record;
   type Help_Access is access all Help_Record'Class;

   procedure Gtk_New (Help : out Help_Access);
   procedure Initialize (Help : access Help_Record'Class);

   Help : Help_Access;

end Help_Pkg;
