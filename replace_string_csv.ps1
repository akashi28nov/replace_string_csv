#============================================================
# 
#  プログラム名：replace_string_csv.ps1  ※ファイル名変更可能
# CSVファイル名：replace_string_csv.csv  ※プログラム名と同名とする
# 
# 概要
# CSVファイルの記載情報を基に文字列置換を実施し上書き保存する。
# 
# 
# 
# 
#============================================================

# スクリプトフォルダ
$script_home = $PSScriptRoot

# スクリプト名
$script_name = Split-Path -Leaf $PSCommandPath

# ymd
$ymd = Get-Date -Format "yyyyMMdd_HHmmdd"

# ログフォルダ
$Log_folder = "$script_home\Log\"
# ログファイル
$Log_file = $($script_name -replace "\.ps1","_$ymd.log")
# ログファイル(フルパス)
$log = $Log_folder +  $Log_file

# CSVファイル
$csv_file =  $($script_name -replace "\.ps1$",".csv")
# CSVファイル(フルパス)
$csv = "$script_home\" + $csv_file

# ログフォルダ作成
if ( Test-Path "$script_home\Log")
{
}else{
   # ログフォルダ作成
   New-Item -ItemType Directory "$script_home\Log" > $null
}

# ログ出力
& {
'======================================================='
"開始  $(get-date -Format "G")   "
'-------------------------------------------------------'
"　カレントフォルダ：　$((Get-Location).Path)"
"スクリプトフルパス：　$PSCommandPath"
"スクリプトフォルダ：　$script_home"
"      スクリプト名：　$script_name"
"       CSVファイル：　$csv_file"
"      ログフルパス：　$log"

# CSVファイル存在チェック
if (Test-Path $csv)
{
}else{
    "CSVファイルが見つかりませんでした。"
    "ファイル名"
    $CSV

    exit 1
}

# 文字列置換

# CSVファイル取得
$csv_dat = Get-Content $csv -Encoding Default | ? { $_ -notmatch '^#.*$'} | ConvertFrom-Csv -Delimiter "`t"

# CSVファイルを1行毎に処理
'------------------'
"CSVファイル処理"
'------------------'
foreach( $csv in $csv_dat)
{
    # ファイル存在チェック
    if( !(Test-Path "$script_home\$($csv.File)"))
    {
        "▲$($csv.File)が見つかりませんでした。次に進みます。"
        ''
        continue
    }
    "$($csv.File)"
    "START $(get-date -Format "G")"
    "      $script_home\$($csv.File)"
    # ファイル取得
    $dat = Get-Content "$script_home\$($csv.File)" -Encoding Default

    # 文字列置換, ファイル出力
    $dat | % { $_ -replace $csv.Target,$csv.After } | Out-File "$script_home\$($csv.File)" -Encoding default

    "END   $(get-date -Format "G")"
    ''
}

'-------------------------------------------------------'
"終了  $(get-date -Format "G")   "
'======================================================='
} | Tee-Object -FilePath $log 
