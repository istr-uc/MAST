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
with Glib; use Glib;
with Gtk.Tree_View; use Gtk.Tree_View;
with Dialog_Event_Pkg; use Dialog_Event_Pkg;

procedure Resize_Timing_Results is

begin
   Columns_Autosize(Dialog_Event.Tree_Jitters);
   Columns_Autosize(Dialog_Event.Tree_Global_Rt);
   Columns_Autosize(Dialog_Event.Tree_Local_Rt);
   Columns_Autosize(Dialog_Event.Tree_Blocking);
   Columns_Autosize(Dialog_Event.Tree_Suspensions);
   Columns_Autosize(Dialog_Event.Tree_Local_Miss_Ratios);
   Columns_Autosize(Dialog_Event.Tree_Global_Miss_Ratios);

end Resize_Timing_Results;
