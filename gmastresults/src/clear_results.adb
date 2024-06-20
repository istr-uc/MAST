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
with Gtk.GEntry; use Gtk.GEntry;
with Gtk.Text_View; use Gtk.Text_View;
with Gtk.Tree_Store; use Gtk.Tree_Store;
with Gmast_Results_Pkg; use Gmast_Results_Pkg;

procedure Clear_Results is

begin
   -- Clear windows
   Delete_Text(Gmast_Results.Entry_Model_Name,0);
   Delete_Text(Gmast_Results.Entry_Model_Date,0);
   Delete_Text(Gmast_Results.Entry_Generation_Tool,0);
   Delete_Text(Gmast_Results.Entry_Generation_Profile,0);
   Delete_Text(Gmast_Results.Entry_Generation_Date,0);
   Delete_Text(Gmast_Results.Text_System_Slack,0);

   Clear(Gmast_Results.Model_Processing_Resources);
   Clear(Gmast_Results.Model_Transactions);
   Clear(Gmast_Results.Model_Shared_Resources);

end Clear_Results;
