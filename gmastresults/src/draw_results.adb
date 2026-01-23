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
with Gtkada.types; use Gtkada.types;
with Gtk.GEntry; use Gtk.GEntry;
with Gtk.Text_View; use Gtk.Text_View;
with Gdk.RGBA; use Gdk.RGBA;
with Gtk.Stock;
with Gtk.Tree_View;            use Gtk.Tree_View;
with Gtk.Tree_Model;           use Gtk.Tree_Model;
with Gtk.Tree_View_Column;     use Gtk.Tree_View_Column;
with Gtk.Tree_Store;           use Gtk.Tree_Store;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Enums; use Gtk.Enums;
with Gmast_Results_Pkg; use Gmast_Results_Pkg;
with Mast_Actions; use Mast_Actions;
with Mast.Processing_Resources;
with Mast.Processing_Resources.Processor;
with Mast.Processing_Resources.Network;
with Mast.Shared_Resources; use Mast.Shared_Resources;
with Var_Strings; use Var_Strings;
with Mast.IO, MAST.Systems, Mast.Results, Mast.Transactions;
with Interfaces.C.Strings;
with Interfaces.C;
with Gmastresults_Pixmaps;
with Clear_Results;
with Mast.Tools;

--with Ada.Text_IO; use Ada.Text_IO;

procedure Draw_Results is

   use type Mast.Results.Slack_Result_Ref;
   use type Mast.Results.Utilization_Result_Ref;
   use type Mast.Results.Ready_Queue_Size_Result_Ref;
   use type Mast.Results.Queue_Size_Result_Ref;
   use type Mast.Results.Ceiling_Result_ref;
   package ICS renames Interfaces.C.Strings;
   package IC renames Interfaces.C;
   use type IC.Size_T;

   subtype Byte is Integer range 0..255;

   function Color_Of (Slack : Float) return String is
   begin
      if Slack<-10.0 then
         return "#F34949";--Color_Of(243,73,73);
      elsif Slack<0.0 then
         return "#F37A7A";--Color_Of(243,122,122);
      elsif Slack<10.0 then
         return "#80C880"; --Color_Of(128,200,128);
      else
         return "#3CC83C"; --Color_Of(60,200,60);
      end if;
   end Color_Of;

   function Color_Of (OK : Boolean) return String is
   begin
      if OK then
         return "#3CC83C"; --Color_Of(60,200,60);
      else
         return "#F34949";--Color_Of(243,73,73);
      end if;
   end Color_Of;

   function Background_Color_Of (OK : Boolean) return Gdk.RGBA.Gdk_RGBA is
   begin
      if OK then
   	 return (0.1,0.8,0.1,1.0);
      else
   	 return (1.0,0.2,0.2,1.0);
      end if;
   end Background_Color_Of;

   System_Slack : Float;
   Res : Mast.Results.Slack_Result_Ref;
   Schedulable : Boolean;

