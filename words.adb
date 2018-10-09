with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;
with Word_Lists; use Word_Lists; 
with Ada.Characters.Handling;
with Ada.Strings.Maps;

procedure Words is

   package ATIO renames Ada.Text_IO;
   package ACL renames Ada.Command_Line;
   package ASU renames Ada.Strings.Unbounded;
   package WL renames Word_Lists;
   package ACH renames Ada.Characters.Handling;
	package ASM renames Ada.Strings.Maps;
	use type ASU.Unbounded_String;

   Usage_Error: exception;

   File_Name: ASU.Unbounded_String;
   File: Ada.Text_IO.File_Type;

   Finish: Boolean;
   Line: ASU.Unbounded_String;
   Word: ASU.Unbounded_String;
   List: WL.Word_List_Type;
	Count: Natural;
	Word_In_Menu: ASU.Unbounded_String;
	Option: ASU.Unbounded_String;
	Finish_Interactive: Boolean;
	Variable_Aux: Boolean:=False;

   --Elimino los espacios en blanco
   procedure Delete_Spaces(Line: in out ASU.Unbounded_String;
                           Space_Position: in out Integer) is
   begin
		--Cada vez que veo un espacio, Line pasa a ser lo que hay 
		--detrás del espacio y se vuelve a buscar Space_Position
      while Space_Position = 1 loop
         Line := ASU.Tail(Line, ASU.Length(Line) - Space_Position);
         Space_Position := ASU.Index(Line, ASM.To_Set(" ,.-_\|!?()[]{}'*+^`´¨=/&¬%$·#@ºª€"));
      end loop;
   end Delete_Spaces;

	--Troceo el texto del fichero
	procedure Trocea(Line: in out ASU.Unbounded_String;
							Word: out ASU.Unbounded_String) is
		Space_Position: Integer;
		Finish: Boolean;
	begin
		Finish := False;
		while not Finish loop
			Space_Position := ASU.Index(Line, ASM.To_Set(" ,.-_\|!?()[]{}'*+^`´¨=/&¬%$·#@ºª€"));
			if Space_Position = 1 then
				Delete_Spaces(Line, Space_Position);
			elsif Space_Position = 0 then
				Word := ASU.Tail(Line, ASU.Length(Line) - Space_Position);
				if ASU.To_String(Word) /= "" then
					WL.Add_Word(List, Word);
				end if;
				Finish := True;
			else
				Word := ASU.Head(Line, Space_Position-1);
				WL.Add_Word(List, Word);
				Line := ASU.Tail(Line, ASU.Length(Line) - Space_Position);
			end if;
		end loop;
	end Trocea;

begin

   if ACL.Argument_Count > 2 or ACL.Argument_Count < 1 then
      raise Usage_Error;
	elsif ACL.Argument_Count = 1 then
		if ACL.Argument(1) = "-i" then
			raise Usage_Error;
		else
			File_Name := ASU.To_Unbounded_String(ACL.Argument(1));
		end if;
	elsif ACL.Argument_Count = 2 then
		if ACL.Argument(1) /= "-i" then
			raise Usage_Error;
		else
			File_Name := ASU.To_Unbounded_String(ACL.Argument(2));
		end if;
   end if;

	begin
		ATIO.Open(File, ATIO.In_File, ASU.To_String(File_Name));
		Finish := False;
		--Leo el fichero y voy creando la lista
		while not Finish loop
			begin
				Line := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(File));
				Line := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Line)));
				Trocea(Line, Word);
			exception
				when Ada.IO_Exceptions.End_Error =>
				 Finish := True;
			end;
		end loop;
  	Ada.Text_IO.Close(File);
	exception
		when ADA.IO_EXCEPTIONS.NAME_ERROR =>
		ATIO.Put_Line(ASU.To_String(File_Name) & ": File not found");
		Variable_Aux := True;
	end;

	if not Variable_Aux then
		if ACL.Argument_Count = 1 then
			ATIO.New_Line;
			WL.Max_Word(List, Word, Count);
			ATIO.New_Line(2);
			WL.Delete_List(List);
		end if;
	end if;

	if ACL.Argument_Count = 2 then
		File_Name := ASU.To_Unbounded_String(ACL.Argument(2));
		Finish_Interactive := False;
		while not Finish_Interactive loop
			if ACL.Argument(1) = "-i" then
				ATIO.New_Line;
				ATIO.Put_Line("Options");
				ATIO.Put_Line("1 Add word");
				ATIO.Put_Line("2 Delete word");
				ATIO.Put_Line("3 Search word");
				ATIO.Put_Line("4 Show all words");
				ATIO.Put_Line("5 Delete list");
				ATIO.Put_Line("6 Quit");
				ATIO.New_Line;
				ATIO.Put("Your option? ");
				Option := ASU.To_Unbounded_String(ATIO.Get_Line);
				ATIO.New_Line;
				if Option = "1" then
					ATIO.Put("Word? ");
					Word_In_Menu := ASU.To_Unbounded_String(ATIO.Get_Line);
					Word_In_Menu := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Word_In_Menu)));
					WL.Add_Word(List, Word_In_Menu);
					ATIO.Put_Line("Word |" & ASU.To_String(Word_In_Menu) & "| added");
					ATIO.New_Line;
				elsif Option = "2" then
					ATIO.Put("Word? ");
					Word_In_Menu := ASU.To_Unbounded_String(ATIO.Get_Line);
					Word_In_Menu := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Word_In_Menu)));
					begin
						WL.Delete_Word(List, Word_In_Menu);
						ATIO.New_Line;
					exception
						when Word_List_Error =>
							ATIO.Put_Line("Word |" & ASU.To_String(Word_In_Menu) 
												& "| is not in the list");
					end;
				elsif Option = "3" then
					ATIO.Put("Word? ");
					Word_In_Menu := ASU.To_Unbounded_String(ATIO.Get_Line);
					Word_In_Menu := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Word_In_Menu)));
					WL.Search_Word(List, Word_In_Menu, Count);
					ATIO.New_Line;
				elsif Option = "4" then
					begin
						WL.Print_All(List);
						ATIO.New_Line;
					exception
						when Word_List_Error =>
							ATIO.Put_Line("No words");
					end;
				elsif Option = "5" then
					WL.Delete_List(List);
					ATIO.Put_Line("No words. List is empty");
				elsif Option = "6" then
					WL.Max_Word(List, Word, Count);
					Finish_Interactive := True;
					ATIO.New_Line;
				else
					ATIO.Put_Line("Your option is not correct");
				end if;
			end if;
		end loop;
	end if;

exception

   when Usage_Error =>
		ATIO.Put_Line("usage: words [-i] <filename>");
	when CONSTRAINT_ERROR =>
		ATIO.Put_Line("There is not most frequent word, list is empty");
end Words;
