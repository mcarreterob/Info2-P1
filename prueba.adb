with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;
with Word_Lists;

procedure Prueba is
   package ATIO renames Ada.Text_IO;
   package ACL renames Ada.Command_Line;
   package ASU renames Ada.Strings.Unbounded;
   package WL renames Word_Lists;

   Usage_Error: exception;

   File_Name: ASU.Unbounded_String;
   File: Ada.Text_IO.File_Type;

   Finish: Boolean;
   Line: ASU.Unbounded_String;

   E : Natural;
   P1 : ASU.Unbounded_String;
   Tail : ASU.Unbounded_String;
   List: WL.Word_List_Type;

   procedure Delete_Spaces(Line: in out ASU.Unbounded_String;
                           Space_Position: in out Integer) is
   begin
      while Space_Position = 1 loop
         Line := ASU.Tail(Line, ASU.Length(Line) - Space_Position);
         Space_Position := ASU.Index(Line," ");
      end loop;
   end Delete_Spaces;
begin

   if ACL.Argument_Count /= 1 then
      raise Usage_Error;
   end if;
   
   File_Name := ASU.To_Unbounded_String(ACL.Argument(1));        
   Ada.Text_IO.Open(File, Ada.Text_IO.In_File, ASU.To_String(File_Name));

   Finish := False;



   while not Finish loop
      begin
	      Line := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(File));
	      --Ada.Text_IO.Put_Line(ASU.To_String(Line));
	      E := ASU.Index(Line, " ");
			Delete_Spaces(Line, E);
			--ATIO.Put_Line("valor de E: " & Natural'Image(E));
			if E = 0 and ASU.To_String(Line) /= "" then
				P1 := Line;
				WL.Add_Word(List, P1);
				ATIO.Put_Line("palabra |" & ASU.To_String(P1) & "|");
			else
				while ASU.To_String(Line) /= " " and E > 0 loop
					P1 := ASU.Head(Line, E - 1);
					WL.Add_Word(List, P1);
					Line := ASU.Tail(Line, ASU.Length(Line) - E);
					E := ASU.Index(Line, " ");
					ATIO.Put_Line("palabra |" & ASU.To_String(P1) & "|");
					Delete_Spaces(Line, E);
				end loop;
			end if;
      exception
	      when Ada.IO_Exceptions.End_Error =>
	       Finish := True;
      end;
   end loop;
	
	WL.Print_All(List);


   
   Ada.Text_IO.Close(File);

exception
   
   when Usage_Error =>
      Ada.Text_IO.Put_Line("Use: ");
      Ada.Text_IO.Put_Line("       " & ACL.Command_Name & " <file>");
   
end Prueba;
