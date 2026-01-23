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
with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Box; use Gtk.Box;
with Gtk.Button; use Gtk.Button;
with Gtk.Box; use Gtk.Box;
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Label; use Gtk.Label;
with Gtk.Combo_Box_Text; use Gtk.Combo_Box_Text;
with Gtk.GEntry; use Gtk.GEntry;
with Gtk.Frame; use Gtk.Frame;
with Gtk.Notebook; use Gtk.Notebook;
with Gtk.Scrolled_Window; use Gtk.Scrolled_Window;
with Gtk.Tree_Store; use Gtk.Tree_Store;
with Gtk.Tree_View; use Gtk.Tree_View;
package Dialog_Event_Pkg is

   type Dialog_Event_Record is new Gtk_Dialog_Record with record
      Dialog_Action_Area1 : Gtk_Hbox;
      Button_Close_Tr : Gtk_Button;
      Vbox4 : Gtk_Vbox;
      Alignment5 : Gtk_Alignment;
      Hbox3 : Gtk_Hbox;
      Label32 : Gtk_Label;
      Combo_Tr_Transaction : Gtk_Combo_Box_Text;
      Button_All : Gtk_Button;
      Frame5 : Gtk_Frame;
      Notebook2 : Gtk_Notebook;
      Scrolledwindow3 : Gtk_Scrolled_Window;
      Tree_Global_Rt : Gtk_Tree_View;
      Model_Global_Rt : Gtk_Tree_Store;
      Label40 : Gtk_Label;
      Scrolledwindow4 : Gtk_Scrolled_Window;
      Tree_Jitters : Gtk_Tree_View;
      Model_Jitters : Gtk_Tree_Store;
      Label43 : Gtk_Label;
      Scrolledwindow5 : Gtk_Scrolled_Window;
      Tree_Blocking : Gtk_Tree_View;
      Model_Blocking : Gtk_Tree_Store;
      Label41 : Gtk_Label;
      Scrolledwindow6 : Gtk_Scrolled_Window;
      Tree_Local_Rt : Gtk_Tree_View;
      Model_Local_Rt : Gtk_Tree_Store;
      Label42 : Gtk_Label;
      Scrolledwindow7 : Gtk_Scrolled_Window;
      Tree_Suspensions : Gtk_Tree_View;
      Model_Suspensions : Gtk_Tree_Store;
      Label68 : Gtk_Label;
      Scrolledwindow8 : Gtk_Scrolled_Window;
      Tree_Local_Miss_Ratios : Gtk_Tree_View;
      Model_Local_Miss_Ratios : Gtk_Tree_Store;
      Label73 : Gtk_Label;
      Scrolledwindow9 : Gtk_Scrolled_Window;
      Tree_Global_Miss_Ratios : Gtk_Tree_View;
      Model_Global_Miss_Ratios : Gtk_Tree_Store;
      Label79 : Gtk_Label;
   end record;
   type Dialog_Event_Access is access all Dialog_Event_Record'Class;
   
   -- Transactions columns
   GRT_Trans_Col           : constant:=0;
   GRT_Ev_Col              : constant:=1;
   GRT_Ref_Ev_Col          : constant:=2;
   GRT_BRT_Col             : constant:=3;
   GRT_ART_Col             : constant:=4;
   GRT_WRT_Col             : constant:=5;
   GRT_HD_Col              : constant:=6;
   GRT_WRT_Background_Col  : constant:=7;
   
   -- Output jitter columns
   J_Trans_Col             : constant:=0;
   J_Ev_Col                : constant:=1;
   J_Ref_Ev_Col            : constant:=2;
   J_Jit_Col               : constant:=3;
   J_Max_Jit_Col           : constant:=4;
   J_Jit_Background_Col    : constant:=5;
   
   -- Blocking times columns
   B_Trans_Col             : constant:=0;
   B_Ev_Col                : constant:=1;
   B_AB_Col                : constant:=2;
   B_WB_Col                : constant:=3;
   B_Susp_Col              : constant:=4;
   B_Preempt_Col           : constant:=5;
   
   -- Local response times columns
   LRT_Trans_Col           : constant:=0;
   LRT_Ev_Col              : constant:=1;
   LRT_BRT_Col             : constant:=2;
   LRT_ART_Col             : constant:=3;
   LRT_WRT_Col             : constant:=4;
   LRT_HD_Col              : constant:=5;
   LRT_WRT_Background_Col  : constant:=6;
   
   -- Suspensions columns
   Susp_Trans_Col          : constant:=0;
   Susp_Ev_Col             : constant:=1;
   Susp_Time_Col           : constant:=2;
   Susp_Num_Col            : constant:=3;
   
   -- Local miss ratios columns
   LMR_Trans_Col            : constant:=0;
   LMR_Ev_Col               : constant:=1;
   LMR_D_Col                : constant:=2;
   LMR_Ratio_Col            : constant:=3;
   LMR_Req_Col              : constant:=4;
   LMR_Ratio_Background_Col : constant:=5;
   
   -- Global miss ratios columns
   GMR_Trans_Col            : constant:=0;
   GMR_Ev_Col               : constant:=1;
   GMR_Ref_Ev_Col           : constant:=2;
   GMR_D_Col                : constant:=3;
   GMR_Ratio_Col            : constant:=4;
   GMR_Req_Col              : constant:=5;
   GMR_Ratio_Background_Col : constant:=6;
   
   procedure Gtk_New (Dialog_Event : out Dialog_Event_Access);
   procedure Initialize (Dialog_Event : access Dialog_Event_Record'Class);

   Dialog_Event : Dialog_Event_Access;

end Dialog_Event_Pkg;
