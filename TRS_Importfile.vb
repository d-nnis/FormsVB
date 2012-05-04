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
	Style = 4 + 32	' Buttons: Yes&No, QuestionMark
	intRet = MsgBox(msg, Style, "Transaction Description")
	

	'MsgBox intRet
 
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

	Set objTransField = objCurrFormDef.AddTransField(intTRSPos)
	
	objTransField.Name = "#Importfile"
	objTransField.Index = 0
	objTransField.Format = "X(100)"
	objTransField.Length = 100
	objTransField.Expression = 100
	MsgBox objTransField.Name & " hat TRS-Position:" & intTRSPos
	
    intRet = objTransField.Save
    If intRet <> 0 Then
		OnMngrFormDefTransDefault = EV_ERROR
		Exit Function
    End If	
	
	intTRSPos = intTRSPos + 1
	MsgBox "intTRSpos:" & intTRSpos & ", intFieldNo" & intFieldNo
	
    'Loops through the fields on the form definition and creates
    'three transaction fields for each
    For intFieldNo = 1 To intNoOfFields
		
		' Com ManagerApp object
		' ManagerApp.FormDef.FieldDefs.Item(IntFieldNo).Name

		MsgBox "in For-Loop: intTRSpos:" & intTRSpos & ", intFieldNo" & intFieldNo
		Set objFormField = objForm.Item(intFieldNo)
		

		
			With objFormField 
			'msg = "nach with: Feldname:" & .Name
			'MsgBox msg
				
				'ManagerApp.FormDef.FieldDefs.Item(intFieldNo)
				'objFormField.Item(IntFieldNo)
				
				'#If
				' Object:ManagerApp.Formdef.AddTransField(intTRSPos).Name
				' Object:ManagerApp.Formdef.AddTransField(intTRSPos).Index
				objTransField.Name = "#If"
				objTransField.Index = 0
				objTransField.Format = "N(1)"
				objTransField.Length = 0
				If .Index > 0 Then
					objTransField.Expression = "?" & .Name & _ 
							"[" & .Index & "]" 'Indexed
				Else
					objTransField.Expression = "?" & .Name
				End If
	 
				intRet = objTransField.Save
				If intRet <> 0 Then
					OnMngrFormDefTransDefault = EV_ERROR
					Exit Function
				End If
	 
				'The Field
				' Object:ManagerApp.FormDef.FieldDefs.Item(IntFieldNo).Name | .Index
				' 1 till Count
				intTRSPos = intTRSPos + 1
				Set objTransField = objCurrFormDef.AddTransField(intTRSPos)
				' Object:ManagerApp.Formdef.AddTransField(intTRSPos).Name = Object:ManagerApp.FormDef.FieldDefs.Item(IntFieldNo).Name
				objTransField.Name = .Name
				objTransField.Index = .Index
				objTransField.Format = .Format
				objTransField.Length = .GetMaxLengthFromFormat
				
				msg = "Feldname:" & .Name
				msg = msg & "Feldindex:" & .Index
				msg = msg & "Feldformat:" & .Format
				msg = msg & "Feld-maxLength:" & .GetMaxLengthFromFormat
				msg = msg & "TRS-Position:" & intTRSPos
				MsgBox msg
				
	 
				intRet = objTransField.Save
				If intRet <> 0 Then
					OnMngrFormDefTransDefault = EV_ERROR
					Exit Function
				End If
	 
				intTRSPos = intTRSPos + 1
				'#EndIf
				Set objTransField = objCurrFormDef.AddTransField(intTRSPos)
				objTransField.Name = "#EndIf"
				objTransField.Index = 0
				objTransField.Format = "N(1)"
				objTransField.Length = 0
	 
				intRet = objTransField.Save
				If intRet <> 0 Then
					OnMngrFormDefTransDefault = EV_ERROR
					Exit Function
				End If
	 
			End With
			intTRSPos = intTRSPos + 1
    Next intFieldNo
 
    OnMngrFormDefTransDefault = EV_OK_ABORT  ' Return value to FORMS
 
End Function
