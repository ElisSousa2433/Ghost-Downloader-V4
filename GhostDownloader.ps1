
Add-Type -AssemblyName PresentationFramework

$BaseDir = "C:\GhostDownloader"
$YTDLP = "$BaseDir\yt-dlp.exe"

$VideoDir = "$BaseDir\Downloads\Videos"
$MusicDir = "$BaseDir\Downloads\Musicas"
$LogDir = "$BaseDir\Logs"

$HistoryFile = "$LogDir\Historico.csv"
$ResultFile = "$LogDir\ultimo_download.txt"
$ProgressFile = "$LogDir\progresso.txt"
$OutputLog = "$LogDir\saida.txt"

New-Item -ItemType Directory -Force -Path $VideoDir, $MusicDir, $LogDir | Out-Null


if (!(Test-Path $HistoryFile)) {
    '"Data","Titulo","Formato","Caminho"' | Out-File $HistoryFile -Encoding UTF8
}
else {
    $Header = Get-Content $HistoryFile -TotalCount 1

    if ($Header -notmatch 'Caminho') {
        $OldHistory = Import-Csv $HistoryFile

        $OldHistory |
            Select-Object Data, Titulo, Formato |
            ForEach-Object {
                $_ | Add-Member -NotePropertyName Caminho -NotePropertyValue "" -PassThru
            } |
            Export-Csv "$HistoryFile.tmp" -NoTypeInformation -Encoding UTF8

        Move-Item "$HistoryFile.tmp" $HistoryFile -Force
    }
}

if (!(Test-Path $YTDLP)) {
    [System.Windows.MessageBox]::Show("yt-dlp.exe não encontrado em $YTDLP")
    return
}

# Atualizar yt-dlp automaticamente
try {

    $VersionBefore = ((& $YTDLP --version 2>$null | Select-Object -First 1) -join "").Trim()

    $UpdateOutput = @(& $YTDLP -U 2>&1)
    $UpdateExitCode = $LASTEXITCODE

    $VersionAfter = ((& $YTDLP --version 2>$null | Select-Object -First 1) -join "").Trim()

    if ($UpdateExitCode -ne 0) {

        $Details = ($UpdateOutput | Out-String).Trim()

        if ([string]::IsNullOrWhiteSpace($Details)) {
            $Details = "Erro desconhecido durante a atualizacao."
        }

        [System.Windows.MessageBox]::Show(
            "Nao foi possivel atualizar o yt-dlp.`n`n$Details`n`nO programa continuara usando a versao instalada.",
            "Ghost Downloader - Atualizacao",
            "OK",
            "Warning"
        ) | Out-Null

    }
    elseif ($VersionBefore -and $VersionAfter -and $VersionBefore -ne $VersionAfter) {

        [System.Windows.MessageBox]::Show(
            "yt-dlp atualizado com sucesso!`n`nVersao anterior: $VersionBefore`nNova versao: $VersionAfter",
            "Ghost Downloader - Atualizacao",
            "OK",
            "Information"
        ) | Out-Null

    }

}
catch {

    [System.Windows.MessageBox]::Show(
        "Falha ao verificar atualizacoes: $($_.Exception.Message)`n`nO programa continuara usando a versao instalada.",
        "Ghost Downloader - Atualizacao",
        "OK",
        "Warning"
    ) | Out-Null

}


