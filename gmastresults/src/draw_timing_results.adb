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
with Gtk.Tree_View; use Gtk.Tree_View;
with Gtk.Tree_Model; use Gtk.Tree_Model;
with Gtk.Tree_Store; use Gtk.Tree_Store;
with Gtk.Tree_View_Column;     use Gtk.Tree_View_Column;
with Gtk.Gentry; use Gtk.Gentry;
with Gdk.Color; use Gdk.Color;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Style; use Gtk.Style;
with Gtk.Enums; use Gtk.Enums;
with Gdk.Pixbuf; use Gdk.Pixbuf;
with Gdk.RGBA;
with Gtk.Scrolled_Window;use Gtk.Scrolled_Window;
with Glib; use Glib;
with Gtkada.Types; use Gtkada.Types;
with Dialog_Event_Pkg; use Dialog_Event_Pkg;
with Mast;
with Mast.Transactions;
with Mast.Graphs;
with Mast.Graphs.Links;
with Mast.Timing_Requirements;
with Mast.Results;
with Mast.Events;
with Mast.IO;
with Mast_Actions;
with Resize_Timing_Results;
with Var_Strings; use Var_Strings;
with Interfaces.C.Strings;
with Interfaces.C;
with List_Exceptions;
with Gtk.Notebook;use Gtk.Notebook;

with Ada.Text_IO;

procedure Draw_Timing_Results (Trans_Name : String) is

   Trans_Ref : Mast.Transactions.Transaction_Ref;
   Trans_Index : Mast.Transactions.Lists.Index;
   Evnt_Iterator : Mast.Transactions.Link_Iteration_Object;
   Link_Ref : Mast.Graphs.Link_Ref;
   Timing_Req : Mast.Timing_Requirements.Timing_Requirement_Ref;
   Res_Ref : Mast.Results.Timing_Result_Ref;
   Time_Iterator : Mast.Results.Time_Iteration_Object;
   Is_ART_Present, Is_AB_Present, Is_Max_Preempt_Present, Is_ALRT_Present,
     Is_Susp_Time_Present, Is_Susp_Num_Present
     : Boolean:=False;

   package ICS renames Interfaces.C.Strings;
   package IC renames Interfaces.C;

   use type IC.Size_T;
   use type Mast.Results.Timing_Result_Ref;
   use type Mast.Timing_Requirements.Timing_Requirement_Ref;
   use type Mast.Time;

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
   
