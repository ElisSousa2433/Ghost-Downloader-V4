# Ghost Downloader V4

Aplicativo de desktop para Windows desenvolvido em **PowerShell e WPF**, com interface gráfica para downloads de vídeos em MP4 e extração de áudio em MP3.

O projeto foi desenvolvido com o objetivo de oferecer uma experiência simples, organizada e prática para gerenciar downloads.

## Funcionalidades

- Download de vídeos no formato MP4.
- Extração de áudio no formato MP3.
- Fila para organizar múltiplos downloads.
- Acompanhamento do progresso dos downloads.
- Exibição de porcentagem, velocidade e tempo estimado.
- Histórico de downloads.
- Organização dos arquivos baixados em pastas específicas.
- Atualização automática do yt-dlp ao iniciar o aplicativo.
- Confirmação de encerramento quando existe um download em andamento.
- Interface gráfica desenvolvida com WPF.

## Tecnologias utilizadas

- PowerShell 7
- Windows Presentation Foundation (WPF)
- yt-dlp
- FFmpeg
- Node.js

## Requisitos

Para executar o Ghost Downloader V4, é necessário ter:

- Windows 10 ou superior.
- PowerShell 7.
- Node.js instalado e disponível no PATH do sistema.
- FFmpeg instalado e disponível no PATH do sistema.
- yt-dlp instalado na pasta esperada pelo aplicativo.

## Instalação

1. Instale o PowerShell 7.
2. Instale o Node.js.
3. Instale o FFmpeg e configure o PATH do Windows.
4. Obtenha o yt-dlp e coloque o executável na pasta `C:\GhostDownloader`.
5. Coloque o script `GhostDownloader.ps1` nessa mesma pasta.

A estrutura esperada é:

```text
C:\GhostDownloader
│
├── GhostDownloader.ps1
├── yt-dlp.exe
│
├── Downloads
│   ├── Videos
│   └── Musicas
│
└── Logs
```

As pastas de downloads e registros são utilizadas pelo aplicativo.

## Como executar

Abra o PowerShell 7 e execute:

```powershell
cd C:\GhostDownloader
.\GhostDownloader.ps1
```

O aplicativo verificará a disponibilidade do yt-dlp e tentará atualizar a ferramenta automaticamente ao iniciar.

## Organização dos downloads

Os arquivos são organizados em pastas separadas:

- `Downloads\Videos`: vídeos baixados.
- `Downloads\Musicas`: arquivos de áudio extraídos.

O histórico permite consultar os registros dos downloads realizados.

## Limitações conhecidas

- A fila de downloads permanece em memória durante a execução do aplicativo e não é preservada após o encerramento.
- Se o aplicativo for fechado durante um download, o processo ativo será interrompido após a confirmação do usuário.
- O funcionamento depende das ferramentas externas e dos requisitos instalados no sistema.

## Ferramentas de terceiros

Este projeto utiliza ferramentas desenvolvidas por terceiros:

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [FFmpeg](https://ffmpeg.org/)
- [Node.js](https://nodejs.org/)

Cada ferramenta mantém sua própria licença e seus respectivos termos de uso.

## Licença

Este projeto será distribuído sob a licença MIT.

Consulte o arquivo `LICENSE` para conhecer os termos de utilização, modificação e distribuição.

## Autor

**ElisSousa2433**

Desenvolvido como projeto de estudo, desenvolvimento e portfólio profissional.
