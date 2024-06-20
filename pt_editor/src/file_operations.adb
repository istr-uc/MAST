-----------------------------------------------------------------------
--                MAST Graphical Periodic Task Editor                --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 3 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, see                      --
-- <http://www.gnu.org/licenses/>.                                   --
--                                                                   --
-----------------------------------------------------------------------

with Var_Strings; use Var_Strings;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings; use Ada.Strings;

with Global_Options;
with Task_Table;
with Mutex_Table;
with Usage_Table;
with Results_Table;
with Check_Operations;
with Dialog1_Pkg; use Dialog1_Pkg;

with Mast;

package body File_Operations is

   type Section is (Global_Configuration, Tasks, Mutexes, Mutex_Usages);

   Name_In_Use, Name_Inexistent : exception;

   package Policy_IO is new Ada.Text_IO.Enumeration_IO(Global_Options.Policy);
   package Section_IO is new Ada.Text_IO.Enumeration_IO(section);

   ---------------------------
   -- Get_Complete_Filename --
   ---------------------------

   function Get_Complete_Filename (Filename : String) return String is
   begin
      if Filename'Length>4 and then
        Filename(Filename'Last-3..Filename'Last)=".pte"
      then
         return Filename;
      else
         return Filename&".pte";
      end if;
   end Get_Complete_Filename;

   procedure Put_Value
     (File : in out File_Type; Item : Var_String; Min_Width : Integer) is
      Col : Ada.Text_IO.Count :=Ada.Text_IO.Col(File);
   begin
      Put(File,To_String(Item)&" ");
      if Length(Item)<10 then
         Set_Col(File,Col+10);
      end if;
   end Put_Value;

   -----------
   -- Write --
   -----------

   procedure Write (Filename : String) is
      Rootname : Var_String;
      File : File_Type;
      Name,WCET,T,D,Prio,Taskname, Mutexname : Var_String;
   begin
      if Filename'Length>4 and then
        Filename(Filename'Last-3..Filename'Last)=".pte"
      then
         Rootname:=To_Var_String(Filename(Filename'First..Filename'Last-4));
      else
         raise Incorrect_File_Name;
      end if;
      Create(File,Out_File,Filename);

      -- Write global options
      Put(File,"Global_Configuration  ");
      Policy_IO.Put(File,Global_Options.Get_Policy);
      Ada.Text_IO.Put_Line(File,"   "&
                 Mast.Normalized_Execution_Time'Image
                 (Global_Options.Get_Context_Switch)&"   "&
                 Mast.Time'Image
                 (Global_Options.Get_Timer_Jitter));

      -- write tasks
      Put_Line(File,"Tasks "&Integer'Image(Task_Table.Num_Tasks));
      for Row in 1..Task_Table.Num_Tasks loop
         Task_Table.Get_Task(Row,Name,WCET,T,D,Prio);
         Put_Value(File,Name,10);
         Put_Value(File,WCET,10);
         Put_Value(File,T,10);
         Put_Value(File,D,10);
         Put_Line(File,Prio);
      end loop;

      -- write mutexes
      Put_Line(File,"Mutexes "&Integer'Image(Mutex_Table.Num_Mutexes));
      for Row in 1..Mutex_Table.Num_Mutexes loop
         Mutex_Table.Get_Mutex(Row,Name,Prio);
         Put_Value(File,Name,10);
         Put_Line(File,Prio);
      end loop;

      -- write mutex usages
      Put_Line(File,"Mutex_Usages "&Integer'Image(Usage_Table.Num_Usages));
      for Row in 1..Usage_Table.Num_Usages loop
         Usage_Table.Get_Usage(Row, Name, Taskname, Mutexname, WCET);
         Put_Value(File,Name,10);
         Put_Value(File,Taskname,10);
         Put_Value(File,Mutexname,10);
         Put_Line(File,WCET);
      end loop;


      Close(File);

   end Write;

   ----------
   -- Read --
   ----------

   procedure Read (Filename : String) is

      -- Word parsing operations

      function Find
        (Car : Character;Line : Var_String)
        return Natural is
      begin
         for i in 1..Length(Line) loop
            if Element(Line,i)=Car then
               return i;
            end if;
         end loop;
         return 0;
      end Find;

      function First_Word (Line : Var_String) return Var_string is
         Trimmed : Var_String;
         Pos_Space : Natural;
      begin
         for i in 1..Length(Line) loop
            if Element(Line,i)/=' ' then
               trimmed:=slice(line,i,length(line));
               pos_space := find(' ',trimmed);
               if pos_space=0 then
                  return trimmed;
               else
                  return slice (trimmed,1,pos_space-1);
               end if;
            end if;
         end loop;
         return Null_Var_String;
      end First_Word;

      function Delete_First_Word
        (Line : Var_String)
        return Var_string
      is
         Trimmed : Var_String;
         Pos_Space : Natural;
      begin
         for i in 1..Length(Line) loop
            if Element(Line,i)/=' ' then
               Trimmed:=slice(line,i,length(line));
               Pos_Space:=Find(' ',Trimmed);
               if Pos_Space=0 then
                  return Null_Var_String;
               else
                  return To_Var_String
                    (Trim(To_String(Slice(trimmed,Pos_Space,length(Trimmed))),
                                    Both));
               end if;
            end if;
         end loop;
         return Null_Var_String;
      end Delete_First_Word;

      Num : Natural;
      File : File_Type;
      Sect : Section;
      Line : Positive:=1;
      Text : Var_String;
      Name,WCET,T,D,Prio,Taskname, Mutexname,CSwitch,TJitter : Var_String;
      Pol : Global_Options.Policy;

   begin
      Open(File,In_File,Filename);

      ----------------------------
      -- Read Global Configuration
      ----------------------------
      Section_IO.Get(File,Sect);
      if Sect/=Global_Configuration then
         raise Data_Error;
      end if;

      -- Get Policy
      Policy_IO.Get(File,Pol);
      Global_Options.Set_Policy(Pol);

      --Get Context switch
      Get_Line(File,Text);
      Line:=Line+1;
      Cswitch:=First_Word(Text);
      if CSwitch=Null_Var_String then
         raise Data_Error;
      end if;
      Global_Options.Set_Context_Switch
        (Mast.Normalized_Execution_Time'Value(To_String(Cswitch)));
      --Get Timer jitter
      Text:=Delete_First_Word(Text);
      Tjitter:=First_Word(Text);
      if Tjitter=Null_Var_String then
         raise Data_Error;
      end if;
      Global_Options.Set_Timer_Jitter(Mast.Time'Value(To_String(Tjitter)));

      -------------
      -- Read tasks
      -------------
      Task_Table.Initialize;

      Section_IO.Get(File,Sect);
      if Sect/=Tasks then
         raise Data_Error;
      end if;

      --Get number of tasks
      Get(File,Num);
      Skip_Line(File);
      Line:=Line+1;

      -- Loop for all tasks
      for I in 1..Num loop
         Get_Line(File,Text);
         Line:=Line+1;
         -- Get Name
         Name:=First_Word(Text);
         if Name=Null_Var_String then
            raise Data_Error;
         end if;

         -- Get  WCET
         Text:=Delete_First_Word(Text);
         WCET:=First_Word(Text);
         if WCET=Null_Var_String then
            raise Data_Error;
         end if;

         -- Get  T
         Text:=Delete_First_Word(Text);
         T:=First_Word(Text);
         if T=Null_Var_String then
            raise Data_Error;
         end if;

         -- Get  D
         Text:=Delete_First_Word(Text);
         D:=First_Word(Text);
         if D=Null_Var_String then
            raise Data_Error;
         end if;

         -- Get  Prio
         Text:=Delete_First_Word(Text);
         Prio:=First_Word(Text);
         if Prio=Null_Var_String then
            raise Data_Error;
         end if;

         -- Check errors and update table
         if Check_Operations.Is_Correct_Identifier(To_String(Name)) and then
           Check_Operations.Is_Correct_Time(To_String(WCET)) and then
           Check_Operations.Is_Correct_Time(To_String(T)) and then
           Check_Operations.Is_Correct_Time(To_String(D)) and then
           Check_Operations.Is_Correct_Prio(To_String(Prio))
         then
            if Task_Table.Task_Name_Is_In_Use(To_String(Name)) then
               raise Name_In_Use;
            else
               Task_Table.Add_New_Task
                 (To_String(Name),To_String(WCET),
                  To_String(T),To_String(D),To_String(Prio));
            end if;
         else
            raise Data_Error;
         end if;

      end loop;
      ---------------
      -- Read Mutexes
      ---------------
      Mutex_Table.Initialize;

      Section_IO.Get(File,Sect);
      if Sect/=Mutexes then
         raise Data_Error;
      end if;

      --Get number of mutexes
      Get(File,Num);
      Skip_Line(File);
      Line:=Line+1;

      -- Loop for all mutexes
      for I in 1..Num loop
         Get_Line(File,Text);
         Line:=Line+1;
         -- Get Name
         Name:=First_Word(Text);
         if Name=Null_Var_String then
            raise Data_Error;
         end if;

         -- Get  Prio
         Text:=Delete_First_Word(Text);
         Prio:=First_Word(Text);
         if Prio=Null_Var_String then
            raise Data_Error;
         end if;

         -- Check errors and update table
         if Check_Operations.Is_Correct_Identifier(To_String(Name)) and then
           Check_Operations.Is_Correct_Prio(To_String(Prio))
         then
            if Mutex_Table.Mutex_Name_Is_In_Use(To_String(Name)) then
               raise Name_In_Use;
            else
               Mutex_Table.Add_New_Mutex(To_String(Name),To_String(Prio));
            end if;
         else
            raise Data_Error;
         end if;

      end loop;

      --------------------
      -- Read Mutex Usages
      --------------------
      Usage_Table.Initialize;

      Section_IO.Get(File,Sect);
      if Sect/=Mutex_Usages then
         raise Data_Error;
      end if;

      --Get number of mutex usages
      Get(File,Num);
      Skip_Line(File);
      Line:=Line+1;

      -- Loop for all mutex usages
      for I in 1..Num loop
         Get_Line(File,Text);
         Line:=Line+1;
         -- Get Name
         Name:=First_Word(Text);
         if Name=Null_Var_String then
            raise Data_Error;
         end if;

         -- Get  Taskname
         Text:=Delete_First_Word(Text);
         Taskname:=First_Word(Text);
         if Taskname=Null_Var_String then
            raise Data_Error;
         end if;

         -- Get  Mutexname
         Text:=Delete_First_Word(Text);
         Mutexname:=First_Word(Text);
         if Mutexname=Null_Var_String then
            raise Data_Error;
         end if;

         -- Get  WCET
         Text:=Delete_First_Word(Text);
         WCET:=First_Word(Text);
         if WCET=Null_Var_String then
            raise Data_Error;
         end if;

         -- Check errors and update table
         if Check_Operations.Is_Correct_Identifier(To_String(Name)) and then
           Check_Operations.Is_Correct_Identifier(To_String(Taskname)) and then
           Check_Operations.Is_Correct_Identifier(To_String(Mutexname)) and then
           Check_Operations.Is_Correct_Time(To_String(wcet))
         then
            if Usage_Table.Usage_Name_Is_In_Use(To_String(Name)) then
               raise Name_In_Use;
            else
               if Task_Table.Task_Name_Is_In_Use(To_String(Taskname)) and then
                 Mutex_Table.Mutex_Name_Is_In_Use(To_String(Mutexname))
               then
                  Usage_Table.Add_New_Usage
                    (To_String(Name),To_String(Taskname),
                     To_String(Mutexname),To_String(wcet));
               else
                  raise Name_Inexistent;
               end if;
            end if;
         else
            raise Data_Error;
         end if;

      end loop;

  -- Clear results
      Results_Table.Initialize;

      Close(File);
   exception
      when Name_Error =>
         Run_Dialog("Error: File "&Filename&" does not exist");
      when End_Error =>
         Run_Dialog("Error: Unexpected end of file");
         Close(File);
      when Data_Error =>
         Run_Dialog("Error: Incorrect format in Line "&Integer'Image(Line));
         Close(File);
      when Name_Inexistent =>
         Run_Dialog("Error: Inexistent task or mutex in Line "&
                      Integer'Image(Line));
         Close(File);
      when Name_In_Use =>
         Run_Dialog("Error: Repeated identifier in Line "&Integer'Image(Line));
         Close(File);
   end Read;

end File_Operations;