begin
   Trans_Index:=Mast.Transactions.Lists.Find
     (To_Var_String(Trans_Name),Mast_Actions.The_System.Transactions);
   Trans_Ref:=Mast.Transactions.Lists.Item
     (Trans_Index,Mast_Actions.The_System.Transactions);
   Mast.Transactions.Rewind_Internal_Event_Links
     (Trans_Ref.all,Evnt_Iterator);
   for I in 1..Mast.Transactions.Num_Of_Internal_Event_Links(Trans_Ref.all)
   loop
      Mast.Transactions.Get_Next_Internal_Event_Link
        (Trans_Ref.all,Link_Ref,Evnt_Iterator);
      Timing_Req:=Mast.Graphs.Links.Link_Timing_Requirements
        (Mast.Graphs.Links.Regular_Link(Link_Ref.all));
      Res_Ref:=Mast.Graphs.Links.Link_Time_Results
        (Mast.Graphs.Links.Regular_Link(Link_Ref.all));
      if Res_Ref/=null then
         -- Global response times:
         --   event, referenced_event, best,worst, deadline
         declare
            GE_Ref : Mast.Events.Event_Ref;
            Params : Mast.Results.Timing_Parameters;
            Dline : Mast.Time;
	    OK, Is_Present : Boolean;
	    Parent : Gtk_Tree_Iter := Null_Iter;
	    Iter : Gtk_Tree_Iter:=Get_Iter_First
	      (Dialog_Event.Model_Global_Rt);
         begin
            -- iterate through global timing requirements
            Mast.Results.Rewind_Global_Timing_Parameters
              (Res_Ref.all,Time_Iterator);
            for J in 1..Mast.Results.Num_Of_Global_Timing_Parameters
              (Res_Ref.all)
            loop
               Mast.Results.Get_Next_Global_Timing_Parameters
                 (Res_Ref.all,GE_Ref,Params,Time_Iterator);
	       Append(Dialog_Event.Model_Global_Rt, Iter, Parent);
	       Set(Dialog_Event.Model_Global_Rt, Iter, GRT_Trans_Col,
		   Trans_Name);
	       Set(Dialog_Event.Model_Global_Rt, Iter, GRT_Ev_Col,
		To_String(Mast.Graphs.Name(Link_Ref)));
	       Set(Dialog_Event.Model_Global_Rt, Iter, GRT_Ref_Ev_Col,
		   To_String(Mast.Events.Name(GE_Ref)));
	       Set(Dialog_Event.Model_Global_Rt, Iter, GRT_BRT_Col,
		   Mast.IO.Time_Image(Params.Best_Response_Time));
	       Set(Dialog_Event.Model_Global_Rt, Iter, GRT_WRT_Col,
		   Mast.IO.Time_Image(Params.Worst_Response_Time));
               if Res_Ref.all in Mast.Results.Simulation_Timing_Result
               then
		  Set(Dialog_Event.Model_Global_Rt, Iter, GRT_ART_Col,
		      Mast.IO.Time_Image
			(Mast.Results.Avg_Global_Response_Time
			   (Mast.Results.Simulation_Timing_Result(REs_Ref.all),
			    GE_Ref)));
		  Is_ART_Present:=True;
               end if;
	       
	       Is_Present:=False;
               if Timing_Req/=null then
                  if Timing_Req.all in
                    Mast.Timing_Requirements.Hard_Global_Deadline'Class
                  then
                     Dline:=Mast.Timing_Requirements.The_Deadline
                       (Mast.Timing_Requirements.Deadline(Timing_Req.all));
		     Set(Dialog_Event.Model_Global_Rt, Iter, GRT_HD_Col,
			 Mast.IO.Time_Image(Dline));
                     Is_Present:=True;
                  elsif Timing_Req.all in
                    Mast.Timing_Requirements.Composite_Timing_Req'Class
                  then
                     Mast.Timing_Requirements.Find_Hard_Global_Deadline
                       (Mast.Timing_Requirements.Composite_Timing_Req
                        (Timing_Req.all),GE_Ref,Dline,Is_Present);
                     if Is_Present then
			Set(Dialog_Event.Model_Global_Rt, Iter, GRT_HD_Col,
			    Mast.IO.Time_Image(Dline));
                     end if;
                  end if;
               end if;
               if Is_Present then
                  OK:=Params.Worst_Response_Time<=Dline;
		  Set(Dialog_Event.Model_Global_Rt, Iter, 
		      GRT_WRT_Background_Col, Color_Of(OK));
               end if;
            end loop;
         end;

         -- Output jitters:
         --   event, referenced_event, jitter, req
         declare
            GE_Ref : Mast.Events.Event_Ref;
            Params : Mast.Results.Timing_Parameters;
            Jitter_Req: Mast.Time;
            Is_Present,OK : Boolean;
	    Parent : Gtk_Tree_Iter := Null_Iter;
	    Iter : Gtk_Tree_Iter:=Get_Iter_First
	      (Dialog_Event.Model_Jitters);
         begin
	    
              
            -- iterate through global timing requirements
            Mast.Results.Rewind_Global_Timing_Parameters
              (Res_Ref.all,Time_Iterator);

            for J in 1..Mast.Results.Num_Of_Global_Timing_Parameters
              (Res_Ref.all)
            loop

               Mast.Results.Get_Next_Global_Timing_Parameters
                 (Res_Ref.all,GE_Ref,Params,Time_Iterator);
	       
	       Append(Dialog_Event.Model_Jitters, Iter, Parent);
	       Set(Dialog_Event.Model_Jitters, Iter, J_Trans_Col,
		   Trans_Name);
	       Set(Dialog_Event.Model_Jitters, Iter, J_Ev_Col,
		   To_String(Mast.Graphs.Name(Link_Ref)));
	       Set(Dialog_Event.Model_Jitters, Iter, J_Ref_Ev_Col,
		   To_String(Mast.Events.Name(GE_Ref)));
	       Set(Dialog_Event.Model_Jitters, Iter, J_Jit_Col,
		   Mast.IO.Time_Image(Params.Jitter));
               Is_Present:=False;
               if Timing_Req/=null then
                  if Timing_Req.all in
                    Mast.Timing_Requirements.Max_Output_Jitter_Req'Class
                  then
                     Jitter_Req:=Mast.Timing_Requirements.Max_Output_Jitter
                       (Mast.Timing_Requirements.Max_Output_Jitter_Req
                        (Timing_Req.all));
		     Set(Dialog_Event.Model_Jitters, Iter, J_Max_Jit_Col,
			 Mast.IO.Time_Image (Jitter_Req));
                     Is_Present:=True;
                  elsif Timing_Req.all in
                    Mast.Timing_Requirements.Composite_Timing_Req'Class
                  then
                     Mast.Timing_Requirements.Find_Max_Output_Jitter_Req
                       (Mast.Timing_Requirements.Composite_Timing_Req
                        (Timing_Req.all),GE_Ref, Jitter_Req,Is_Present);
                     if Is_Present then
			Set(Dialog_Event.Model_Jitters, Iter, J_Max_Jit_Col,
			    Mast.IO.Time_Image (Jitter_Req));
                     end if;
                  end if;
               end if;
               if Is_Present then
                  OK:=Params.Jitter<=Jitter_Req;
		  Set(Dialog_Event.Model_Jitters, Iter, J_Jit_Background_Col,
		      Color_Of(OK));
               end if;
            end loop;
         end;

         -- Blocking Times:
         --   event, blocking, num_of_suspensions
         declare
            Blocking : Mast.Time;
            Num_Susp : Natural;
	    Parent : Gtk_Tree_Iter := Null_Iter;
	    Iter : Gtk_Tree_Iter:=Get_Iter_First
	      (Dialog_Event.Model_Blocking);
         begin
	    Append(Dialog_Event.Model_Blocking, Iter, Parent);
	    Set(Dialog_Event.Model_Blocking, Iter, B_Trans_Col,
		Trans_Name);
	    Set(Dialog_Event.Model_Blocking, Iter, B_Ev_Col,
		To_String(Mast.Graphs.Name(Link_Ref)));
            Blocking:=Mast.Results.Worst_Blocking_Time(Res_Ref.all);
            Num_Susp:=Mast.Results.Num_Of_Suspensions(Res_Ref.all);
	    Set(Dialog_Event.Model_Blocking, Iter, B_WB_Col,
		Mast.Io.Time_Image(Blocking));
	    Set(Dialog_Event.Model_Blocking, Iter, B_Susp_Col,
		Integer'Image(Num_Susp));
            if Res_Ref.all in Mast.Results.Simulation_Timing_Result
            then
	       Set(Dialog_Event.Model_Blocking, Iter, B_AB_Col,
		   Mast.IO.Time_Image
		     (Mast.Results.Avg_Blocking_Time
			(Mast.Results.Simulation_Timing_Result(Res_Ref.all))));
	       Set(Dialog_Event.Model_Blocking, Iter, B_Preempt_Col,
		   Mast.IO.Time_Image
		     (Mast.Results.Max_Preemption_Time
			(Mast.Results.Simulation_Timing_Result(Res_Ref.all))));
	       Is_AB_Present:=True;
	       Is_Max_Preempt_Present:=True;
            end if;

         end;

         -- Local response times:
         --   event, best,worst, deadline
         declare
            Worst_Resp, Best_Resp : Mast.Time;
            Dline : Mast.Time;
            Is_Present,OK : Boolean;
	    Parent : Gtk_Tree_Iter := Null_Iter;
	    Iter : Gtk_Tree_Iter:=Get_Iter_First
	      (Dialog_Event.Model_Local_Rt);
         begin
	    Append(Dialog_Event.Model_Local_Rt, Iter, Parent);
	    Set(Dialog_Event.Model_Local_Rt, Iter, LRT_Trans_Col,
		Trans_Name);
	    Set(Dialog_Event.Model_Local_Rt, Iter, LRT_Ev_Col,
		To_String(Mast.Graphs.Name(Link_Ref)));
            Worst_Resp:=Mast.Results.Worst_Local_Response_Time(Res_Ref.all);
            Best_Resp:=Mast.Results.Best_Local_Response_Time(Res_Ref.all);

            if Worst_Resp>0.0 then
	       Set(Dialog_Event.Model_Local_Rt, Iter, LRT_BRT_Col,
		   Mast.IO.Time_Image(Best_Resp));
	       Set(Dialog_Event.Model_Local_Rt, Iter, LRT_WRT_Col,
		   Mast.IO.Time_Image(Worst_Resp));
               Is_Present:=False;
               if Res_Ref.all in Mast.Results.Simulation_Timing_Result
               then
		  Set(Dialog_Event.Model_Local_Rt, Iter, LRT_ART_Col,
		      Mast.IO.Time_Image
			(Mast.Results.Avg_Local_Response_Time
			   (Mast.Results.Simulation_Timing_Result
			      (Res_Ref.all))));
		  Is_ALRT_Present:=True;
               end if;

               if Timing_Req/=null then
                  if Timing_Req.all in
                    Mast.Timing_Requirements.Hard_Local_Deadline'Class
                  then
                     Dline:=Mast.Timing_Requirements.The_Deadline
                       (Mast.Timing_Requirements.Deadline(Timing_Req.all));
		     Set(Dialog_Event.Model_Local_Rt, Iter, LRT_HD_Col,
			 Mast.IO.Time_Image (Dline));
                     Is_Present:=True;
                  elsif Timing_Req.all in
                    Mast.Timing_Requirements.Composite_Timing_Req'Class
                  then
                     Mast.Timing_Requirements.Find_Hard_Local_Deadline
                       (Mast.Timing_Requirements.Composite_Timing_Req
                        (Timing_Req.all),Dline,Is_Present);
                     if Is_Present then
			Set(Dialog_Event.Model_Local_Rt, Iter, LRT_HD_Col,
			    Mast.IO.Time_Image (Dline));
                     end if;
                  end if;
               end if;
               if Is_Present then
                  OK:=Worst_Resp<=Dline;
		  Set(Dialog_Event.Model_Local_Rt, Iter, 
		      LRT_WRT_Background_Col, Color_Of(OK));
               end if;
            end if;
         end;

         -- Suspensions :
         -- event, suspension time, queued activations
         -- Blocking Times:
         --   event, blocking, num_of_suspensions
         declare
	    Parent : Gtk_Tree_Iter := Null_Iter;
	    Iter : Gtk_Tree_Iter:=Get_Iter_First
	      (Dialog_Event.Model_Suspensions);
         begin
	    Append(Dialog_Event.Model_Suspensions, Iter, Parent);
	    Set(Dialog_Event.Model_Suspensions, Iter, Susp_Trans_Col,
		Trans_Name);
	    Set(Dialog_Event.Model_Suspensions, Iter, Susp_Ev_Col,
		To_String(Mast.Graphs.Name(Link_Ref)));
            if Res_Ref.all in Mast.Results.Simulation_Timing_Result
            then
	       Set(Dialog_Event.Model_Suspensions, Iter, Susp_Time_Col,
		   Mast.IO.Time_Image
		     (Mast.Results.Suspension_Time
			(Mast.Results.Simulation_Timing_Result(Res_Ref.all))));
	       Set(Dialog_Event.Model_Suspensions, Iter, Susp_Num_Col,
		   Natural'Image
		     (Mast.Results.Num_Of_Queued_Activations
			(Mast.Results.Simulation_Timing_Result(Res_Ref.all))));
	       Is_Susp_Num_Present:=True;
	       Is_Susp_Time_Present:=True;
            end if;
         end;

         -- Local_Miss_Ratios :
         -- event, deadline, ratio, required ratio

         declare
            procedure Set_Local_Miss_Ratio_Result
              (Req_Ref : Mast.Timing_Requirements.Local_Max_Miss_Ratio)
            is
               Ratio,Real_Ratio : MAst.Percentage;
               Dline: Mast.Time;
               OK : Boolean:=False;
	       Parent : Gtk_Tree_Iter := Null_Iter;
	       Iter : Gtk_Tree_Iter:=Get_Iter_First
		 (Dialog_Event.Model_Local_Miss_Ratios);
            begin
	       Append(Dialog_Event.Model_Local_Miss_Ratios, Iter, Parent);
	       Set(Dialog_Event.Model_Local_Miss_Ratios, Iter, LMR_Trans_Col,
		   Trans_Name);
	       Set(Dialog_Event.Model_Local_Miss_Ratios, Iter, LMR_Ev_Col,
		   To_String(Mast.Graphs.Name(Link_Ref)));
               Dline:=Mast.Timing_Requirements.The_Deadline
                 (Mast.Timing_Requirements.Deadline(Req_Ref));
	       Set(Dialog_Event.Model_Local_Miss_Ratios, Iter, LMR_D_Col,
		   Mast.IO.Time_Image(Dline));
               Ratio:=Mast.Timing_Requirements.Ratio
                 (Mast.Timing_Requirements.Local_Max_Miss_Ratio(Req_Ref));
	       Set(Dialog_Event.Model_Local_Miss_Ratios, Iter, LMR_Req_Col,
		   Mast.IO.Percentage_Image (Ratio));
               Real_Ratio:=Mast.Results.Local_Miss_Ratio
                 (Mast.Results.Simulation_Timing_Result(Res_Ref.all),Dline);
	       Set(Dialog_Event.Model_Local_Miss_Ratios, Iter, LMR_Ratio_Col,
		   Mast.IO.Percentage_Image(Real_Ratio));
               OK:= Real_Ratio < Ratio;
	       Set(Dialog_Event.Model_Local_Miss_Ratios, Iter, 
		   LMR_Ratio_Background_Col, Color_Of(OK));
	    end Set_Local_Miss_Ratio_Result;

	    Iterator : Mast.Timing_Requirements.Iteration_Object;
	    Req_Ref : Mast.Timing_Requirements.Simple_Timing_Requirement_Ref;

         begin
            if Res_Ref.all in Mast.Results.Simulation_Timing_Result
            then
               if Timing_Req/=null
               then
                  if Timing_Req.all in
                    Mast.Timing_Requirements.Local_Max_Miss_Ratio'Class
                  then
                     Set_Local_Miss_Ratio_Result
                       (Mast.Timing_Requirements.Local_Max_Miss_Ratio
                        (Timing_Req.all));
                  elsif Timing_Req.all in
                    Mast.Timing_Requirements.Composite_Timing_Req'Class
                  then
                     Mast.Timing_Requirements.Rewind_Requirements
                       (Mast.Timing_Requirements.Composite_Timing_Req
                        (Timing_Req.all),Iterator);
                     for I in 1..Mast.Timing_Requirements.Num_Of_Requirements
                       (Mast.Timing_Requirements.Composite_Timing_Req
                        (Timing_Req.all))
                     loop
                        Mast.Timing_Requirements.Get_Next_Requirement
                          (Mast.Timing_Requirements.Composite_Timing_Req
                           (Timing_Req.all),Req_Ref,Iterator);
                        if Req_Ref.all in
                          Mast.Timing_Requirements.Local_Max_Miss_Ratio'Class
                        then
                           Set_Local_Miss_Ratio_Result
                             (Mast.Timing_Requirements.Local_Max_Miss_Ratio
                              (Req_Ref.all));
                        end if;
                     end loop;
                  end if;
               end if;
            end if;
         end;

         -- Global_Miss_Ratios :
         -- event, referenced event, deadline, ratio, required ratio

         declare
            procedure Set_Global_Miss_Ratio_Result
              (Timing_Req : Mast.Timing_Requirements.Global_Max_Miss_Ratio)
	    is
               Ratio,Real_Ratio : MAst.Percentage;
               Dline: Mast.Time;
               Ev:MAst.Events.Event_Ref;
               OK : Boolean;
	       Parent : Gtk_Tree_Iter := Null_Iter;
	       Iter : Gtk_Tree_Iter:=Get_Iter_First
		 (Dialog_Event.Model_Global_Miss_Ratios);
            begin
	       Append(Dialog_Event.Model_Global_Miss_Ratios, Iter, Parent);
	       Set(Dialog_Event.Model_Global_Miss_Ratios, Iter, GMR_Trans_Col,
		   Trans_Name);
	       Set(Dialog_Event.Model_Global_Miss_Ratios, Iter, GMR_Ev_Col,
		   To_String(Mast.Graphs.Name(Link_Ref)));
               Ev :=Mast.Timing_Requirements.Event
                 (MASt.Timing_Requirements.Global_Deadline(Timing_Req));
	       Set(Dialog_Event.Model_Global_Miss_Ratios, Iter, GMR_Ref_Ev_Col,
		   To_String(Mast.Events.Name(Ev)));
               Dline:=Mast.Timing_Requirements.The_Deadline
                 (Mast.Timing_Requirements.Deadline(Timing_Req));
	       Set(Dialog_Event.Model_Global_Miss_Ratios, Iter, GMR_D_Col,
		   Mast.IO.Time_Image(Dline));
               Ratio:=Mast.Timing_Requirements.Ratio
                 (Mast.Timing_Requirements.Global_Max_Miss_Ratio(Timing_Req));
	       Set(Dialog_Event.Model_Global_Miss_Ratios, Iter, GMR_Req_Col,
		   Mast.IO.Percentage_Image(Ratio));
               Real_Ratio:=Mast.Results.Global_Miss_Ratio
                 (Mast.Results.Simulation_Timing_Result(Res_Ref.all),Dline,Ev);
	       Set(Dialog_Event.Model_Global_Miss_Ratios, Iter, GMR_Ratio_Col,
		   Mast.IO.Percentage_Image(Real_Ratio));
               OK:= Real_Ratio<=Ratio;
	       Set(Dialog_Event.Model_Global_Miss_Ratios, Iter, 
		   GMR_Ratio_Background_Col, Color_Of(OK));
            end Set_Global_Miss_Ratio_Result;

            Iterator : Mast.Timing_Requirements.Iteration_Object;
            Req_Ref : Mast.Timing_Requirements.Simple_Timing_Requirement_Ref;

         begin
            if Res_Ref.all in Mast.Results.Simulation_Timing_Result
            then
               if Timing_Req/=null
               then
                  if Timing_Req.all in
                    Mast.Timing_Requirements.Global_Max_Miss_Ratio'Class
                  then
                     Set_Global_Miss_Ratio_Result
                       (Mast.Timing_Requirements.Global_Max_Miss_Ratio
                        (Timing_Req.all));
                  elsif Timing_Req.all in
                    Mast.Timing_Requirements.Composite_Timing_Req'Class
                  then
                     Mast.Timing_Requirements.Rewind_Requirements
                       (Mast.Timing_Requirements.Composite_Timing_Req
                        (Timing_Req.all),Iterator);

                     for I in 1..Mast.Timing_Requirements.Num_Of_Requirements
                       (Mast.Timing_Requirements.Composite_Timing_Req
                        (Timing_Req.all))
                     loop
                        Mast.Timing_Requirements.Get_Next_Requirement
                          (Mast.Timing_Requirements.Composite_Timing_Req
                           (Timing_Req.all), Req_Ref, Iterator);
                        if Req_Ref.all in
                          Mast.Timing_Requirements.Global_Max_Miss_Ratio'Class
                        then
                           Set_Global_Miss_Ratio_Result
                             (Mast.Timing_Requirements.Global_Max_Miss_Ratio
                              (Req_Ref.all));
                        end if;
                     end loop;
                  end if;
               end if;
            end if;
         end;
      end if;
   end loop;
   -- set column visibility
   if Is_ART_Present then
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Global_Rt,GRT_ART_Col),True);
   end if;
   if Is_AB_Present then
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Blocking,B_AB_Col),True);
   end if;
   if  Is_Max_Preempt_Present then
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Blocking,B_Preempt_Col),True);
   end if;
   if  Is_ALRT_Present then
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Local_Rt,LRT_ART_Col),True);
   end if;
   if Is_Susp_Time_Present then
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Suspensions,Susp_Time_Col),True);
   end if;
   if  Is_Susp_Num_Present then
      Set_Visible
	(Get_Column(Dialog_Event.Tree_Suspensions,Susp_Num_Col),True);
   end if;
   
   Resize_Timing_Results;
end Draw_Timing_Results;
