#========================================
# MuscariModpackUpdater.ps1
#
# 更新履歴
# 日付       バージョン 更新内容 作業者
# 2024/12/16 1.0.0     新規作成 Tomotomo_
#========================================

Function extractModpack($mpFileName) {
    #GitHubからModのZipファイルを取得
    Invoke-WebRequest -Uri "https://github.com/MuscariServer/ClayiumModpack/releases/download/Release/$mpFileName" -OutFile ".\$mpFileName"

    #フォームの入力が間違っている場合の処理を追加
    $judgeFile = Get-ChildItem -Filter *$mpFileName*
    if ($judgeFile -eq $null){
        $wsobj = new-object -comobject wscript.shell
        $result = $wsobj.popup("存在しないModpack、またはバージョンです。",0,"MuscariModpackUpdater",16)
    } else {
    #ダウンロードしたzipファイルを展開
    Expand-Archive -Path ".\$mpFileName" -DestinationPath "." -Force

    #zipファイルを削除
    Remove-Item -Path ".\$mpFileName"
    
    $wsobj = new-object -comobject wscript.shell
    $result = $wsobj.popup("処理が正常に終了しました。",0,"MuscariModpackUpdater",0)
    }
}

#アセンブリの読み込み
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#フォントの指定
$Font = New-Object System.Drawing.Font("メイリオ",12,[System.Drawing.FontStyle]::Bold)

#Modpack、バージョン入力のフォームを作成
$Form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(400,300) 
$Form.Text = "Muscari Modpack Updater"
$Form.font = $Font
$Form.BackColor = "DimGray"

#Modpackリストを作成
$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10,10) 
$label1.Size = New-Object System.Drawing.Size(250,20) 
$label1.Forecolor = "White"
$label1.Text = "Modpackを選択してください。"

$Combo = New-Object System.Windows.Forms.Combobox
$Combo.Location = New-Object System.Drawing.Point(10,40)
$Combo.size = New-Object System.Drawing.Size(200,30)
$Combo.DropDownStyle = "DropDown"
$Combo.FlatStyle = "standard"
$Combo.font = $Font

#Modpackリスト
[void] $Combo.Items.Add("Journey-of-Clayium")

#バージョンの入力ボックスを作成
$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,90) 
$label2.Size = New-Object System.Drawing.Size(400,20) 
$label2.Forecolor = "White"
$label2.Text = "Modpackのバージョンを入力してください。"

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,120)
$textBox.Size = New-Object System.Drawing.Size(100,200)

#実行ボタンを作成
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(10,180)
$OKButton.Size = New-Object System.Drawing.Size(75,30)
$OKButton.Text = "実行"
$OKButton.Forecolor = "Black"
$OKButton.Backcolor = "White"
$OKButton.Add_Click({
        #ここでまとめる
        $nameModpack = $Combo.Text
        $version = $textBox.Text
        $fusion = "$nameModpack-$version-Diff.zip"
        $Form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        extractModpack $fusion
        $Form.Close()
    })

# キャンセルボタンを作成
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(100,180)
$CancelButton.Size = New-Object System.Drawing.Size(75,30)
$CancelButton.Text = "Cancel"
$CancelButton.Forecolor = "Black"
$CancelButton.Backcolor = "White"
$CancelButton.Add_Click({
        $Form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $Form.Close()
    })

$form.Controls.Add($pic) 
$form.Controls.Add($label1)
$form.Controls.Add($Combo)
$form.Controls.Add($label2)
$form.Controls.Add($textBox)
$form.Controls.Add($OKButton)
$form.Controls.Add($CancelButton)

$Form.ShowDialog()
