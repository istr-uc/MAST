with Var_Strings, Hash_Lists;
-- use Var_Strings;
use type Var_Strings.Var_String;

package body Mast.XMI is
   
   -- Variable Containing The System used for printing an XMI file
   
   XMI_System : System;
   
   -- Variable containing the name of the file with the MAST model
   
   XMI_Model_File : Var_String := To_Var_String("unknown.xmi");
   
   -- Variable containing the number of Element_List items in the XMI file
   
   Num_Element_List_Items : Natural := 0;
   
   -- List of element names, used to prevent duplicate names
   
   --  function Name (V : Var_String) return Var_String;

   package Lists is new Hash_Lists (Var_String, Var_String, "=");
   
   The_List : Lists.List;
   
   --------------------
   -- Set_XMI_System --
   --------------------

   procedure Set_XMI_System (The_System: System) is
   begin
      XMI_System := The_System;
      Reset_Element_List;
   end Set_XMI_System;

   --------------------
   -- Get_XMI_System --
   --------------------

   function Get_XMI_System return System is
   begin
      return XMI_System;
   end Get_XMI_System;

   
   ------------------------
   -- Set_XMI_Model_File --
   ------------------------
   
   procedure Set_XMI_Model_File(Model_File: Var_String)
   is
   begin
      XMI_Model_File := Model_File;
   end Set_XMI_Model_File;
   
   ------------------------
   -- Get_XMI_Model_File --
   ------------------------
   
   function Get_XMI_Model_File return Var_String
   is
   begin
      return XMI_Model_File;
   end Get_XMI_Model_File;
   
   ------------------------
   -- Reset_Element_List --
   ------------------------

   procedure Reset_Element_List is
   begin
      Num_Element_List_Items := 0;
   end Reset_Element_List;
   
   ---------------------------
   -- Add_Element_List_Item --
   ---------------------------

   procedure Add_Element_List_Item is
   begin
      Num_Element_List_Items := Num_Element_List_Items + 1;
   end Add_Element_List_Item;
     
   ---------------------------
   -- Get_Size_Element_List --
   ---------------------------

   function Get_Size_Element_List return Natural is
   begin
      return Num_Element_List_Items-1;
   end Get_Size_Element_List;      
   
   --  ----------
   --  -- Name --
   --  ----------
   --  
   --  function Name (V : Var_String) return Var_String is
   --  begin
   --     return V;
   --  end Name;
   
   --------------------
   -- XMI_Name_Image --
   --------------------

   function XMI_Name_Image
     (Name: Var_String; Prefix: String) 
     return String
   is
   begin
      if Lists.Exists(To_Lower(Name), The_List) then
         if Lists.Item(To_Lower(Name), The_List) = To_Var_String(Prefix) then
            return To_String(Name);
         else
            return Prefix & To_String(Name);
         end if;
      else
         Lists.Add(To_Lower(Name), To_Var_String(Prefix), The_List);
         return To_String(Name);
      end if;
   end XMI_Name_Image;

   
end Mast.XMI;
