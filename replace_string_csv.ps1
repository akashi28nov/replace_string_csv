#============================================================
# 
#  �v���O�������Freplace_string_csv.ps1  ���t�@�C�����ύX�\
# CSV�t�@�C�����Freplace_string_csv.csv  ���v���O�������Ɠ����Ƃ���
# 
# �T�v
# CSV�t�@�C���̋L�ڏ�����ɕ�����u�������{���㏑���ۑ�����B
# 
# 
# 
# 
#============================================================

# �X�N���v�g�t�H���_
$script_home = $PSScriptRoot

# �X�N���v�g��
$script_name = Split-Path -Leaf $PSCommandPath

# ymd
$ymd = Get-Date -Format "yyyyMMdd_HHmmdd"

# ���O�t�H���_
$Log_folder = "$script_home\Log\"
# ���O�t�@�C��
$Log_file = $($script_name -replace "\.ps1","_$ymd.log")
# ���O�t�@�C��(�t���p�X)
$log = $Log_folder +  $Log_file

# CSV�t�@�C��
$csv_file =  $($script_name -replace "\.ps1$",".csv")
# CSV�t�@�C��(�t���p�X)
$csv = "$script_home\" + $csv_file

# ���O�t�H���_�쐬
if ( Test-Path "$script_home\Log")
{
}else{
   # ���O�t�H���_�쐬
   New-Item -ItemType Directory "$script_home\Log" > $null
}

# ���O�o��
& {
'======================================================='
"�J�n  $(get-date -Format "G")   "
'-------------------------------------------------------'
"�@�J�����g�t�H���_�F�@$((Get-Location).Path)"
"�X�N���v�g�t���p�X�F�@$PSCommandPath"
"�X�N���v�g�t�H���_�F�@$script_home"
"      �X�N���v�g���F�@$script_name"
"       CSV�t�@�C���F�@$csv_file"
"      ���O�t���p�X�F�@$log"

# CSV�t�@�C�����݃`�F�b�N
if (Test-Path $csv)
{
}else{
    "CSV�t�@�C����������܂���ł����B"
    "�t�@�C����"
    $CSV

    exit 1
}

# ������u��

# CSV�t�@�C���擾
$csv_dat = Get-Content $csv -Encoding Default | ? { $_ -notmatch '^#.*$'} | ConvertFrom-Csv -Delimiter "`t"

# CSV�t�@�C����1�s���ɏ���
'------------------'
"CSV�t�@�C������"
'------------------'
foreach( $csv in $csv_dat)
{
    # �t�@�C�����݃`�F�b�N
    if( !(Test-Path "$script_home\$($csv.File)"))
    {
        "��$($csv.File)��������܂���ł����B���ɐi�݂܂��B"
        ''
        continue
    }
    "$($csv.File)"
    "START $(get-date -Format "G")"
    "      $script_home\$($csv.File)"
    # �t�@�C���擾
    $dat = Get-Content "$script_home\$($csv.File)" -Encoding Default

    # ������u��, �t�@�C���o��
    $dat | % { $_ -replace $csv.Target,$csv.After } | Out-File "$script_home\$($csv.File)" -Encoding default

    "END   $(get-date -Format "G")"
    ''
}

'-------------------------------------------------------'
"�I��  $(get-date -Format "G")   "
'======================================================='
} | Tee-Object -FilePath $log 