[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ghost Downloader V4"
        Height="720"
        Width="900"
        MinHeight="650"
        MinWidth="780"
        WindowStartupLocation="CenterScreen"
        Background="#10131C"
        Foreground="#F1F3F9"
        ResizeMode="CanResize">

    <Window.Resources>
        <SolidColorBrush x:Key="PanelBrush" Color="#191E2B"/>
        <SolidColorBrush x:Key="AccentBrush" Color="#725CFF"/>

        <Style TargetType="Button">
            <Setter Property="Background" Value="#252C3D"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="12,9"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Margin" Value="4"/>
        </Style>

        <Style TargetType="TextBox">
            <Setter Property="Background" Value="#252C3D"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="FontSize" Value="14"/>
        </Style>

        <Style TargetType="ComboBox">
            <Setter Property="Background" Value="#252C3D"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="8"/>
            <Setter Property="FontSize" Value="14"/>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="190"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- MENU LATERAL -->
        <Border Grid.Column="0" Background="#171B27">
            <StackPanel Margin="18">

                <TextBlock Text="GHOST"
                           FontSize="25"
                           FontWeight="Bold"
                           Foreground="#927FFF"/>

                <TextBlock Text="DOWNLOADER V4"
                           FontSize="10"
                           Foreground="#929AAF"
                           Margin="0,0,0,35"/>

                <TextBlock Text="NAVEGACAO"
                           Foreground="#707B92"
                           FontSize="10"
                           Margin="0,0,0,12"/>

                <Button Name="btnHome"
                        Content="  Inicio"
                        HorizontalContentAlignment="Left"
                        Margin="0,2"/>

                <Button Name="btnHistory"
                        Content="  Historico"
                        HorizontalContentAlignment="Left"
                        Margin="0,2"/>

                <Button Name="btnOpen"
                        Content="  Abrir pasta"
                        HorizontalContentAlignment="Left"
                        Margin="0,2"/>

                <StackPanel VerticalAlignment="Bottom"
                            Margin="0,150,0,0">
                    <TextBlock Text="GHOST DOWNLOADER"
                               Foreground="#707B92"
                               FontSize="10"/>
                    <TextBlock Text="Versao 4.0"
                               Foreground="#929AAF"
                               FontSize="11"
                               Margin="0,5,0,0"/>
                </StackPanel>

            </StackPanel>
        </Border>

        <!-- AREA PRINCIPAL -->
        <Grid Grid.Column="1" Margin="28">

            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <StackPanel Grid.Row="0" Margin="0,5,0,28">
                <TextBlock Text="Central de Downloads"
                           FontSize="25"
                           FontWeight="Bold"/>

                <TextBlock Text="Baixe seus videos e musicas em poucos passos."
                           Foreground="#929AAF"
                           FontSize="13"
                           Margin="0,7,0,0"/>
            </StackPanel>

            <Border Grid.Row="1"
                    Background="{StaticResource PanelBrush}"
                    CornerRadius="12"
                    Padding="24">

                
<Grid>
    <Grid.RowDefinitions>
        <RowDefinition Height="Auto"/>
        <RowDefinition Height="Auto"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>

    <StackPanel Grid.Row="0">

        <TextBlock Text="NOVO DOWNLOAD"
                   Foreground="#927FFF"
                   FontWeight="Bold"
                   FontSize="11"
                   Margin="0,0,0,15"/>

        <TextBlock Text="URL do conteudo"
                   FontWeight="SemiBold"
                   Margin="0,0,0,9"/>

        <TextBox Name="txtURL"
                 Height="42"
                 VerticalContentAlignment="Center"
                 ToolTip="Cole aqui o endereco do video"/>

        <TextBlock Text="Formato de saida"
                   FontWeight="SemiBold"
                   Margin="0,15,0,9"/>

        <ComboBox Name="cmbFormat"
                  Height="40"
                  SelectedIndex="0">
            <ComboBoxItem Content="MP4"/>
            <ComboBoxItem Content="MP3"/>
        </ComboBox>

    </StackPanel>

    <StackPanel Grid.Row="1"
                Orientation="Horizontal"
                Margin="0,18,0,15">

        <Button Name="btnDownload"
                Content="ADICIONAR A FILA"
                Background="#725CFF"
                Height="42"
                Width="190"
                FontWeight="Bold"/>

        <Button Name="btnStartQueue"
                Content="INICIAR FILA"
                Background="#287A59"
                Height="42"
                Width="150"
                FontWeight="Bold"
                Margin="10,0,0,0"/>

        <Button Name="btnRemoveQueue"
                Content="REMOVER ITEM"
                Background="#963F4B"
                Height="42"
                Width="150"
                FontWeight="Bold"
                Margin="10,0,0,0"/>

                <Button x:Name="btnClearQueue"
        Content="LIMPAR FILA"
        Height="42"
        Margin="0,8,0,0"
        Background="#292D3E"
        Foreground="#FFFFFF"
        BorderThickness="0"
        Cursor="Hand"/>

    </StackPanel>

    <StackPanel Grid.Row="2">

        <TextBlock Text="FILA DE DOWNLOADS"
                   Foreground="#929AAF"
                   FontSize="11"
                   FontWeight="Bold"
                   Margin="0,0,0,10"/>

        <ListView Name="lstQueue"
                  Background="#171C29"
                  Foreground="#F1F3F9"
                  BorderBrush="#30394D"
                  BorderThickness="1"
                  MinHeight="150">

            <ListView.View>
                <GridView>
                    <GridViewColumn Header="URL"
                                    DisplayMemberBinding="{Binding URL}"
                                    Width="390"/>

                    <GridViewColumn Header="FORMATO"
                                    DisplayMemberBinding="{Binding Formato}"
                                    Width="85"/>

                    <GridViewColumn Header="STATUS"
                                    DisplayMemberBinding="{Binding Status}"
                                    Width="120"/>
                </GridView>
            </ListView.View>

        </ListView>

    </StackPanel>

    <StackPanel Grid.Row="3">

        <TextBlock Text="PROGRESSO"
                   Foreground="#929AAF"
                   FontSize="11"
                   FontWeight="Bold"
                   Margin="0,15,0,10"/>

        <ProgressBar Name="progressBar"
                     Minimum="0"
                     Maximum="100"
                     Value="0"
                     Height="12"
                     Background="#252C3D"
                     Foreground="#806CFF"/>

        <TextBlock Name="txtProgress"
                   Text="0%"
                   Foreground="#B8C0D3"
                   FontSize="12"
                   Margin="0,10,0,0"/>

        <Border Background="#252C3D"
                CornerRadius="6"
                Padding="12"
                Margin="0,15,0,0">

            <TextBlock Name="txtStatus"
                       Text="Pronto para iniciar"
                       Foreground="#C5CAD8"
                       FontSize="13"/>

        </Border>

    </StackPanel>
</Grid>

            </Border>

            <TextBlock Grid.Row="2"
                       Text="Ghost Downloader | Desenvolvido para uso pessoal"
                       Foreground="#626D83"
                       FontSize="10"
                       HorizontalAlignment="Right"
                       Margin="0,15,0,0"/>

        </Grid>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$Window = [Windows.Markup.XamlReader]::Load($reader)

$txtURL = $Window.FindName("txtURL")
$btnStartQueue = $Window.FindName("btnStartQueue")
$btnRemoveQueue = $Window.FindName("btnRemoveQueue")
$btnClearQueue = $Window.FindName("btnClearQueue")
$lstQueue = $Window.FindName("lstQueue")
$cmbFormat = $Window.FindName("cmbFormat")
$btnDownload = $Window.FindName("btnDownload")
$btnOpen = $Window.FindName("btnOpen")
$btnHistory = $Window.FindName("btnHistory")
$txtStatus = $Window.FindName("txtStatus")
$txtProgress = $Window.FindName("txtProgress")
$progressBar = $Window.FindName("progressBar")

$cmbFormat.SelectedIndex = 0

$script:DownloadProcess = $null
$script:DownloadFormat = $null
$script:Queue = [System.Collections.ObjectModel.ObservableCollection[object]]::new()
$lstQueue.ItemsSource = $script:Queue

$script:CurrentQueueItem = $null
$script:QueueRunning = $false

# Temporizador da interface
$script:Timer = New-Object System.Windows.Threading.DispatcherTimer
$script:Timer.Interval = [TimeSpan]::FromMilliseconds(700)


$script:Timer.Add_Tick({

    if ($null -eq $script:DownloadProcess) {
        $script:Timer.Stop()
        return
    }

    # Ler progresso do yt-dlp
    if (Test-Path $ProgressFile) {

        try {
            $Lines = Get-Content $ProgressFile -Tail 30 -ErrorAction Stop

            for ($i = $Lines.Count - 1; $i -ge 0; $i--) {

                $Line = [string]$Lines[$i]

                if ($Line -match 'download:') {

                    $Parts = $Line.Split('|')

                    if ($Parts.Count -ge 3) {

                        if ($Parts[0] -match '(\d+(?:\.\d+)?)%') {

                            $Percent = [double]$Matches[1]

                            $progressBar.IsIndeterminate = $false
                            $progressBar.Value = [Math]::Min(100, $Percent)

                            $Speed = $Parts[1].Trim()
                            $ETA = $Parts[2].Trim()

                            $txtProgress.Text = "$Percent%  |  $Speed  |  Restante: $ETA"

                            break
                        }
                    }
                }
            }
        }
        catch {}
    }

    # Verificar conclusao do processo
    if (!$script:DownloadProcess.HasExited) {
        return
    }

    $ExitCode = $script:DownloadProcess.ExitCode

    $script:DownloadProcess.Dispose()
    $script:DownloadProcess = $null

    $progressBar.IsIndeterminate = $false

    # Registrar download concluido
    if ($ExitCode -eq 0) {

        $OutputPath = ""

        if (Test-Path $ResultFile) {
            $OutputPath = (Get-Content $ResultFile -Raw -ErrorAction SilentlyContinue).Trim()
        }

        $Title = "Download concluido"

        if ($OutputPath) {
            $Title = [System.IO.Path]::GetFileNameWithoutExtension($OutputPath)
        }

        $Date = Get-Date -Format "dd/MM/yyyy HH:mm"

        $HistoryRow = [PSCustomObject]@{
            Data = $Date
            Titulo = $Title
            Formato = $script:DownloadFormat
            Caminho = $OutputPath
        }

        $CsvLine = $HistoryRow | ConvertTo-Csv -NoTypeInformation
        $CsvLine[1] | Add-Content -Path $HistoryFile -Encoding UTF8

        if ($null -ne $script:CurrentQueueItem) {
            $script:CurrentQueueItem.Status = "Concluido"
        }

        $progressBar.Value = 100
        $txtProgress.Text = "100%  |  Concluido"
        $txtStatus.Text = "Download concluido!"

    }
    else {

        if ($null -ne $script:CurrentQueueItem) {
            $script:CurrentQueueItem.Status = "Erro"
        }

        $txtStatus.Text = "Erro no download"

        $ErrorMessage = ""

        if (Test-Path $ProgressFile) {
            $ErrorMessage = Get-Content $ProgressFile -Tail 5 -ErrorAction SilentlyContinue |
                Where-Object { $_.Trim() } |
                Select-Object -Last 1
        }

        $txtProgress.Text = "Codigo de erro: $ExitCode"

        if ($ErrorMessage) {
            $txtStatus.Text = "Erro: $ErrorMessage"
        }
    }

    # Atualizar lista visual
    $lstQueue.Items.Refresh()

    # Liberar item atual
    $script:CurrentQueueItem = $null

    # Iniciar proximo download da fila
    Start-NextQueuedDownload

})


# Abrir pasta
$btnOpen.Add_Click({

    if ($cmbFormat.SelectedItem.Content -eq "MP3") {
        Start-Process explorer.exe -ArgumentList "`"$MusicDir`""
    }
    else {
        Start-Process explorer.exe -ArgumentList "`"$VideoDir`""
    }

})

# Janela de historico
$btnHistory.Add_Click({

    [xml]$HistoryXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
Title="Ghost Downloader - Historico"
Height="430"
Width="760"
WindowStartupLocation="CenterOwner"
ResizeMode="CanResize">

<Grid Margin="12">

<Grid.RowDefinitions>
<RowDefinition Height="*"/>
<RowDefinition Height="Auto"/>
</Grid.RowDefinitions>

<ListView Name="lstHistory" Grid.Row="0">
<ListView.View>
<GridView>
<GridViewColumn Header="Data" Width="135" DisplayMemberBinding="{Binding Data}"/>
<GridViewColumn Header="Titulo" Width="350" DisplayMemberBinding="{Binding Titulo}"/>
<GridViewColumn Header="Formato" Width="90" DisplayMemberBinding="{Binding Formato}"/>
</GridView>
</ListView.View>
</ListView>

<WrapPanel Grid.Row="1" Margin="0,12,0,0" HorizontalAlignment="Right">

<Button Name="btnOpenFile" Content="Abrir arquivo" Width="115" Height="32" Margin="4"/>
<Button Name="btnOpenFolder" Content="Abrir pasta" Width="105" Height="32" Margin="4"/>
<Button Name="btnRefresh" Content="Atualizar" Width="90" Height="32" Margin="4"/>
<Button Name="btnClear" Content="Limpar historico" Width="125" Height="32" Margin="4"/>
<Button Name="btnCloseHistory" Content="Fechar" Width="80" Height="32" Margin="4"/>

</WrapPanel>

</Grid>
</Window>
"@

    $ReaderHistory = New-Object System.Xml.XmlNodeReader $HistoryXaml
    $HistoryWindow = [Windows.Markup.XamlReader]::Load($ReaderHistory)

    $lstHistory = $HistoryWindow.FindName("lstHistory")
    $btnOpenFile = $HistoryWindow.FindName("btnOpenFile")
    $btnOpenFolder = $HistoryWindow.FindName("btnOpenFolder")
    $btnRefresh = $HistoryWindow.FindName("btnRefresh")
    $btnClear = $HistoryWindow.FindName("btnClear")
    $btnCloseHistory = $HistoryWindow.FindName("btnCloseHistory")

    # Carregar registros
    $RefreshHistory = {

        $Records = @(Import-Csv $HistoryFile -ErrorAction SilentlyContinue)

        [array]::Reverse($Records)

        $lstHistory.ItemsSource = $Records

    }

    & $RefreshHistory

    # Abrir arquivo selecionado
    $btnOpenFile.Add_Click({

        $Selected = $lstHistory.SelectedItem

        if (!$Selected) {
            [System.Windows.MessageBox]::Show("Selecione um download primeiro.")
            return
        }

        if ([string]::IsNullOrWhiteSpace($Selected.Caminho) -or
            !(Test-Path -LiteralPath $Selected.Caminho -PathType Leaf)) {

            [System.Windows.MessageBox]::Show(
                "O caminho deste arquivo nao esta disponivel. Talvez seja um registro antigo ou o arquivo tenha sido movido.",
                "Ghost Downloader"
            )
            return
        }

        Start-Process -FilePath $Selected.Caminho

    })

    # Abrir pasta do arquivo
    $btnOpenFolder.Add_Click({

        $Selected = $lstHistory.SelectedItem

        if (!$Selected) {
            [System.Windows.MessageBox]::Show("Selecione um download primeiro.")
            return
        }

        if ([string]::IsNullOrWhiteSpace($Selected.Caminho) -or
            !(Test-Path -LiteralPath $Selected.Caminho -PathType Leaf)) {

            [System.Windows.MessageBox]::Show("O caminho deste arquivo não está disponível.")
            return
        }

        $Folder = Split-Path -Parent $Selected.Caminho
        Start-Process explorer.exe -ArgumentList "`"$Folder`""

    })

    # Atualizar lista
    $btnRefresh.Add_Click({
        & $RefreshHistory
    })

    # Limpar historico
    $btnClear.Add_Click({

        $Confirm = [System.Windows.MessageBox]::Show(
            "Deseja realmente apagar todos os registros do histórico? Os arquivos baixados não serão excluídos.",
            "Confirmar limpeza",
            "YesNo",
            "Warning"
        )

        if ($Confirm -eq "Yes") {

            '"Data","Titulo","Formato","Caminho"' |
                Set-Content -Path $HistoryFile -Encoding UTF8

            & $RefreshHistory

        }

    })

    $btnCloseHistory.Add_Click({
        $HistoryWindow.Close()
    })

    $HistoryWindow.ShowDialog() | Out-Null

})

# Escapar argumentos para o Windows
function ConvertTo-CommandLineArgument {
    param([string]$Value)

    if ($Value -notmatch '[\s"]') {
        return $Value
    }

    $Escaped = $Value -replace '(\\*)"', '$1$1\"'
    $Escaped = $Escaped -replace '(\\+)$', '$1$1'

    return '"' + $Escaped + '"'
}

function Start-NextQueuedDownload {

    # Verificar se a fila esta ativa
    if (!$script:QueueRunning) {
        $script:Timer.Stop()
        return
    }

    # Evitar iniciar outro processo simultaneamente
    if ($null -ne $script:DownloadProcess) {
        return
    }

    # Procurar proximo item aguardando
    $NextItem = $script:Queue |
        Where-Object { $_.Status -eq "Aguardando" } |
        Select-Object -First 1

    # Fila finalizada
    if ($null -eq $NextItem) {

        $script:QueueRunning = $false
        $script:CurrentQueueItem = $null

        $script:Timer.Stop()

        $btnOpen.IsEnabled = $true

        $progressBar.IsIndeterminate = $false

        $txtStatus.Text = "Fila finalizada!"
        $txtProgress.Text = "Todos os itens foram processados."

        $lstQueue.Items.Refresh()

        return
    }

    # Definir item atual
    $script:CurrentQueueItem = $NextItem
    $script:DownloadFormat = $NextItem.Formato

    $NextItem.Status = "Baixando"

    $lstQueue.Items.Refresh()

    # Limpar arquivos temporarios
    Remove-Item $ResultFile, $ProgressFile, $OutputLog `
        -Force -ErrorAction SilentlyContinue

    # Preparar argumentos do yt-dlp
    $Arguments = @(
        "--js-runtimes", "node",
        "--no-playlist",
        "--no-colors",
        "--newline",
        "--progress-delta", "1",
        "--progress-template", "download:%(progress._percent_str)s|%(progress._speed_str)s|%(progress._eta_str)s",
        "--print-to-file", "after_move:filepath", $ResultFile
    )

    if ($NextItem.Formato -eq "MP3") {

        $Arguments += @(
            "-x",
            "--audio-format", "mp3",
            "--audio-quality", "0",
            "-P", $MusicDir,
            "-o", "%(title).80s.%(ext)s"
        )

    }
    else {

        $Arguments += @(
            "--restrict-filenames",
            "-f", "bestvideo[vcodec^=avc1]+bestaudio[ext=m4a]/best[ext=mp4]/best",
            "--merge-output-format", "mp4",
            "-P", $VideoDir,
            "-o", "%(title).80s.%(ext)s"
        )

    }

    $Arguments += $NextItem.URL

    try {

        $ArgumentLine = ($Arguments | ForEach-Object {
            ConvertTo-CommandLineArgument ([string]$_)
        }) -join " "

        $script:DownloadProcess = Start-Process `
            -FilePath $YTDLP `
            -ArgumentList $ArgumentLine `
            -WorkingDirectory $BaseDir `
            -RedirectStandardError $ProgressFile `
            -RedirectStandardOutput $OutputLog `
            -WindowStyle Hidden `
            -PassThru

        $progressBar.Value = 0
        $progressBar.IsIndeterminate = $true

        $txtStatus.Text = "Baixando: $($NextItem.Formato)"
        $txtProgress.Text = "Preparando download..."

        $btnOpen.IsEnabled = $false

        $script:Timer.Start()

    }
    catch {

        $NextItem.Status = "Erro"

        $script:DownloadProcess = $null
        $script:CurrentQueueItem = $null

        $lstQueue.Items.Refresh()

        $progressBar.IsIndeterminate = $false

        $txtStatus.Text = "Falha ao iniciar: $($_.Exception.Message)"

        # Tentar proximo item
        Start-NextQueuedDownload

    }

}


# Iniciar download

$btnDownload.Add_Click({

    $URL = $txtURL.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($URL)) {
        $txtStatus.Text = "Informe uma URL"
        return
    }

    if ($URL -notmatch '^https?://') {
        $txtStatus.Text = "Informe uma URL valida"
        return
    }

    $Format = $cmbFormat.SelectedItem.Content.ToString()

    $Item = [PSCustomObject]@{
        URL = $URL
        Formato = $Format
        Status = "Aguardando"
    }

    $script:Queue.Add($Item)

    $txtURL.Clear()

    $txtStatus.Text = "Download adicionado a fila."

    $txtProgress.Text = "$($script:Queue.Count) item(ns) na fila"

})


$btnRemoveQueue.Add_Click({

    $SelectedItem = $lstQueue.SelectedItem

    if ($null -eq $SelectedItem) {
        $txtStatus.Text = "Selecione um item da fila."
        return
    }

    if ($SelectedItem -eq $script:CurrentQueueItem) {
        $txtStatus.Text = "Nao e possivel remover o download em andamento."
        return
    }

    $script:Queue.Remove($SelectedItem)

    $txtStatus.Text = "Item removido da fila."

    $txtProgress.Text = "$($script:Queue.Count) item(ns) na fila"

})
$btnStartQueue.Add_Click({

    if ($script:QueueRunning) {
        $txtStatus.Text = "A fila ja esta em execucao."
        return
    }

    $PendingItems = @($script:Queue | Where-Object {
        $_.Status -eq "Aguardando"
    })

    if ($PendingItems.Count -eq 0) {
        $txtStatus.Text = "Nao ha itens aguardando na fila."
        return
    }

    $script:QueueRunning = $true

    $txtStatus.Text = "Iniciando fila..."

    Start-NextQueuedDownload

})
$btnClearQueue.Add_Click({

    $ItemsToRemove = @(
        $script:Queue | Where-Object {
            $_ -ne $script:CurrentQueueItem
        }
    )

    if ($ItemsToRemove.Count -eq 0) {
        $txtStatus.Text = "Nao ha itens para limpar."
        return
    }

    foreach ($Item in $ItemsToRemove) {
        $script:Queue.Remove($Item)
    }

    $lstQueue.Items.Refresh()

    $txtStatus.Text = "Fila limpa com sucesso."

    if ($null -ne $script:CurrentQueueItem) {
        $txtProgress.Text = "Download atual preservado."
    }
    else {
        $txtProgress.Text = "Fila vazia."
    }

})


# Encerramento seguro
$Window.Add_Closing({

    param($sender, $e)

    if ($null -ne $script:DownloadProcess) {

        if (!$script:DownloadProcess.HasExited) {

            $ConfirmClose = [System.Windows.MessageBox]::Show(
                "Existe um download em andamento. Se fechar agora, ele sera interrompido.`n`nDeseja realmente sair?",
                "Ghost Downloader",
                "YesNo",
                "Warning"
            )

            if ($ConfirmClose -ne "Yes") {
                $e.Cancel = $true
                return
            }

            try {
                $script:DownloadProcess.Kill()
                $script:DownloadProcess.WaitForExit()
            }
            catch {}
        }

        $script:DownloadProcess.Dispose()
        $script:DownloadProcess = $null
    }

    $script:Timer.Stop()

})

$Window.ShowDialog() | Out-Null
