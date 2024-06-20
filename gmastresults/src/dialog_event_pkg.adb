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
with Gtk; use Gtk;
with Gdk.Types;       use Gdk.Types;
with Gtk.Widget;      use Gtk.Widget;
with Gtk.Enums;       use Gtk.Enums;
with Gtk.Tree_View_Column; use Gtk.Tree_View_Column;
with Gtk.Cell_Renderer_Text; use Gtk.Cell_Renderer_Text;
with Gtk.Tree_Model; use Gtk.Tree_Model;
with Gtk.Tree_Selection; use Gtk.Tree_Selection;
with Gtkada.Handlers; use Gtkada.Handlers;
with Callbacks_Gmastresults; use Callbacks_Gmastresults;
with Gmastresults_Intl; use Gmastresults_Intl;
with Dialog_Event_Pkg.Callbacks; use Dialog_Event_Pkg.Callbacks;

package body Dialog_Event_Pkg is

   procedure Gtk_New (Dialog_Event : out Dialog_Event_Access) is
   begin
      Dialog_Event := new Dialog_Event_Record;
      Dialog_Event_Pkg.Initialize (Dialog_Event);
   end Gtk_New;

   procedure Initialize (Dialog_Event : access Dialog_Event_Record'Class) is
      Num : Gint;
      Text_Render   : Gtk_Cell_Renderer_Text;
      Col : Gtk_Tree_View_Column;
      pragma Unreferenced (Num);

   begin
      Gtk.Dialog.Initialize (Dialog_Event);
      Set_Title (Dialog_Event, -"Timing Results");
      Set_Position (Dialog_Event, Win_Pos_Center);
      Set_Modal (Dialog_Event, True);

      Dialog_Event.Dialog_Action_Area1 := Get_Action_Area (Dialog_Event);
      Set_Border_Width (Dialog_Event.Dialog_Action_Area1, 10);
      Set_Homogeneous (Dialog_Event.Dialog_Action_Area1, True);
      Set_Spacing (Dialog_Event.Dialog_Action_Area1, 5);

      Gtk_New_From_Stock (Dialog_Event.Button_Close_Tr, "gtk-ok");
      Set_Relief (Dialog_Event.Button_Close_Tr, Relief_Normal);
      Button_Callback.Connect
	(Dialog_Event.Button_Close_Tr, "clicked",
	 Button_Callback.To_Marshaller (On_Button_Close_Tr_Clicked'Access));

      Gtk_New_Vbox (Dialog_Event.Vbox4, False, 0);
      Add (Dialog_Event.Get_Content_Area, Dialog_Event.Vbox4);

      Gtk_New
	(Dialog_Event.Alignment5, 0.5, 0.5, 0.25,
	 0.25);
      Set_Border_Width (Dialog_Event.Alignment5, 5);
      Pack_Start (Dialog_Event.Vbox4, Dialog_Event.Alignment5, False, False, 0);

      Gtk_New_Hbox (Dialog_Event.Hbox3, False, 0);
      Add (Dialog_Event.Alignment5, Dialog_Event.Hbox3);

      Gtk_New (Dialog_Event.Label32, -("Transaction"));
      Set_Alignment (Dialog_Event.Label32, 0.5, 0.5);
      Set_Padding (Dialog_Event.Label32, 2, 0);
      Set_Justify (Dialog_Event.Label32, Justify_Right);
      Set_Line_Wrap (Dialog_Event.Label32, False);
      Pack_Start (Dialog_Event.Hbox3, Dialog_Event.Label32, False, False, 0);

      Gtk_New_With_Entry (Dialog_Event.Combo_Tr_Transaction);
      Pack_Start (Dialog_Event.Hbox3, Dialog_Event.Combo_Tr_Transaction, 
		  True, True, 0);

      Combo_Callback.Connect
	(Dialog_Event.Combo_Tr_Transaction, "changed",
	 Combo_Callback.To_Marshaller (On_Combo_Tr_Transaction_Changed'Access));

      Gtk_New (Dialog_Event.Button_All, -"View All");
      Set_Border_Width (Dialog_Event.Button_All, 4);
      Pack_Start (Dialog_Event.Hbox3, Dialog_Event.Button_All, False, False, 0);
      Button_Callback.Connect
	(Dialog_Event.Button_All, "clicked",
	 Button_Callback.To_Marshaller (On_Button_All_Clicked'Access));

      Gtk_New (Dialog_Event.Frame5);
      Set_Border_Width (Dialog_Event.Frame5, 6);
      Set_Shadow_Type (Dialog_Event.Frame5, Shadow_Etched_In);
      Set_Size_Request (Dialog_Event.Frame5, 640, 300);
      Pack_Start (Dialog_Event.Vbox4, Dialog_Event.Frame5, True, True, 0);

      Gtk_New (Dialog_Event.Notebook2);
      Set_Scrollable (Dialog_Event.Notebook2, False);
      Set_Show_Border (Dialog_Event.Notebook2, True);
      Set_Show_Tabs (Dialog_Event.Notebook2, True);
      Set_Tab_Pos (Dialog_Event.Notebook2, Pos_Top);
      Add (Dialog_Event.Frame5, Dialog_Event.Notebook2);
      
      -- Global response times tab
      
      Gtk_New (Dialog_Event.Scrolledwindow3);
      Set_Policy (Dialog_Event.Scrolledwindow3, Policy_Always, Policy_Always);
      
      -- Create the model that contains the data
      Gtk_New (Dialog_Event.Model_Global_Rt,
	       (GRT_Trans_Col           => Gtype_String,
		GRT_Ev_Col              => Gtype_String,
		GRT_Ref_Ev_Col          => Gtype_String,
		GRT_BRT_Col             => Gtype_String,
		GRT_ART_Col             => Gtype_String,
		GRT_WRT_Col             => Gtype_String,
		GRT_HD_Col              => Gtype_String,
		GRT_WRT_Background_Col  => Gtype_String));
      
      -- Create the view with 7 columns
      Gtk_New (Dialog_Event.Tree_Global_Rt, 
	       +Dialog_Event.Model_Global_Rt);
      Set_Grid_Lines(Dialog_Event.Tree_Global_Rt, 
		     Grid_Lines_Vertical);
      Set_Enable_Tree_Lines(Dialog_Event.Tree_Global_Rt, True);
      Set_Rubber_Banding(Dialog_Event.Tree_Global_Rt, True);
      Set_Mode (Get_Selection(Dialog_Event.Tree_Global_Rt), 
		Selection_None);
      Add (Dialog_Event.Scrolledwindow3, 
	   Dialog_Event.Tree_Global_Rt);
      
      --old column sizes 95, 54, 99, 118, 95, 80, 80

      -- Col 0
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Rt, Col);
      Set_Title (Col, "Transaction");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GRT_Trans_Col);

      -- Col 1
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Rt, Col);
      Set_Title (Col, "Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GRT_Ev_Col);

      -- Col 2
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Rt, Col);
      Set_Title (Col, "Referenced Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GRT_Ref_Ev_Col);

      -- Col 3
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Rt, Col);
      Set_Title (Col, "Best Response");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GRT_BRT_Col);

      -- Col 4
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Rt, Col);
      Set_Title (Col, "Avg Response");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GRT_ART_Col);

      -- Col 5
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Rt, Col);
      Set_Title (Col, "Worst Response");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GRT_WRT_Col);
      Add_Attribute (Col, Text_Render, "background", GRT_WRT_Background_Col);

      -- Col 6
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Rt, Col);
      Set_Title (Col, "Hard Deadline");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GRT_HD_Col);

      -- tab
      Gtk_New (Dialog_Event.Label40, -("Global Response"&ASCII.LF&"Times"));
      Set_Alignment (Dialog_Event.Label40, 0.5, 0.5);
      Set_Padding (Dialog_Event.Label40, 0, 0);
      Set_Justify (Dialog_Event.Label40, Justify_Center);
      Set_Line_Wrap (Dialog_Event.Label40, False);
      Append_Page(Dialog_Event.Notebook2, Dialog_Event.Scrolledwindow3,
		  Dialog_Event.Label40);

      -- Output jitters tab
      
      Gtk_New (Dialog_Event.Scrolledwindow4);
      Set_Policy (Dialog_Event.Scrolledwindow4, Policy_Always, Policy_Always);
      
      -- Create the model that contains the data
      Gtk_New (Dialog_Event.Model_Jitters,
	       (J_Trans_Col           => Gtype_String,
		J_Ev_Col              => Gtype_String,
		J_Ref_Ev_Col          => Gtype_String,
		J_Jit_Col             => Gtype_String,
		J_Max_Jit_Col         => Gtype_String,
		J_Jit_Background_Col  => Gtype_String));
      
      -- Create the view with 5 columns
      Gtk_New (Dialog_Event.Tree_Jitters, 
	       +Dialog_Event.Model_Jitters);
      Set_Grid_Lines(Dialog_Event.Tree_Jitters, 
		     Grid_Lines_Vertical);
      Set_Enable_Tree_Lines(Dialog_Event.Tree_Jitters, True);
      Set_Rubber_Banding(Dialog_Event.Tree_Jitters, True);
      Set_Mode (Get_Selection(Dialog_Event.Tree_Jitters), 
		Selection_None);
      Add (Dialog_Event.Scrolledwindow4, 
	   Dialog_Event.Tree_Jitters);
      
      --old column sizes 95, 80, 129, 100, 80

      -- Col 0
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Jitters, Col);
      Set_Title (Col, "Transaction");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", J_Trans_Col);

      -- Col 1
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Jitters, Col);
      Set_Title (Col, "Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", J_Ev_Col);

      -- Col 2
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Jitters, Col);
      Set_Title (Col, "Refereced Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", J_Ref_Ev_Col);

      -- Col 3
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Jitters, Col);
      Set_Title (Col, "Output Jitter");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", J_Jit_Col);
      Add_Attribute (Col, Text_Render, "background", J_Jit_Background_Col);

      -- Col 4
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Jitters, Col);
      Set_Title (Col, "Max Jitter Requirement");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", J_Max_Jit_Col);
      
      -- tab
      Gtk_New (Dialog_Event.Label43, -("Output Jitters"));
      Set_Alignment (Dialog_Event.Label43, 0.5, 0.5);
      Set_Padding (Dialog_Event.Label43, 0, 0);
      Set_Justify (Dialog_Event.Label43, Justify_Center);
      Set_Line_Wrap (Dialog_Event.Label43, False);
      Append_Page(Dialog_Event.Notebook2, Dialog_Event.Scrolledwindow4,
		  Dialog_Event.Label43);
      
      -- Blocking times tab
      
      Gtk_New (Dialog_Event.Scrolledwindow5);
      Set_Policy (Dialog_Event.Scrolledwindow5, Policy_Always, Policy_Always);

      -- Create the model that contains the data
      Gtk_New (Dialog_Event.Model_Blocking,
	       (B_Trans_Col           => Gtype_String,
		B_Ev_Col              => Gtype_String,
		B_AB_Col              => Gtype_String,
		B_WB_Col              => Gtype_String,
		B_Susp_Col            => Gtype_String,
		B_Preempt_Col         => Gtype_String));
      
      -- Create the view with 5 columns
      Gtk_New (Dialog_Event.Tree_Blocking, 
	       +Dialog_Event.Model_Blocking);
      Set_Grid_Lines(Dialog_Event.Tree_Blocking, 
		     Grid_Lines_Vertical);
      Set_Enable_Tree_Lines(Dialog_Event.Tree_Blocking, True);
      Set_Rubber_Banding(Dialog_Event.Tree_Blocking, True);
      Set_Mode (Get_Selection(Dialog_Event.Tree_Blocking), 
		Selection_None);
      Add (Dialog_Event.Scrolledwindow5, 
	   Dialog_Event.Tree_Blocking);
      
      --old column sizes 95, 80, 80, 80, 80, 80, 80

      -- Col 0
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Blocking, Col);
      Set_Title (Col, "Transaction");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", B_Trans_Col);

      -- Col 1
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Blocking, Col);
      Set_Title (Col, "Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", B_Ev_Col);

      -- Col 2
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Blocking, Col);
      Set_Title (Col, "Avg"&ASCII.LF&"Blocking Time");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", B_AB_Col);

      -- Col 3
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Blocking, Col);
      Set_Title (Col, "Worst"&ASCII.LF&"Blocking Time");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", B_WB_Col);

      -- Col 4
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Blocking, Col);
      Set_Title (Col, "Num of Suspensions");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", B_Susp_Col);

      -- Col 5
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Blocking, Col);
      Set_Title (Col, "Max Preemption Time");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", B_Preempt_Col);

      -- tab
      Gtk_New (Dialog_Event.Label41, -("Blocking Times"));
      Set_Alignment (Dialog_Event.Label41, 0.5, 0.5);
      Set_Padding (Dialog_Event.Label41, 0, 0);
      Set_Justify (Dialog_Event.Label41, Justify_Center);
      Set_Line_Wrap (Dialog_Event.Label41, False);
      Append_Page (Dialog_Event.Notebook2, Dialog_Event.Scrolledwindow5,
		   Dialog_Event.Label41);
      
      -- Local Response times tab
      
      Gtk_New (Dialog_Event.Scrolledwindow6);
      Set_Policy (Dialog_Event.Scrolledwindow6, Policy_Always, Policy_Always);

      -- Create the model that contains the data
      Gtk_New (Dialog_Event.Model_Local_Rt,
	       (LRT_Trans_Col           => Gtype_String,
		LRT_Ev_Col              => Gtype_String,
		LRT_BRT_Col             => Gtype_String,
		LRT_ART_Col             => Gtype_String,
		LRT_WRT_Col             => Gtype_String,
		LRT_HD_Col              => Gtype_String,
		LRT_WRT_Background_Col  => Gtype_String));
      
      -- Create the view with 6 columns
      Gtk_New (Dialog_Event.Tree_Local_Rt, 
	       +Dialog_Event.Model_Local_Rt);
      Set_Grid_Lines(Dialog_Event.Tree_Local_Rt, 
		     Grid_Lines_Vertical);
      Set_Enable_Tree_Lines(Dialog_Event.Tree_Local_Rt, True);
      Set_Rubber_Banding(Dialog_Event.Tree_Local_Rt, True);
      Set_Mode (Get_Selection(Dialog_Event.Tree_Local_Rt), 
		Selection_None);
      Add (Dialog_Event.Scrolledwindow6, 
	   Dialog_Event.Tree_Local_Rt);
      
      --old column sizes 95, 80, 101, 108, 114, 80

      -- Col 0
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Rt, Col);
      Set_Title (Col, "Transaction");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LRT_Trans_Col);

      -- Col 1
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Rt, Col);
      Set_Title (Col, "Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LRT_Ev_Col);

      -- Col 2
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Rt, Col);
      Set_Title (Col, "Best Response");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LRT_BRT_Col);

      -- Col 3
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Rt, Col);
      Set_Title (Col, "Avg Response");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LRT_ART_Col);

      -- Col 4
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Rt, Col);
      Set_Title (Col, "Worst Response");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LRT_WRT_Col);
      Add_Attribute (Col, Text_Render, "background", LRT_WRT_Background_Col);

      -- Col 5
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Rt, Col);
      Set_Title (Col, "Hard Deadline");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LRT_HD_Col);
      
      -- tab
      Gtk_New (Dialog_Event.Label42, -("Local Response"&ASCII.LF&"Times"));
      Set_Alignment (Dialog_Event.Label42, 0.5, 0.5);
      Set_Padding (Dialog_Event.Label42, 0, 0);
      Set_Justify (Dialog_Event.Label42, Justify_Center);
      Set_Line_Wrap (Dialog_Event.Label42, False);
      Append_Page (Dialog_Event.Notebook2, Dialog_Event.Scrolledwindow6,
		   Dialog_Event.Label42);
      
      --Suspensions tab
      
      Gtk_New (Dialog_Event.Scrolledwindow7);
      Set_Policy (Dialog_Event.Scrolledwindow7, Policy_Always, Policy_Always);
      
      -- Create the model that contains the data
      Gtk_New (Dialog_Event.Model_Suspensions,
	       (Susp_Trans_Col          => Gtype_String,
		Susp_Ev_Col             => Gtype_String,
		Susp_Time_Col           => Gtype_String,
		Susp_Num_Col            => Gtype_String));

      
      -- Create the view with 4 columns
      Gtk_New (Dialog_Event.Tree_Suspensions, 
	       +Dialog_Event.Model_Suspensions);
      Set_Grid_Lines(Dialog_Event.Tree_Suspensions, 
		     Grid_Lines_Vertical);
      Set_Enable_Tree_Lines(Dialog_Event.Tree_Suspensions, True);
      Set_Rubber_Banding(Dialog_Event.Tree_Suspensions, True);
      Set_Mode (Get_Selection(Dialog_Event.Tree_Suspensions), 
		Selection_None);
      Add (Dialog_Event.Scrolledwindow7, 
	   Dialog_Event.Tree_Suspensions);
      
      --old column sizes 95, 80, 101, 108

      -- Col 0
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Suspensions, Col);
      Set_Title (Col, "Transaction");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", Susp_Trans_Col);

      -- Col 1
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Suspensions, Col);
      Set_Title (Col, "Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", Susp_Ev_Col);

      -- Col 2
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Suspensions, Col);
      Set_Title (Col, "Suspension Time");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", Susp_Time_Col);

      -- Col 3
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Suspensions, Col);
      Set_Title (Col, "Queued Activations");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", Susp_Num_Col);

      -- tab
      Gtk_New (Dialog_Event.Label68, -("Suspensions"));
      Set_Alignment (Dialog_Event.Label68, 0.5, 0.5);
      Set_Padding (Dialog_Event.Label68, 0, 0);
      Set_Justify (Dialog_Event.Label68, Justify_Center);
      Set_Line_Wrap (Dialog_Event.Label68, False);
      Append_Page (Dialog_Event.Notebook2, Dialog_Event.Scrolledwindow7,
		   Dialog_Event.Label68);
      
      -- Local miss ratios tab
      
      Gtk_New (Dialog_Event.Scrolledwindow8);
      Set_Policy (Dialog_Event.Scrolledwindow8, Policy_Always, Policy_Always);
      
      -- Create the model that contains the data
      Gtk_New (Dialog_Event.Model_Local_Miss_Ratios,
	       (LMR_Trans_Col            => Gtype_String,
		LMR_Ev_Col               => Gtype_String,
		LMR_D_Col                => Gtype_String,
		LMR_Ratio_Col            => Gtype_String,
		LMR_Req_Col              => Gtype_String,
		LMR_Ratio_Background_Col => Gtype_String));
      
      -- Create the view with 5 columns
      Gtk_New (Dialog_Event.Tree_Local_Miss_Ratios, 
	       +Dialog_Event.Model_Local_Miss_Ratios);
      Set_Grid_Lines(Dialog_Event.Tree_Local_Miss_Ratios, 
		     Grid_Lines_Vertical);
      Set_Enable_Tree_Lines(Dialog_Event.Tree_Local_Miss_Ratios, True);
      Set_Rubber_Banding(Dialog_Event.Tree_Local_Miss_Ratios, True);
      Set_Mode (Get_Selection(Dialog_Event.Tree_Local_Miss_Ratios), 
		Selection_None);
      Add (Dialog_Event.Scrolledwindow8, 
	   Dialog_Event.Tree_Local_Miss_Ratios);
      
      --old column sizes 95, 80, 101, 108, 108

      -- Col 0
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Miss_Ratios, Col);
      Set_Title (Col, "Transaction");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LMR_Trans_Col);
      
      -- Col 1
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Miss_Ratios, Col);
      Set_Title (Col, "Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LMR_Ev_Col);
      
      -- Col 2
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Miss_Ratios, Col);
      Set_Title (Col, "Deadline");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LMR_D_Col);
      
      -- Col 3
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Miss_Ratios, Col);
      Set_Title (Col, "Ratio");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LMR_Ratio_Col);
      Add_Attribute (Col, Text_Render, "background", LMR_Ratio_Background_Col);
      
      -- Col 4
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Local_Miss_Ratios, Col);
      Set_Title (Col, "Required Ratio");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", LMR_Req_Col);
      
      -- tab
      Gtk_New (Dialog_Event.Label73, -("Local Miss Ratios"));
      Set_Alignment (Dialog_Event.Label73, 0.5, 0.5);
      Set_Padding (Dialog_Event.Label73, 0, 0);
      Set_Justify (Dialog_Event.Label73, Justify_Center);
      Set_Line_Wrap (Dialog_Event.Label73, False);
      Append_Page (Dialog_Event.Notebook2, Dialog_Event.Scrolledwindow8,
		   Dialog_Event.Label73);

      -- Global miss ratios tab
      
      Gtk_New (Dialog_Event.Scrolledwindow9);
      Set_Policy (Dialog_Event.Scrolledwindow9, Policy_Always, Policy_Always);
      
      -- Create the model that contains the data
      Gtk_New (Dialog_Event.Model_Global_Miss_Ratios,
	       (GMR_Trans_Col            => Gtype_String,
		GMR_Ev_Col               => Gtype_String,
		GMR_Ref_Ev_Col           => Gtype_String,
		GMR_D_Col                => Gtype_String,
		GMR_Ratio_Col            => Gtype_String,
		GMR_Req_Col              => Gtype_String,
		GMR_Ratio_Background_Col => Gtype_String));
      
      -- Create the view with 6 columns
      Gtk_New (Dialog_Event.Tree_Global_Miss_Ratios, 
	       +Dialog_Event.Model_Global_Miss_Ratios);
      Set_Grid_Lines(Dialog_Event.Tree_Global_Miss_Ratios, 
		     Grid_Lines_Vertical);
      Set_Enable_Tree_Lines(Dialog_Event.Tree_Global_Miss_Ratios, True);
      Set_Rubber_Banding(Dialog_Event.Tree_Global_Miss_Ratios, True);
      Set_Mode (Get_Selection(Dialog_Event.Tree_Global_Miss_Ratios), 
		Selection_None);
      Add (Dialog_Event.Scrolledwindow9, 
	   Dialog_Event.Tree_Global_Miss_Ratios);
      
      --old column sizes 95, 80, 101, 108, 108, 108

      -- Col 0
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Miss_Ratios, Col);
      Set_Title (Col, "Transaction");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GMR_Trans_Col);
      
      -- Col 1
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Miss_Ratios, Col);
      Set_Title (Col, "Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GMR_Ev_Col);
      
      -- Col 2
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Miss_Ratios, Col);
      Set_Title (Col, "Referenced Event");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GMR_Ref_Ev_Col);
      
      -- Col 3
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Miss_Ratios, Col);
      Set_Title (Col, "Deadline");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GMR_D_Col);
      
      -- Col 4
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Miss_Ratios, Col);
      Set_Title (Col, "Ratio");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GMR_Ratio_Col);
      Add_Attribute (Col, Text_Render, "background", GMR_Ratio_Background_Col);
      
      -- Col 5
      Text_Render:=Gtk_Cell_Renderer_Text_New;
      Gtk_New(Col);
      Num := Append_Column (Dialog_Event.Tree_Global_Miss_Ratios, Col);
      Set_Title (Col, "Required Ratio");
      Pack_Start (Col, Text_Render, True);
      Set_Sizing (Col, Tree_View_Column_Autosize);
      Add_Attribute (Col, Text_Render, "text", GMR_Req_Col);

      -- tab
      Gtk_New (Dialog_Event.Label79, -("Global Miss Ratios"));
      Set_Alignment (Dialog_Event.Label79, 0.5, 0.5);
      Set_Padding (Dialog_Event.Label79, 0, 0);
      Set_Justify (Dialog_Event.Label79, Justify_Center);
      Set_Line_Wrap (Dialog_Event.Label79, False);
      Append_Page (Dialog_Event.Notebook2, Dialog_Event.Scrolledwindow9,
		   Dialog_Event.Label79);
      
      -- set column visibility
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Global_Rt,GRT_ART_Col),False);
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Blocking,B_AB_Col),False);
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Blocking,B_Preempt_Col),False);
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Local_Rt,LRT_ART_Col),False);
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Suspensions,Susp_Time_Col),False);
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Suspensions,Susp_Num_Col),False);
      
   end Initialize;

end Dialog_Event_Pkg;
