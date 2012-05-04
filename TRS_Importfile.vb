' Standard transaction example
' The following code illustrates the use of the TransField object and how to override the standard transaction in the Manager module. 
Function OnMngrFormDefTransDefault() As Long
' ---------------------------------------------------------------------
' Call this function in the MngrFormDefTransDefault event in the 
' Manager module.
' This function creates a standard transaction description for a
' form definition.
' It loops through the fields and creates three lines for each field.
' The result is that only filled-in field are transferred out in the 
' transfer output. All empty fields are skipped.
' ---------------------------------------------------------------------
    Dim objTransField As Object
	Dim objForm As Object
    Dim objFormField As Object
	Dim objCurrFormDef As Object
    Dim msg As String
	Dim Style
    Dim intRet As Integer, intTRSPos As Integer
    Dim intNoOfFields As Integer, intFieldNo As Integer
    msg = "Do you want a specially designed transaction description?"
	Style = 4 + 32	' Buttons: Yes&No, QuestionMark, Default-Button: first
	intRet = MsgBox(msg, Style, "Transaction Description")
 
    If intRet = 7 Then
        'The FORMS default transaction description is used.
        OnMngrFormDefTransDefault = EV_OK ' Return value to FORMS
        Exit Function
    End If
    
    Set objCurrFormDef = ManagerApp.FormDef
    intNoOfFields = objCurrFormDef.FieldDefs.Count
	MsgBox "intNoFields:" & intNoOfFields & "-"
	
	intTRSPos = 1
	intFieldNo = 1

	' Object:ManagerApp.FormDef.FieldDefs.Item(intFieldNo)
    ' ERR: Set objFormField = objCurrFormDef.FieldDefs.Item(intFieldNo)
	
	Set objForm = objCurrFormDef.FieldDefs
	' objFormField.Item(IntFieldNo)
	' Object: ManagerApp.Formdef.AddTransField(intTRSPos)


	
	''' Field
	Set objTransField = objCurrFormDef.AddTransField(intTRSPos)
	objTransField.Name = "#Importfile"
	objTransField.Index = 0
	objTransField.Format = "X(100)"
	objTransField.PadChar = " "
	objTransField.LeftJustify
	objTransField.Length = 100


    intRet = objTransField.Save
	REM MsgBox objTransField.Name & " hat TRS-Position:" & intTRSPos & "intRet:" & intRet
    If intRet <> 0 Then
		OnMngrFormDefTransDefault = EV_ERROR
		Exit Function
    End If	
	intTRSPos = intTRSPos + 1
	''' /Field

    'Loops through the fields on the form definition and creates
    'transaction fields for each
    For intFieldNo = 1 To intNoOfFields
	' 1 till Count
		' Com ManagerApp object
		' ManagerApp.FormDef.FieldDefs.Item(IntFieldNo).Name
		'MsgBox "in For-Loop: intTRSpos:" & intTRSpos & ", intFieldNo" & intFieldNo
		
		Set objFormField = objForm.Item(intFieldNo)
			With objFormField 
				'ManagerApp.FormDef.FieldDefs.Item(intFieldNo)
				'The Field
				intTRSPos = intTRSPos + 1
				Set objTransField = objCurrFormDef.AddTransField(intTRSPos)
				' Object:ManagerApp.Formdef.AddTransField(intTRSPos).Name = Object:ManagerApp.FormDef.FieldDefs.Item(IntFieldNo).Name
				objTransField.Name = .Name
				objTransField.Index = .Index
				objTransField.Format = .Format
				objTransField.Length = .GetMaxLengthFromFormat
				
				intRet = objTransField.Save
				
				REM msg = "Feldname:" & .Name
				REM msg = msg & "Feldindex:" & .Index
				REM msg = msg & "Feldformat:" & .Format
				REM msg = msg & "Feld-maxLength:" & .GetMaxLengthFromFormat
				REM msg = msg & "TRS-Position:" & intTRSPos
				REM msg = msg & "intRet:" & intRet
				REM MsgBox msg

				
				If intRet <> 0 Then
					OnMngrFormDefTransDefault = EV_ERROR
					Exit Function
				End If
	 
			End With
		intTRSPos = intTRSPos + 1
    Next intFieldNo
 
    OnMngrFormDefTransDefault = EV_OK_ABORT  ' Return value to FORMS
 
End Function


	REM ''' Field
	REM Set objTransField = objCurrFormDef.AddTransField(intTRSPos)
	REM objTransField.Name = "#Reference"
	REM objTransField.Index = 0
	REM objTransField.Format = "-" X(100)"
	REM objTransField.Length = 100
    REM intRet = objTransField.Save
	REM REM MsgBox objTransField.Name & " hat TRS-Position:" & intTRSPos & "intRet:" & intRet
    REM If intRet <> 0 Then
		REM OnMngrFormDefTransDefault = EV_ERROR
		REM Exit Function
    REM End If	
	REM intTRSPos = intTRSPos + 1
	REM ''' /Field







REM alt

	' DocPath1
	' DocPath2
	' DstDocPath1
	' DstDocPath2
	objTransField.Name = "#Importfile"

REM '#If
REM ' Object:ManagerApp.Formdef.AddTransField(intTRSPos).Name
REM ' Object:ManagerApp.Formdef.AddTransField(intTRSPos).Index
REM objTransField.Name = "#If"
REM objTransField.Index = 0
REM objTransField.Format = "N(1)"
REM objTransField.Length = 0
REM If .Index > 0 Then
	REM objTransField.Expression = "?" & .Name & _ 
			REM "[" & .Index & "]" 'Indexed
REM Else
	REM objTransField.Expression = "?" & .Name
REM End If

REM intRet = objTransField.Save
REM If intRet <> 0 Then
	REM OnMngrFormDefTransDefault = EV_ERROR
	REM Exit Function
REM End If