
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
    Dim objFormField As Object
    Dim msg As String
    Dim intRet As Integer, intPos As Integer
    Dim intNoOfFields As Integer, intFieldNo As Integer
    msg = "Do you want a specially designed transaction description?"
    intRet = MsgBox(msg, vbYesNo, "Transaction Description")
 
    If intRet = vbNo Then
        'The FORMS default transaction description is used.
        OnMngrFormDefTransDefault = EV_OK ' Return value to FORMS
        Exit Function
    End If
 
    intPos = 1
    Set objCurrFormDef = ManagerApp.FormDef
    intNoOfFields = objCurrFormDef.FieldDefs.Count
 
    'Loops through the fields on the form definition and creates
    'three transaction fields for each
    For intFieldNo = 1 To intNoOfFields
        Set objFormField = objCurrFormDef.FieldDefs.Item(intFieldNo)
        Set objTransField = objCurrFormDef.AddTransField(intPos)
 
        With objFormField
            '#If
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
            intPos = intPos + 1
            Set objTransField = objCurrFormDef.AddTransField(intPos)
            objTransField.Name = .Name
            objTransField.Index = .Index
            objTransField.Format = .Format
            objTransField.Length = .GetMaxLengthFromFormat
 
            intRet = objTransField.Save
            If intRet <> 0 Then
                OnMngrFormDefTransDefault = EV_ERROR
                Exit Function
            End If
 
            '#Endif
            intPos = intPos + 1
            Set objTransField = objCurrFormDef.AddTransField(intPos)
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
        intPos = intPos + 1
    Next intFieldNo
 
    OnMngrFormDefTransDefault = EV_OK_ABORT  ' Return value to FORMS
 
End Function
