Attribute VB_Name = "Module1"
'***********************************************************************
'����ʵ�ֹ��ܣ����Ŵ��㷨���������ֵ
'***********************************************************************
Option Explicit
'��������2��N�η�������
Public N2(30) As Long
'������Eval����
Public Script As Object
'���淽ʽ
Public Enum CrossOver
    OnePointCrossOver             '���㽻��
    TwoPointCrossOver             '���㽻��
    UniformCrossOver              'ƽ������
End Enum
'ѡ��ʽ
Public Enum Selection
    RouletteWheelSelection        '���̶�ѡ��
    StochasticTourament           '�������ѡ��
    RandomLeagueMatches           '�������ѡ��
    StochasticUniversalSampleing  '�������ȡ��
End Enum
'���뷽ʽ
Public Enum EnCoding
    Binary                        '��׼�����Ʊ���
    Gray                          '������
End Enum
'�Զ�������
Type GAinfo
    Max As Double
    Cordinate() As Double
End Type


'*********************************** ��������ת������ ***********************************
'
'�� �� ���� BinaryToGray
'��    ���� Value - Ҫת���Ķ���������ʵֵ
'˵    ���� ��3��Ӧ�Ķ����Ʊ�ʾΪ0011�����ø������ʾΪ0010�����������valueΪ0011�����ʵ��
'           �����ص���0010�������ʵ����2��
'�� �� ֵ�� ���ظ������Ӧ�Ķ���������ʵֵ
'Դ �� �ߣ� laviewpbt
'�������ԣ� C����
'�� �� �ߣ� zsc
'
'*********************************** ��������ת������ ***********************************
Public Function BinaryToGray(Value As Long) As Long
    Dim V As Long, Max As Long
    Dim start As Long, mEnd As Long, Temp As Long, Counter As Long
    Dim Flag As Boolean
    V = Value: Max = 1
    While V > 0
        V = V / 2
        Max = Max * 2
    Wend
    If Max = 0 Then Exit Function
    Flag = True
    mEnd = Max - 1
    While start < mEnd
        Temp = (mEnd + start - 1) / 2
        If Value <= Temp Then
            If Not Flag Then
                Counter = Counter + (mEnd - start + 1) / 2
            End If
            mEnd = Temp
            Flag = True
        Else
            If Flag Then
                Counter = Counter + (mEnd - start + 1) / 2
            End If
            Temp = Temp + 1
            start = Temp
            Flag = False
        End If
    Wend
    BinaryToGray = Counter
End Function
'*********************************** ������ת�������� ***********************************
'
'�� �� ���� BinaryToGray
'��    ���� Value - Ҫת���Ķ���������ʵֵ
'˵    ���� ��3��Ӧ�Ķ����Ʊ�ʾΪ0011�����ø������ʾΪ0010�����������valueΪ0010�����ʵ��
'           �����ص���0010�������ʵ����2��
'�� �� ֵ�� ���ظ������Ӧ�Ķ���������ʵֵ
'Դ �� �ߣ� laviewpbt
'�������ԣ� C����
'�� �� �ߣ� zsc
'
'*********************************** ������ת�������� ***********************************
Public Function GrayToBinary(Value As Long) As Long
    Dim V As Long, Max As Long
    Dim start As Long, mEnd As Long, Temp As Long, Counter As Long
    Dim Flag As Boolean
    V = Value: Max = 1
    While V > 0
        V = V / 2
        Max = Max * 2
    Wend
    Flag = True
    mEnd = Max - 1
    While start < mEnd
        Temp = Counter + (mEnd - start + 1) / 2
        If Flag Xor (Value < Temp) Then
           If Flag Then Counter = Temp
           start = (start + mEnd + 1) / 2
           Flag = False
        Else
           If Not Flag Then Counter = Temp
           mEnd = (start + mEnd - 1) / 2
           Flag = True
        End If
    Wend
    GrayToBinary = start
End Function
'*********************************** ʮ����תת�������� ***********************************
'
'�� �� ���� DecToBinary
'��    ���� Value - Ҫת����ʮ������
'�� �� ֵ�� ���ض�Ӧ�Ķ�������
'��    �ߣ� laviewpbt
'�� �� �ߣ� zsc
'
'*********************************** ʮ����תת�������� ***********************************
Private Function DecToBinary(ByVal Value As Long) As String
    Dim StrTemp As String
    Dim ModNum As Integer
    Do While Value > 0
        ModNum = Value Mod 2
        Value = Value \ 2
        StrTemp = ModNum & StrTemp
    Loop
    DecToBinary = StrTemp
End Function
'************************************* ��ʮ����ת�� **********************************
'
'�� �� ���� BinToDec
'��    ���� BinCode - �������ַ���
'�� �� ֵ�� ת�����ʮ������
'˵    ���� �������ַ���ת��λʮ������
'��    �ߣ� laviewpbt
'�� �� �ߣ� zsc
'
'************************************* ��ʮ����ת�� **********************************
Public Function BinToDec(BinCode As String) As Long
    Dim i As Integer, Dec As Long, Length As Integer
    Length = Len(BinCode)
    For i = 1 To Length
        If Mid(BinCode, i, 1) = "1" Then
            Dec = Dec + N2(Length - i)
        End If
    Next
    BinToDec = Dec
End Function

'************************************* �����Ķ����ƴ�λ�� **********************************
'
'�� �� ���� GetIndex
'��    ���� Target - ������
'�� �� ֵ�� ĳһָ��
'˵    ���� �����2^(GetIndex-1)<Target<=2^GetIndex�� GetIndex
'��    �ߣ� laviewpbt
'�� �� �ߣ� zsc
'
'************************************* �����Ķ����ƴ�λ�� **********************************
Public Function GetIndex(Target As Long) As Integer
    Dim i As Integer
    For i = 0 To 30
        If Target <= N2(i) Then
            GetIndex = i
            Exit Function
        End If
    Next
End Function

'************************************ Eval��ִ̬��һ������ *********************************
'
'�� �� ���� CalcFun
'��    ���� Fun    - ����
'           Script - һ��ScriptControl����
'           X1     �� ��һ���Ա���
'           X2     �� �ڶ����Ա�������ѡ
'           X3     �� �������Ա�������ѡ
'           X4     �� ���ĸ��Ա�������ѡ
'˵    ���� ��ִ̬��һ�������������֧���ĸ����������ұ�������ʽֻ��дΪX1/X2/X3/X4,GA����
'           ִ������Ҫ�����Eval����������Ҫ����ʱ��
'��    �ߣ� laviewpbt
'�� �� �ߣ� zsc
'
'************************************ Eval��ִ̬��һ������ *********************************
Public Function CalcFun(ByVal Fun As String, Script As Object, X1 As Double, Optional X2 As Double, Optional X3 As Double, Optional X4 As Double) As Double
    Fun = Replace(Fun, "X1", CStr(X1))
    If Not IsMissing(X2) Then Fun = Replace(Fun, "X2", CStr(X2))
    If Not IsMissing(X3) Then Fun = Replace(Fun, "X3", CStr(X3))
    If Not IsMissing(X4) Then Fun = Replace(Fun, "X4", CStr(X4))
    CalcFun = Script.Eval(Fun)
End Function




