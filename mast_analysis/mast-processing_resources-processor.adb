-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2024                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--          Jose Javier Gutierrez  gutierjj@unican.es                --
--          Jose Carlos Palencia   palencij@unican.es                --
--          Jose Maria Drake       drakej@unican.es                  --
--          Julio Medina Pasaje    medinajl@unican.es                --
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

with Mast.IO, Mast.XMI;
with Mast.Schedulers.Primary;
package body Mast.Processing_Resources.Processor is

   use type Mast.Timers.System_Timer_Ref;
   use type Results.Slack_Result_Ref;
   use type Results.Utilization_Result_Ref;
   use type Results.Ready_Queue_Size_Result_Ref;
   use type Mast.Schedulers.Primary.Primary_Scheduler_Ref;
   use Var_Strings;

   ------------------------
   -- Avg_ISR_Switch --
   ------------------------

   function Avg_ISR_Switch
     (CPU : Regular_Processor)
     return Normalized_Execution_Time
   is
   begin
      return CPU.Avg_ISR_Switch;
   end Avg_ISR_Switch;

   -------------------------
   -- Best_ISR_Switch --
   -------------------------

   function Best_ISR_Switch
     (CPU : Regular_Processor)
     return Normalized_Execution_Time
   is
   begin
      return CPU.Best_ISR_Switch;
   end Best_ISR_Switch;

   ------------
   -- Clone  --
   ------------

   overriding function Clone
     (Res : Regular_Processor)
     return  Processing_Resource_Ref
   is
      Res_Ref : Processing_Resource_Ref;
   begin
      Res_Ref:=new Regular_Processor'(Res);
      Res_Ref.The_Slack_Result:=null;
      Res_Ref.The_Utilization_Result:=null;
      Res_Ref.The_Ready_Queue_Size_Result:=null;
      -- Clone the system timer
      if Res.The_System_Timer/=null then
         Regular_Processor(Res_Ref.all).The_System_Timer:=
           Timers.Clone(Res.The_System_Timer.all);
      end if;
      return Res_Ref;
   end Clone;

   ------------------------------------
   -- Max_Any_Priority --
   ------------------------------------

   function Max_Any_Priority
     (Res : Regular_Processor)
     return Priority
   is
   begin
      return Res.Max_Interrupt_Priority;
   end Max_Any_Priority;

   ------------------------------------
   -- Max_Interrupt_Priority --
   ------------------------------------

   function Max_Interrupt_Priority
     (Res : Regular_Processor)
     return Priority
   is
   begin
      return Res.Max_Interrupt_Priority;
   end Max_Interrupt_Priority;

   ------------------------------------
   -- Min_Interrupt_Priority --
   ------------------------------------

   function Min_Interrupt_Priority
     (Res : Regular_Processor)
     return Priority
   is
   begin
      return Res.Min_Interrupt_Priority;
   end Min_Interrupt_Priority;

   --------------------------------
   -- Print                      --
   --------------------------------

   overriding procedure Print
     (File : Ada.Text_IO.File_Type;
      Res : in out Regular_Processor;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      Name_Length : constant := 22;
   begin
      Print(File,Processing_Resource(Res),Indentation);
      Mast.IO.Print_Arg
        (File,"Type",
         "Regular_Processor",Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Name",
         IO.Name_Image(Res.Name),Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Max_Interrupt_Priority",
         Priority'Image(Res.Max_Interrupt_Priority),
         Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Min_Interrupt_Priority",
         Priority'Image(Res.Min_Interrupt_Priority),
         Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Worst_ISR_Switch",
         IO.Execution_Time_Image(Res.Worst_ISR_Switch),
         Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Avg_ISR_Switch",
         IO.Execution_Time_Image(Res.Avg_ISR_Switch),
         Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Best_ISR_Switch",
         IO.Execution_Time_Image(Res.Best_ISR_Switch),
         Indentation+3,Name_Length);
      if Res.The_System_Timer/=null then
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"System_Timer","",
            Indentation+3,Name_Length);
         Timers.Print(File,Res.The_System_Timer.all,Indentation+6);
      end if;
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Speed_Factor",
         IO.Speed_Image(Res.Speed_Factor),
         Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File,",",Finalize);
   end Print;

   --------------------------------
   -- Print_XML                  --
   --------------------------------

   overriding procedure Print_XML
     (File : Ada.Text_IO.File_Type;
      Res : in out Regular_Processor;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      -- Name_Length : constant := 22;
   begin
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put
        (File,"<mast_mdl:Regular_Processor Name=""" &
         IO.Name_Image(Res.Name) & """ ");
      Ada.Text_IO.Put
        (File,"Max_Interrupt_Priority=""" &
         IO.Priority_Image(Res.Max_Interrupt_Priority) & """ ");
      Ada.Text_IO.Put
        (File,"Min_Interrupt_Priority=""" &
         IO.Priority_Image(Res.Min_Interrupt_Priority) & """ ");
      Ada.Text_IO.Put
        (File,"Worst_ISR_Switch=""" &
         IO.Execution_Time_Image(Res.Worst_ISR_Switch) & """ ");
      Ada.Text_IO.Put
        (File,"Avg_ISR_Switch=""" &
         IO.Execution_Time_Image(Res.Avg_ISR_Switch) & """ ");
      Ada.Text_IO.Put
        (File,"Best_ISR_Switch=""" &
         IO.Execution_Time_Image(Res.Best_ISR_Switch) & """ ");
      Ada.Text_IO.Put_Line
        (File,"Speed_Factor=""" &  IO.Speed_Image(Res.Speed_Factor) & """ >");
      if Res.The_System_Timer/=null then
         Timers.Print_XML(File,Res.The_System_Timer.all,Indentation+3,False);
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put(File,"</mast_mdl:Regular_Processor>");
   end Print_XML;
   
   
   --------------------------------
   -- Print_XMI                  --
   --------------------------------

   overriding procedure Print_XMI
     (File : Ada.Text_IO.File_Type;
      Res : in out Regular_Processor;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      -- Name_Length : constant := 22;
      The_Scheduler : Mast.Schedulers.Primary.Primary_Scheduler_Ref;
      The_CPU_Name : Var_String;
   begin
      Mast.XMI.Add_Element_List_Item;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put_Line(File, "<Element_List");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"xsi:type=""mast2:Regular_Processor""");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      The_CPU_Name := To_Var_String(XMI.XMI_Name_Image(Res.Name, "pr_"));
      Ada.Text_IO.Put_Line
        (File,"name=""" & To_String(The_CPU_Name) & """");
      if Res.Has_Scheduler then
         The_Scheduler := Mast.Schedulers.Primary.Find_Scheduler
      (Processing_Resource(Res), Mast.XMI.Get_XMI_System);
         if The_Scheduler /= null then
            Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
            Ada.Text_IO.Put_Line
         (File,"Scheduler=""" & 
       XMI.XMI_Name_Image(The_Scheduler.Name, "sch_") & """");
         end if;
      end if;
      
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"Worst_ISR_Switch=""" &
         IO.Execution_Time_Image(Res.Worst_ISR_Switch) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"Avg_ISR_Switch=""" &
         IO.Execution_Time_Image(Res.Avg_ISR_Switch) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"Best_ISR_Switch=""" &
         IO.Execution_Time_Image(Res.Best_ISR_Switch) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"Speed_Factor=""" &  IO.Speed_Image(Res.Speed_Factor) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"Max_Interrupt_Priority=""" &
         IO.Priority_Image(Res.Max_Interrupt_Priority) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put
        (File,"Min_Interrupt_Priority=""" &
         IO.Priority_Image(Res.Min_Interrupt_Priority) & """");
      if Res.The_System_Timer/=null then
         Ada.Text_IO.New_Line(File);
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
         Ada.Text_IO.Put
      (File, "Timer_List=""" & To_String(The_CPU_Name) & "_timer""");
      end if;
      Ada.Text_IO.Put_Line(File,"/>");
      
      -- Now print the timer itself
      if Res.The_System_Timer/=null then
         Timers.Print_XMI(File,Res.The_System_Timer.all,Indentation,False);
      end if;
   end Print_XMI;
   
   --------------------------------
   -- Print_XMI_results              --
   --------------------------------

   overriding procedure Print_XMI_Results
     (File : Ada.Text_IO.File_Type;
      Res : Regular_Processor;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      -- Names_Length : constant := 8;
      -- First_Item : Boolean:=True;
   begin
      -- Print only if there are results
      if Res.The_Slack_Result/=null or else
        Res.The_Utilization_Result/=null or else
        Res.The_Ready_Queue_Size_Result/=null
      then
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
         Ada.Text_IO.Put_Line(File, "<Element_List");
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
         Ada.Text_IO.Put_Line
           (File,"xsi:type=""mast2_res:Computing_Resource_Result""");
         if Res.The_Slack_Result/=null then
            Results.Print_XMI
              (File,Res.The_Slack_Result.all,Indentation+4,False);
         end if;
         if Res.The_Ready_Queue_Size_Result/=null then
            Results.Print_XMI
              (File,Res.The_Ready_Queue_Size_Result.all,Indentation+4,False);
         end if;
    
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+2));
         Ada.Text_IO.Put_Line(File, ">");

         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+2));
         Ada.Text_IO.Put_Line(File, "<Model_Elem");    
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+6));
         Ada.Text_IO.Put_Line
           (File,"xsi:type=""mast2:Regular_Processor""");
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+6));
         Ada.Text_IO.Put_Line  
      (File, "href=""" & 
         To_String(Mast.XMI.Get_XMI_Model_File) &
         "#" & XMI.XMI_Name_Image(Res.Name, "pr_") & """/>");
         
         if Res.The_Utilization_Result/=null then
            Results.Print_XMI
              (File,Res.The_Utilization_Result.all,Indentation+2,False);
         end if;
    
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
         Ada.Text_IO.Put_Line(File,"</Element_List>");
      end if;
   end Print_XMI_Results;   
   
   ----------------------------
   -- Set_Avg_ISR_Switch --
   ----------------------------

   procedure Set_Avg_ISR_Switch
     (CPU : in out Regular_Processor;
      The_Avg_ISR_Switch : Normalized_Execution_Time)
   is
   begin
      CPU.Avg_ISR_Switch:=The_Avg_ISR_Switch;
   end Set_Avg_ISR_Switch;

   -----------------------------
   -- Set_Best_ISR_Switch --
   -----------------------------

   procedure Set_Best_ISR_Switch
     (CPU : in out Regular_Processor;
      The_Best_ISR_Switch : Normalized_Execution_Time)
   is
   begin
      CPU.Best_ISR_Switch:=The_Best_ISR_Switch;
   end Set_Best_ISR_Switch;

   ------------------------------------
   -- Set_Max_Interrupt_Priority --
   ------------------------------------

   procedure Set_Max_Interrupt_Priority
     (Res : in out Regular_Processor;
      The_Priority : Priority)
   is
   begin
      Res.Max_Interrupt_Priority:=The_Priority;
   end Set_Max_Interrupt_Priority;

   ------------------------------------
   -- Set_Min_Interrupt_Priority --
   ------------------------------------

   procedure Set_Min_Interrupt_Priority
     (Res : in out Regular_Processor;
      The_Priority : Priority)
   is
   begin
      Res.Min_Interrupt_Priority:=The_Priority;
   end Set_Min_Interrupt_Priority;

   ------------------------------------
   -- Set_System_Timer --
   ------------------------------------

   procedure Set_System_Timer
     (CPU : in out Regular_Processor;
      The_System_Timer : Timers.System_Timer_Ref)
   is
   begin
      The_System_Timer.Set_Processor_Name(CPU.Name);
      CPU.The_System_Timer:=The_System_Timer;
   end Set_System_Timer;

   ------------------------------
   -- Set_Worst_ISR_Switch --
   ------------------------------

   procedure Set_Worst_ISR_Switch
     (CPU : in out Regular_Processor;
      The_Worst_ISR_Switch : Normalized_Execution_Time)
   is
   begin
      CPU.Worst_ISR_Switch:=The_Worst_ISR_Switch;
   end Set_Worst_ISR_Switch;

   ------------------------------------
   -- The_System_Timer --
   ------------------------------------

   function The_System_Timer
     (CPU : Regular_Processor)
     return Timers.System_Timer_Ref
   is
   begin
      return CPU.The_System_Timer;
   end The_System_Timer;

   --------------------------
   -- Worst_ISR_Switch --
   --------------------------

   function Worst_ISR_Switch
     (CPU : Regular_Processor)
     return Normalized_Execution_Time
   is
   begin
      return CPU.Worst_ISR_Switch;
   end Worst_ISR_Switch;

end Mast.Processing_Resources.Processor;
