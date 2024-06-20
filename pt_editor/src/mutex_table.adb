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

with Glib; use Glib;
with Gtk.Tree_View;            use Gtk.Tree_View;
with Gtk.Tree_Model;           use Gtk.Tree_Model;
with Gtk.Tree_View_Column;     use Gtk.Tree_View_Column;
with Gtk.Tree_Store;           use Gtk.Tree_Store;
with Gtk.Tree_Selection;       use Gtk.Tree_Selection;
with Gtk.Label; use Gtk.Label;
with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Widget; use Gtk.Widget;

with Pt_Editor_Pkg; use Pt_Editor_Pkg;
with Pt_Editor_Intl; use Pt_Editor_Intl;
with Ada.Text_IO; use Ada.Text_IO;
with Dialog1_Pkg; use Dialog1_Pkg;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings; use Ada.Strings;

package body Mutex_Table is

   Last_Mutex : Natural:=0;


   ------------------
   -- Add_New_Mutex --
   ------------------

   procedure Add_New_Mutex (Prio : String) is
      Num : String:=Integer'Image(Last_Mutex+1);
   begin
      loop
        declare
           Num : String:=Integer'Image(Last_Mutex+1);
        begin
           if Mutex_Name_Is_In_Use("M"&Num(Num'First+1..Num'Last)) then
              Last_Mutex:=Last_Mutex+1;
           else
              Add_New_Mutex("M"&Num(Num'First+1..Num'Last),Prio);
              exit;
           end if;
        end;
      end loop;
   end Add_New_Mutex;

   ------------------
   -- Add_New_Mutex --
   ------------------

   procedure Add_New_Mutex (Name, Prio : String) is
      Parent : Gtk_Tree_Iter := Null_Iter;
      Iter : Gtk_Tree_Iter:=Get_Iter_First(Pt_Editor.Mutex_Treemodel);
   begin
      Last_Mutex:=Last_Mutex+1;
      Append(Pt_Editor.Mutex_Treemodel, Iter, Parent);
      Set(Pt_Editor.Mutex_Treemodel, Iter, Name_Col, -(Name));
      Set(Pt_Editor.Mutex_Treemodel, Iter, Prio_Col, -(Prio));
      Set(Pt_Editor.Mutex_Treemodel, Iter, Background_Col, "white");
   end Add_New_Mutex;

   --------------------------
   -- Mutex Name Is in Use --
   --------------------------

   function Mutex_Name_Is_In_Use
     (Name : String)
     return Boolean
   is
      Iter : Gtk_Tree_Iter;
   begin
      -- Iterate over the rows
      Iter:=Get_Iter_First(Pt_Editor.Mutex_Treemodel);
      while Iter/=Null_Iter loop
         if To_Lower(Get_String(Pt_Editor.Mutex_Treemodel,Iter,Name_Col))=
           To_Lower(Name)
         then
            return True;
         end if;
         Next(Pt_Editor.Mutex_Treemodel,Iter);
      end loop;
      return False;
   end Mutex_Name_Is_In_Use;

   --------------------------
   -- Mutex_Name_Is_Unique --
   --------------------------

   function Mutex_Name_Is_Unique
     (Name : String; In_Row : Positive)
     return Boolean
   is
      Iter : Gtk_Tree_Iter;
      Row : Positive:=1;
   begin
      -- Iterate over the rows
      Iter:=Get_Iter_First(Pt_Editor.Mutex_Treemodel);
      while Iter/=Null_Iter loop
         if Row/=In_Row then
            if To_Lower(Get_String(Pt_Editor.Mutex_Treemodel,Iter,Name_Col))=
              To_Lower(Name)
            then
               return False;
            end if;
         end if;
         Next(Pt_Editor.Mutex_Treemodel,Iter);
         Row:=Row+1;
      end loop;
      return True;
   end Mutex_Name_Is_Unique;


   ---------------------
   -- Fill_Mutex_Names --
   ---------------------

   procedure Fill_Mutex_Names (Combo : in out Gtk_Combo_Box_Text) is
      Iter : Gtk_Tree_Iter;
      Num : Natural:=0;
   begin
      for Row in 1..N_Children(Get_Model(Combo)) loop
         Remove(Combo,0);
      end loop;
      Iter:=Get_Iter_First(Pt_Editor.Mutex_Treemodel);
      while Iter/=Null_Iter loop
         Num:=Num+1;
         Append_Text
           (Combo,Get_String(Pt_Editor.Mutex_Treemodel,Iter,Name_Col));
         Next(Pt_Editor.Mutex_Treemodel,Iter);
      end loop;
      if Num>0 then
         Set_Active(Combo,0);
      end if;
   end Fill_Mutex_Names;

   --------------
   -- Get_Mutex --
   --------------

   procedure Get_Mutex
     (Row : Positive; Name, Prio : out Var_String)
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      if Row>Num_Mutexes then
         raise Incorrect_Row;
      end if;
      Iter:=Nth_Child(Pt_Editor.Mutex_Treemodel,Parent,Gint(Row-1));
      Name:=To_Var_String
        (Get_String(Pt_Editor.Mutex_Treemodel,Iter,Name_Col));
      Prio:=To_Var_String
        (Get_String(Pt_Editor.Mutex_Treemodel,Iter,Prio_Col));
   end Get_Mutex;


   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Clear(Pt_Editor.Mutex_Treemodel);
   end Initialize;


   ---------------
   -- Num_Mutexes --
   ---------------

   function Num_Mutexes return Natural is
   begin
      return Natural(N_Children(Pt_Editor.Mutex_Treemodel));
   end Num_Mutexes;


   ---------------------------
   -- Delete_Selected_Mutex --
   ---------------------------

   procedure Delete_Selected_Mutex(Deleted : out Boolean) is
      Selection : Gtk_Tree_Selection;
      Iter : Gtk_Tree_Iter;
      Model : Gtk_Tree_Model;
   begin
      Deleted:=False;
      -- Get the selected row
      Selection:=Get_Selection(Pt_Editor.Mutex_Treeview);
      if Count_Selected_Rows(Selection)=1 then
         Get_Selected(Selection,Model,Iter);
         if Iter/=Null_Iter then
            Remove(Pt_Editor.Mutex_Treemodel,Iter);
            Deleted:=True;
         else
            Ada.Text_IO.Put_Line("No selected row");
         end if;
      else
         Ada.Text_IO.Put_Line("No single selected row");
      end if;
   end Delete_Selected_Mutex;


   -------------------------
   -- Selected_Mutex_Name --
   -------------------------

   function Selected_Mutex_Name return String is
      Selection : Gtk_Tree_Selection;
      Iter : Gtk_Tree_Iter;
      Model : Gtk_Tree_Model;
   begin
      -- Get the selected row
      Selection:=Get_Selection(Pt_Editor.Mutex_Treeview);
      Get_Selected(Selection,Model,Iter);
      if Iter=Null_Iter then
         return "";
      else
         return Get_String(Pt_Editor.Mutex_Treemodel,Iter,Name_Col);
      end if;
   end Selected_Mutex_Name;

   ------------------
   -- Set_Priority --
   ------------------

   procedure Set_Priority(Name : String; Prio : Natural) is
      Iter : Gtk_Tree_Iter;
   begin
      Iter:=Get_Iter_First(Pt_Editor.Mutex_Treemodel);
      while Iter/=Null_Iter loop
         if To_Lower(Get_String(Pt_Editor.Mutex_Treemodel,Iter,Name_Col))=
           To_Lower(Name)
         then
            -- Name was found; change priority and exit loop
            Set(Pt_Editor.Mutex_Treemodel,Iter,Prio_Col,
              -(Trim(Natural'Image(Prio),Both)));
            exit;
         end if;
         Next(Pt_Editor.Mutex_Treemodel,Iter);
      end loop;
   end Set_Priority;


end Mutex_Table;