begin
   Clear_Results;

   -- System Results
   Set_Text(Gmast_Results.Entry_Model_Name,To_String(The_System.Model_Name));
   Set_Text(Gmast_Results.Entry_Model_Date,The_System.Model_Date);
   Set_Text(Gmast_Results.Entry_Generation_Tool,
            To_String(The_System.Generation_Tool));
   Set_Text(Gmast_Results.Entry_Generation_Profile,
            To_String(The_System.Generation_Profile));
   Set_Text(Gmast_Results.Entry_Generation_Date,The_System.Generation_Date);
   Res:=Mast.Systems.Slack_Result(The_System);
   if Res/=null then
      System_Slack:=Mast.Results.Slack(Res.all);
      if System_Slack>=0.0 then
         Set_Text (Gmast_Results.Text_System_Slack,
                   Mast.IO.Slack_Image(System_Slack)&
                  " -> The system is schedulable");
      else
         Set_Text (Gmast_Results.Text_System_Slack,
                   Mast.IO.Slack_Image(System_Slack)&
                  " -> The system is NOT schedulable");
      end if;
      Gmast_Results.Text_System_Slack.Override_Color
	(Gtk.Enums.Gtk_State_Flag_Normal,
	 Background_Color_Of(System_Slack>=0.0));
   else
      Mast.Tools.Check_System_Schedulability(The_System,Schedulable,False);
      if Schedulable then
         Set_Text (Gmast_Results.Text_System_Slack,
                   "The system is schedulable");
         Gmast_Results.Text_System_Slack.Override_Color
	   (Gtk.Enums.Gtk_State_Flag_Normal,Background_Color_Of(true));
      else
         Set_Text (Gmast_Results.Text_System_Slack,
                   "The system is NOT schedulable");
         Gmast_Results.Text_System_Slack.Override_Color
	   (Gtk.Enums.Gtk_State_Flag_Normal,Background_Color_Of(false));
      end if;
   end if;

   -- Processing Resource Results
   declare

      Res_Ref : Mast.Processing_Resources.Processing_Resource_Ref;
      Iterator : Mast.Processing_Resources.Lists.Index;
      Parent : Gtk_Tree_Iter := Null_Iter;
      Iter : Gtk_Tree_Iter:=Get_Iter_First
	(Gmast_Results.Model_Processing_Resources);
      The_Slack : Float;
      URes : Mast.Results.Utilization_Result_Ref;
      QRes : Mast.Results.Ready_Queue_Size_Result_Ref;
      Is_Visible : array(PR_Slack_Col..PR_Queue_Size_Col) of Boolean:=
	(others => False);
   begin
      Mast.Processing_Resources.Lists.Rewind
        (The_System.Processing_Resources,Iterator);
      for I in 1..Mast.Processing_Resources.Lists.Size
        (The_System.Processing_Resources)
      loop
         Mast.Processing_Resources.Lists.Get_Next_Item
           (Res_Ref,The_System.Processing_Resources,Iterator);
	 Append(Gmast_Results.Model_Processing_Resources, Iter, Parent);
	 Set(Gmast_Results.Model_Processing_Resources, Iter, PR_Name_Col,
	     To_String(Mast.Processing_Resources.Name(Res_Ref)));
         if Res_Ref.all in
           Mast.Processing_Resources.Processor.Processor'Class
         then
	    Set(Gmast_Results.Model_Processing_Resources, Iter, PR_Type_Col,
	      "Processor");
         elsif Res_Ref.all in
           Mast.Processing_Resources.Network.Network'Class
         then
	    Set(Gmast_Results.Model_Processing_Resources, Iter, PR_Type_Col,
		"Network");
         end if;
         Res:=Mast.Processing_Resources.Slack_Result(Res_Ref.all);
         if Res/=null then
	    Is_Visible(PR_Slack_Col):=True;
            The_Slack:=Mast.Results.Slack(Res.all);
	    Set(Gmast_Results.Model_Processing_Resources, Iter, PR_Slack_Col,
		Mast.IO.Slack_Image(The_Slack));
	    Set(Gmast_Results.Model_Processing_Resources, Iter, 
		PR_Slack_Background_Col, Color_Of(The_Slack));
         end if;
         URes:= Mast.Processing_Resources.Utilization_Result(Res_Ref.all);
         if URes/=null then
	    Is_Visible(PR_Total_U_Col):=True;
	    Set(Gmast_Results.Model_Processing_Resources, Iter, PR_Total_U_Col,
		Mast.IO.Percentage_Image(Mast.results.Total(URes.all)));
	    Set(Gmast_Results.Model_Processing_Resources, Iter, 
		PR_Util_Background_Col, 
		Color_Of(Mast.Results.Total(URes.all)<100.0));
            if URes.all in Mast.Results.Detailed_Utilization_Result'class then
	       Set(Gmast_Results.Model_Processing_Resources, Iter, PR_App_U_Col,
		   Mast.IO.Percentage_Image
		       (Mast.Results.Application
			  (Mast.Results.Detailed_Utilization_Result
			     (URes.all))));
	       Is_Visible(PR_App_U_Col):=True;
               if Res_Ref.all in
                 Mast.Processing_Resources.Processor.Processor'Class
               then
		  Set(Gmast_Results.Model_Processing_Resources, Iter, 
		      PR_Switch_U_Col,
		      Mast.IO.Percentage_Image
			  (Mast.Results.Context_Switch
			     (Mast.Results.Detailed_Utilization_Result
				(URes.all))));
		  Is_Visible(PR_Switch_U_Col):=True;
		  Set(Gmast_Results.Model_Processing_Resources, Iter, 
		      PR_Timer_U_Col,
		      Mast.IO.Percentage_Image
			  (Mast.Results.Timer
			     (Mast.Results.Detailed_Utilization_Result
				(URes.all))));
		  Is_Visible(PR_Timer_U_Col):=True;
		  Set(Gmast_Results.Model_Processing_Resources, Iter, 
		      PR_Driver_U_Col,
		      Mast.IO.Percentage_Image
			  (Mast.Results.Driver
			     (Mast.Results.Detailed_Utilization_Result
				(URes.all))));
		  Is_Visible(PR_Driver_U_Col):=True;
               elsif Res_Ref.all in
                 Mast.Processing_Resources.Network.Network'Class
               then
		  Set(Gmast_Results.Model_Processing_Resources, Iter, 
		      PR_Switch_U_Col,
		      Mast.IO.Percentage_Image
			  (Mast.Results.Context_Switch
			     (Mast.Results.Detailed_Utilization_Result
				(URes.all))));
		  Is_Visible(PR_Switch_U_Col):=True;
               end if;
	    end if;
	 else
	    Set(Gmast_Results.Model_Processing_Resources, Iter, 
		PR_Util_Background_Col, "black");
	 end if;

         QRes:=Mast.Processing_Resources.Ready_Queue_Size_Result(Res_Ref.all);
         if QRes/=null then
	    Set(Gmast_Results.Model_Processing_Resources, Iter, 
		PR_Queue_Size_Col,
		Natural'Image(Mast.Results.Max_Num(QRes.all)));
	    Is_Visible(PR_Queue_Size_Col):=True;
	 end if;
      end loop;
      -- Set column visibility
      for I in Is_Visible'Range loop
	 Set_Visible
	   (Get_Column(Gmast_Results.Tree_Processing_Resources,Gint(I)),
	    Is_Visible(I));
      end loop;
      Gmast_Results.Tree_Processing_Resources.Columns_Autosize;
      Gmast_Results.Tree_Processing_Resources.Get_Selection.Unselect_All;
   end;
   
   -- Transaction results
   declare
      
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Mast.Transactions.Lists.Index;
      The_Slack : Float;
      
      Parent : Gtk_Tree_Iter := Null_Iter;
      Iter : Gtk_Tree_Iter:=Get_Iter_First
	(Gmast_Results.Model_Transactions);
      Is_Slack_Visible : Boolean:= False;
   begin
      --Set_Row_Height(Gmast_Results.Tree_Transactions,22);
      --Pixmap_View:=
      --  Create_Pixmap(Gmastresults_Pixmaps.View_Str, Gmast_Results);
      --Set_Alignment (Pixmap_View, 0.5, 0.5);
      --Set_Padding (Pixmap_View, 0, 0);

      Mast.Transactions.Lists.Rewind
        (The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size
        (The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
	 
	 Append(Gmast_Results.Model_Transactions, Iter, Parent);
	 Set(Gmast_Results.Model_Transactions, Iter, TR_Name_Col,
	     To_String(Mast.Transactions.Name(Trans_Ref)));
	 if Trans_Ref.all in
           Mast.Transactions.Regular_Transaction
         then
	    Set(Gmast_Results.Model_Transactions, Iter, TR_Type_Col,
		"Regular_Transaction");
         end if;

         Res:=Mast.Transactions.Slack_Result(Trans_Ref.all);
         if Res/=null then
            The_Slack:=Mast.Results.Slack(Res.all);
	    Set(Gmast_Results.Model_Transactions, Iter, TR_Slack_Col,
		      Mast.IO.Slack_Image(The_Slack));
	    Set(Gmast_Results.Model_Transactions, Iter, 
		TR_Slack_Background_Col,Color_Of(The_Slack));
	    Is_Slack_Visible:=True;
         end if;
	 Set(Gmast_Results.Model_Transactions, Iter, TR_Timing_Col,
	     Gtk.Stock.Stock_Open); -- "gtk-open"
         --Get(Pixmap_View,Gdk_Pixmap_View,Mask_Pixmap_View);
         --Set_Pixmap(Gmast_Results.Tree_Transactions,
         --           Row,3,Gdk_Pixmap_View,Mask_Pixmap_View);
      end loop;
      Set_Visible
	(Get_Column(Gmast_Results.Tree_Processing_Resources,Gint(Tr_Slack_Col)),
	 Is_Slack_Visible);
      Columns_Autosize(Gmast_Results.Tree_Transactions);
      Gmast_Results.Tree_Transactions.Get_Selection.Unselect_All;
   end;

   -- Shared Resource Results
   declare
      Res_Ref : Mast.Shared_Resources.Shared_Resource_Ref;
      Iterator : Mast.Shared_Resources.Lists.Index;
      URes : Mast.Results.Utilization_Result_Ref;
      QRes : Mast.Results.Queue_Size_Result_Ref;
      CRes : MAst.Results.Ceiling_Result_ref;
      Parent : Gtk_Tree_Iter := Null_Iter;
      Iter : Gtk_Tree_Iter:=Get_Iter_First
	(Gmast_Results.Model_Shared_Resources);
      Is_Visible : array(SR_Ceil_Col..SR_Queue_Size_Col) of Boolean:=
	(others => False);
   begin
      Mast.Shared_Resources.Lists.Rewind
        (The_System.Shared_Resources,Iterator);
      for I in 1..Mast.Shared_Resources.Lists.Size
        (The_System.Shared_Resources)
      loop
         Mast.Shared_Resources.Lists.Get_Next_Item
           (Res_Ref,The_System.Shared_Resources,Iterator);
	 Append(Gmast_Results.Model_Shared_Resources, Iter, Parent);
	 Set(Gmast_Results.Model_Shared_Resources, Iter, SR_Name_Col,
	     To_String(Mast.Shared_Resources.Name(Res_Ref)));
	 if Res_Ref.all in
           Mast.Shared_Resources.Immediate_Ceiling_Resource
         then
	    Set(Gmast_Results.Model_Shared_Resources, Iter, SR_Type_Col,
		"Inmediate Ceiling Resource");
         elsif Res_Ref.all in
           Mast.Shared_Resources.Priority_Inheritance_Resource
         then
	    Set(Gmast_Results.Model_Shared_Resources, Iter, SR_Type_Col,
		"Priority Inheritance Resource");
         elsif Res_Ref.all in
           Mast.Shared_Resources.SRP_Resource
         then
	    Set(Gmast_Results.Model_Shared_Resources, Iter, SR_Type_Col,
		"SRP Resource");
         end if;
	 
         CRes:= Mast.Shared_Resources.Ceiling_Result(REs_REf.all);
         if CRes/=null then
	    Is_Visible(SR_Ceil_Col):=True;
	    Set(Gmast_Results.Model_Shared_Resources, Iter, SR_Ceil_Col,
		Mast.Priority'Image(Mast.results.Ceiling(CRes.all)));
         end if;

         URes:= Mast.Shared_Resources.Utilization_Result(Res_Ref.all);
         if URes/=null then
	    Is_Visible(SR_Total_U_Col):=True;
	    Set(Gmast_Results.Model_Shared_Resources, Iter, SR_Total_U_Col,
		Mast.IO.Percentage_Image(Mast.results.Total(URes.all)));
         end if;

         QRes:=Mast.Shared_Resources.Queue_Size_Result(Res_Ref.all);
         if QRes/=null then
	    Is_Visible(SR_Queue_Size_Col):=True;
	    Set(Gmast_Results.Model_Shared_Resources, Iter, SR_Queue_Size_Col,
		Natural'Image(Mast.Results.Max_Num(QRes.all)));

         end if;
      end loop;
      -- Set column visibility
      for I in Is_Visible'Range loop
	 Set_Visible
	   (Get_Column(Gmast_Results.Tree_Shared_Resources,Gint(I)),
	    Is_Visible(I));
      end loop;
      Columns_Autosize(Gmast_Results.Tree_Shared_Resources);
      Gmast_Results.Tree_Shared_Resources.Get_Selection.Unselect_All;
   end;

end Draw_Results;
