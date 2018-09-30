with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;
with Word_Lists;
with Ada.Characters.Handling;

procedure Words is

   package ATIO renames Ada.Text_IO;
   package ACL renames Ada.Command_Line;
   package ASU renames Ada.Strings.Unbounded;
   package WL renames Word_Lists;
   package ACH renames Ada.Characters.Handling;

   Usage_Error: exception;

   File_Name: ASU.Unbounded_String;
   File: Ada.Text_IO.File_Type;

   Finish: Boolean;
   Line: ASU.Unbounded_String;
   Word: ASU.Unbounded_String;
   List: WL.Word_List_Type;
   Space_Position: Integer;

   --Creo una lista vacía
--   function Word_List_Empty return Word_List_Type is
--      List: Word_List_Type;
--   begin
--      List := null;
--      return List;
--   end Word_List_Empty;

   --Elimino los espacios en blanco
   procedure Delete_Spaces(Line: in out ASU.Unbounded_String;
                           Space_Position: in out Integer) is
   begin
      while Space_Position = 1 loop
         Line := ASU.Tail(Line, ASU.Length(Line) - Space_Position);
         Space_Position := ASU.Index(Line," ");
      end loop;
   end Delete_Spaces;

begin

   if ACL.Argument_Count > 2 then
      raise Usage_Error;
   end if;

   if ACL.Argument_Count = 2 then
      File_Name := ASU.To_Unbounded_String(ACL.Argument(2));
   elsif ACL.Argument_Count = 1 then
      File_Name := ASU.To_Unbounded_String(ACL.Argument(1));
   end if;

   if ACL.Argument(1) = "-i" then
      ATIO.Put_Line("Options");
      ATIO.Put_Line("1 Add word");
      ATIO.Put_Line("2 Delete word");
      ATIO.Put_Line("3 Search word");
      ATIO.Put_Line("4 Show all words");
      ATIO.Put_Line("5 Quit");
      ATIO.New_Line;
      ATIO.Put_Line("Your option?");
   end if;
      
   ATIO.Open(File, ATIO.In_File, ASU.To_String(File_Name));

   Finish := False;
   
   --Leo el fichero y voy creando la lista
   while not Finish loop
      begin
	      Line := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(File));
	      Line := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Line)));
	      ATIO.Put_Line(ASU.To_String(Line));
         Space_Position:= ASU.Index(Line, " ");
			--ATIO.Put_Line("Antes del bucle" & Integer'Image(Space_Position));
         --Word := ASU.Head(Line, Space_Position -1);
			--WL.Add_Word(List, Word);
			--WL.Print_All(List);
			--ATIO. Put_Line("palabra: " & ASU.To_String(Word));         
			--Delete_Spaces(Line, Space_Position);

         while Space_Position /= 0 loop
            if Space_Position - 1 < 0 then
					ATIO. Put_Line("palabra: " & ASU.To_String(Word));
					Word := Line;
               WL.Add_Word(List, Word);
					Delete_Spaces(Line, Space_Position);
					--ATIO.Put("Palabras que llevo guardadas: ");
					--WL.Print_All(List);
				else
               Word := ASU.Head(Line, Space_Position -1);
					ATIO. Put_Line("000000palabra: " & ASU.To_String(Word));
               WL.Add_Word(List, Word);
               Line := ASU.Tail(Line, ASU.Length(Line) - Space_Position);
					Space_Position := ASU.Index(Line, " ");
					ATIO.Put_Line("Space_Position dentro del bucle" &
										 Integer'Image(Space_Position));
               Delete_Spaces(Line, Space_Position);
					ATIO.Put("Palabras que llevo guardadas: ");
					WL.Print_All(List);
            end if;
         end loop;
         
      exception
	      when Ada.IO_Exceptions.End_Error =>
	       Finish := True;
      end;
   end loop;
   
   Ada.Text_IO.Close(File);

exception

   when Usage_Error =>
      Ada.Text_IO.Put_Line("Use: ");
      Ada.Text_IO.Put_Line("       " & ACL.Command_Name & " <file>");

end Words;
