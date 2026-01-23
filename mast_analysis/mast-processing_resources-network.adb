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

with Mast.Schedulers.Primary, Mast.IO, Mast.XMI,
  List_Exceptions, Var_Strings;
use Var_Strings;

package body Mast.Processing_Resources.Network is
   pragma Warnings (Off, "use clause for type * defined at mast-drivers.ads:61 has no effect", Reason => "TBD");

   use type Mast.Drivers.Driver_Ref;
   pragma Warnings (On, "use clause for type * defined at mast-drivers.ads:61 has no effect");
   use type Mast.Drivers.Lists.Index;
   pragma Warnings (Off, "use clause for type * defined at mast-scheduling_servers.ads:148 has no effect", Reason => "TBD");
   use type Mast.Scheduling_Servers.Scheduling_Server_Ref;
   pragma Warnings (On, "use clause for type * defined at mast-scheduling_servers.ads:148 has no effect");
   use type Mast.Schedulers.Primary.Primary_Scheduler_Ref;

   ------------------------
   -- Add_Driver         --
   ------------------------

   procedure Add_Driver
     (Net : in out Network;
      The_Driver : Mast.Drivers.Driver_Ref)
   is
   begin
      Drivers.Lists.Add(The_Driver,Net.List_Of_Drivers);
   end Add_Driver;

   ------------
   -- Adjust --
   ------------

   procedure Adjust
     (Net : Packet_Based_Network;
      Server_List : Scheduling_Servers.Lists.List;
      Op_List : Operations.Lists.List)
   is
   begin
      Drivers.Adjust(Net.List_Of_Drivers,Server_List,Op_List);
   exception
      when Object_Not_Found =>
         Set_Exception_Message
           ("Error in Packet_Based_Network "&Var_Strings.To_String(Net.Name)&
            ": "&Get_Exception_Message);
         raise;
   end Adjust;

   ------------
   -- Adjust --
   ------------

   procedure Adjust
     (The_List : Processing_Resources.Lists.List;
      Server_List : Scheduling_Servers.Lists.List;
      Op_List : Operations.Lists.List)
   is
      Iterator : Processing_Resources.Lists.Iteration_Object;
      Res_Ref : Processing_Resource_Ref;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Res_Ref,The_List,Iterator);
         if Res_Ref.all in Packet_Based_Network'Class then
            Adjust(Packet_Based_Network'Class(Res_Ref.all),
                   Server_List,Op_List);
         end if;
      end loop;
   end Adjust;

   ------------
   -- Clone  --
   ------------
   overriding function Clone
     (Res : Packet_Based_Network)
     return  Processing_Resource_Ref
   is
      Res_Ref : Processing_Resource_Ref;
      Null_List : Drivers.Lists.List;
   begin
      Res_Ref:=new Packet_Based_Network'(Res);
      Res_Ref.The_Slack_Result:=null;
      Res_Ref.The_Utilization_Result:=null;
      Res_Ref.The_Ready_Queue_Size_Result:=null;
      -- Clone the drivers
      Network(Res_Ref.all).List_Of_Drivers:=Null_List;
      Network(Res_Ref.all).List_Of_Drivers:=
        Drivers.Clone(Res.List_Of_Drivers);
      return Res_Ref;
   end Clone;

   ------------------------
   -- Get_Next_Driver    --
   ------------------------

   procedure Get_Next_Driver
     (Net : Network;
      The_Driver : out Mast.Drivers.Driver_Ref;
      Iterator : in out Driver_Iteration_Object)
   is
   begin
      Drivers.Lists.Get_Next_Item
        (The_Driver,Net.List_Of_Drivers,
         Drivers.Lists.Iteration_Object(Iterator));
   end Get_Next_Driver;

   ------------------
   -- Max_Blocking --
   ------------------

   function Max_Blocking
     (Net  : Packet_Based_Network)
     return Normalized_Execution_Time
   is
   begin
      return Net.Max_Blocking;
   end Max_Blocking;

   ---------------------
   -- Max_Packet_Size --
   ---------------------

   function Max_Packet_Size
     (Net  : Packet_Based_Network) return Bit_Count
   is
   begin
      if Net.Max_Packet_Units_Are_Time then
         return (Net.Max_Packet_Transmission_Time)*
           Net.The_Throughput;
      else
         return Net.Max_Packet_Size;
      end if;
   end Max_Packet_Size;

   ---------------------
   -- Min_Packet_Size --
   ---------------------

   function Min_Packet_Size
     (Net  : Packet_Based_Network) return Bit_Count
   is
   begin
      if Net.Min_Packet_Units_Are_Time then
         return (Net.Min_Packet_Transmission_Time)*
           Net.The_Throughput;
      else
         return Net.Min_Packet_Size;
      end if;
   end Min_Packet_Size;

   ---------------------------------
   -- Max_Packet_Transmission_Time --
   ---------------------------------

   function Max_Packet_Transmission_Time
     (Net  : Packet_Based_Network)
     return Normalized_Execution_Time
   is
   begin
      if Net.Max_Packet_Units_Are_Time then
         return Net.Max_Packet_Transmission_Time;
      else
         return (Net.Max_Packet_Size/Net.The_Throughput);
      end if;
   end Max_Packet_Transmission_Time;

   ---------------------------------
   -- Min_Packet_Transmission_Time --
   ---------------------------------

   function Min_Packet_Transmission_Time
     (Net  : Packet_Based_Network)
     return Normalized_Execution_Time
   is
   begin
      if Net.Min_Packet_Units_Are_Time then
         return Net.Min_Packet_Transmission_Time;
      else
         return (Net.Min_Packet_Size/Net.The_Throughput);
      end if;
   end Min_Packet_Transmission_Time;

   ------------------------
   -- Num_of_Drivers     --
   ------------------------

   function Num_Of_Drivers
     (Net : Network)
     return Natural
   is
   begin
      return Drivers.Lists.Size(Net.List_Of_Drivers);
   end Num_Of_Drivers;

   --------------------------------
   -- Print                      --
   --------------------------------

   overriding procedure Print
     (File : Ada.Text_IO.File_Type;
      Res : in out Packet_Based_Network;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      Name_Length : constant := 29;
   begin
      Print(File,Processing_Resource(Res),Indentation);
      Mast.IO.Print_Arg
        (File,"Type",
         "Packet_Based_Network",Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Name",
         IO.Name_Image(Res.Name),Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Transmission",
         Transmission_Kind'Image(Res.Transmission_Mode),
         Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Throughput",
         IO.Speed_Image(Processor_Speed(Res.The_Throughput)),
         Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Max_Blocking",
         IO.Execution_Time_Image(Res.Max_Blocking),
         Indentation+3,Name_Length);
      if Res.Max_Packet_Units_Are_Time then
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"Max_Packet_Transmission_Time",
            IO.Execution_Time_Image(Res.Max_Packet_Transmission_Time),
            Indentation+3,Name_Length);
      else
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"Max_Packet_Size",
            IO.Bit_Count_Image(Res.Max_Packet_Size),
            Indentation+3,Name_Length);
      end if;
      if Res.Min_Packet_Units_Are_Time then
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"Min_Packet_Transmission_Time",
            IO.Execution_Time_Image(Res.Min_Packet_Transmission_Time),
            Indentation+3,Name_Length);
      else
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"Min_Packet_Size",
            IO.Bit_Count_Image(Res.Min_Packet_Size),
            Indentation+3,Name_Length);
      end if;
      if Drivers.Lists.Size(Res.List_Of_Drivers) >0 then
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"List_of_Drivers","",
            Indentation+3,Name_Length);
         Ada.Text_IO.New_Line(File);
         Drivers.Print(File,Res.List_Of_Drivers,Indentation+6);
      end if;
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Speed_Factor",
         IO.Speed_Image(Res.Speed_Factor),Indentation+3,Name_Length);
      Mast.IO.Print_Separator(File,",",Finalize);
   end Print;

   --------------------------------
   -- Print_XML                  --
   --------------------------------

   overriding procedure Print_XML
     (File : Ada.Text_IO.File_Type;
      Res : in out Packet_Based_Network;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      -- Iterator : Drivers.Lists.Index;
   begin
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put
        (File,"<mast_mdl:Packet_Based_Network Name=""" &
         IO.Name_Image(Res.Name) & """ ");
      Ada.Text_IO.Put
        (File,"Transmission=""" &
         Transmission_Kind'Image(Res.Transmission_Mode) & """ ");
      Ada.Text_IO.Put
           (File,"Throughput=""" &
            IO.Speed_Image(Processor_Speed(Res.The_Throughput)) & """ ");
      Ada.Text_IO.Put
        (File,"Max_Blocking=""" &
         IO.Execution_Time_Image(Res.Max_Blocking) & """ ");
      Ada.Text_IO.Put
        (File,"Speed_Factor=""" &
         IO.Speed_Image(Res.Speed_Factor) & """ ");
      Ada.Text_IO.Put
   (File,"Max_Packet_Size=""" &
      IO.Bit_Count_Image(Max_Packet_Size(Res)) & """ ");
      Ada.Text_IO.Put
   (File,"Min_Packet_Size=""" &
      IO.Bit_Count_Image(Max_Packet_Size(Res)) & """ >");
      if Drivers.Lists.Size(Res.List_Of_Drivers) >0 then
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
         Ada.Text_IO.Put_Line(File,"<mast_mdl:List_of_Drivers>");
         Drivers.Print_XML(File,Res.List_Of_Drivers,Indentation+3);
         Ada.Text_IO.Put_Line(File,"</mast_mdl:List_of_Drivers>");
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put(File,"</mast_mdl:Packet_Based_Network>");
   end Print_XML;

   --------------------------------
   -- Print_XMI                  --
   --------------------------------

   overriding procedure Print_XMI
     (File : Ada.Text_IO.File_Type;
      Res : in out Packet_Based_Network;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      -- Iterator : Drivers.Lists.Index;
      The_Scheduler : Mast.Schedulers.Primary.Primary_Scheduler_Ref;      
   begin
      Mast.XMI.Add_Element_List_Item;      
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put_Line(File, "<Element_List");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));      
      Ada.Text_IO.Put_Line
        (File,"xsi:type=""mast2:Packet_Based_Network""");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));      
      Ada.Text_IO.Put_Line    
         (File, "name=""" & XMI.XMI_Name_Image(Res.Name, "net_") & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));      
      Ada.Text_IO.Put_Line
        (File,"Speed_Factor=""" &
         IO.Speed_Image(Res.Speed_Factor) & """ ");
      
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
           (File,"Throughput=""" &
         IO.Int_Bit_Count_Image
         (Bit_Count(Processor_Speed(Res.The_Throughput)))
         & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));      
      Ada.Text_IO.Put_Line
        (File,"Transmission_Kind=""" &
         Transmission_Kind'Image(Res.Transmission_Mode) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));      
      Ada.Text_IO.Put
        (File,"Max_Blocking=""" &
         IO.Execution_Time_Image(Res.Max_Blocking) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));      
      Ada.Text_IO.Put_Line
   (File,"Max_Packet_Size=""" &
      IO.Int_Bit_Count_Image(Max_Packet_Size(Res)) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));      
      Ada.Text_IO.Put_Line
   (File,"Min_Packet_Size=""" &
      IO.Int_Bit_Count_Image(Max_Packet_Size(Res)) & """>");
      if Drivers.Lists.Size(Res.List_Of_Drivers) >0 then
         Drivers.Print_XML(File,Res.List_Of_Drivers,Indentation+2);
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put_Line(File,"</Element_List>");
   end Print_XMI;
   
   --------------------------------
   -- Print_XMI_results              --
   --------------------------------

   overriding procedure Print_XMI_Results
     (File : Ada.Text_IO.File_Type;
      Res : Packet_Based_Network;
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
           (File,"xsi:type=""mast2_res:Network_Result""");
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
           (File,"xsi:type=""mast2:Packet_Based_Network""");
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+6));
         Ada.Text_IO.Put_Line  
      (File, "href=""" & 
         To_String(Mast.XMI.Get_XMI_Model_File) &
         "#" & XMI.XMI_Name_Image(Res.Name, "net_") & """/>");  
    
         if Res.The_Utilization_Result/=null then
            Results.Print_XMI
              (File,Res.The_Utilization_Result.all,Indentation+2,False);
         end if;
             
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
         Ada.Text_IO.Put_Line(File,"</Element_List>");
      end if;
   end Print_XMI_Results;
   

   -------------------
   -- Remove_Driver --
   -------------------

   procedure Remove_Driver
     (Net : in out Network;
      The_Driver : Mast.Drivers.Driver_Ref)
   is
      Ind : Drivers.Lists.Index;
      Drv_Ref : Mast.Drivers.Driver_Ref;
   begin
      Ind:=Drivers.Lists.Find(The_Driver,Net.List_Of_Drivers);
      if Ind=Drivers.Lists.Null_Index then
         raise List_Exceptions.Not_Found;
      end if;
      Drivers.Lists.Delete(Ind,Drv_Ref,Net.List_Of_Drivers);
   end Remove_Driver;

   ------------------------
   -- Rewind_Drivers     --
   ------------------------

   procedure Rewind_Drivers
     (Net : Network;
      Iterator : out Driver_Iteration_Object)
   is
   begin
      Drivers.Lists.Rewind
        (Net.List_Of_Drivers,
         Drivers.Lists.Iteration_Object(Iterator));
   end Rewind_Drivers;

   ----------------------
   -- Set_Max_Blocking --
   ----------------------

   procedure Set_Max_Blocking
     (Net  : in out Packet_Based_Network;
      The_Max_Blocking : Normalized_Execution_Time)
   is
   begin
      Net.Max_Blocking:=The_Max_Blocking;
   end Set_Max_Blocking;

   -------------------------
   -- Set_Max_Packet_Size --
   -------------------------

   procedure Set_Max_Packet_Size
     (Net  : in out Packet_Based_Network;
      The_Max_Size : Bit_Count)
   is
   begin
      Net.Max_Packet_Size:=The_Max_Size;
      Net.Max_Packet_Units_Are_Time:=False;
   end Set_Max_Packet_Size;

   -------------------------
   -- Set_Min_Packet_Size --
   -------------------------

   procedure Set_Min_Packet_Size
     (Net  : in out Packet_Based_Network;
      The_Min_Size : Bit_Count)
   is
   begin
      Net.Min_Packet_Size:=The_Min_Size;
      Net.Min_Packet_Units_Are_Time:=False;
   end Set_Min_Packet_Size;

   -------------------------------------
   -- Set_Max_Packet_Transmission_Time --
   ------------------------------------

   procedure Set_Max_Packet_Transmission_Time
     (Net  : in out Packet_Based_Network;
      The_Max_Transmission_Time : Normalized_Execution_Time)
   is
   begin
      Net.Max_Packet_Transmission_Time:=The_Max_Transmission_Time;
      Net.Max_Packet_Units_Are_Time:=True;
   end Set_Max_Packet_Transmission_Time;

   -------------------------------------
   -- Set_Min_Packet_Transmission_Time --
   ------------------------------------

   procedure Set_Min_Packet_Transmission_Time
     (Net  : in out Packet_Based_Network;
      The_Min_Transmission_Time : Normalized_Execution_Time)
   is
   begin
      Net.Min_Packet_Transmission_Time:=The_Min_Transmission_Time;
      Net.Min_Packet_Units_Are_Time:=True;
   end Set_Min_Packet_Transmission_Time;

   ---------------------------
   -- Set_Transmission_Mode --
   ---------------------------

   procedure Set_Throughput
     (Net  : in out Network;
      The_Throughput : Throughput_Value)
   is
   begin
      Net.The_Throughput:=The_Throughput;
   end Set_Throughput;

   ---------------------------
   -- Set_Transmission_Mode --
   ---------------------------

   procedure Set_Transmission_Mode
     (Net  : in out Network;
      The_Transmission_Mode : Transmission_Kind)
   is
   begin
      Net.Transmission_Mode:=The_Transmission_Mode;
   end Set_Transmission_Mode;

   ---------------------------
   -- Set_Transmission_Mode --
   ---------------------------

   function Transmission_Mode
     (Net  : Network) return Transmission_Kind
   is
   begin
      return Net.Transmission_Mode;
   end Transmission_Mode;

   ----------------
   -- Throughput --
   ----------------

   function Throughput
     (Net  : Network) return Throughput_Value
   is
   begin
      return Net.The_Throughput;
   end Throughput;

end Mast.Processing_Resources.Network;
