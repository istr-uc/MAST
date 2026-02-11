with Ada.Containers;
with Ada.Text_IO;
procedure Pr is
   
begin
   Ada.Text_IO.Put_Line
     (Ada.Containers.Hash_Type'Image(Ada.Containers.Hash_Type'Last));
end Pr;
