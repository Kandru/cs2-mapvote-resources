$GameRoot = "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive"

$AddonRoot = Join-Path `
    $GameRoot `
    "content\csgo_addons\prophuntresources"

$PngRoot = Join-Path `
    $AddonRoot `
    "panorama\images\custom_game\prophunt\props"

$PngFiles = Get-ChildItem `
    -LiteralPath $PngRoot `
    -Filter "*.png" `
    -File

if ($PngFiles.Count -eq 0) {
    Write-Host "No PNG files found in:"
    Write-Host $PngRoot
    exit
}

foreach ($PngFile in $PngFiles) {
    # Path used inside the VTEX file, relative to the addon content root
    $RelativePngPath = $PngFile.FullName.Substring($AddonRoot.Length + 1)
    $RelativePngPath = $RelativePngPath -replace "\\", "/"

    $VtexPath = [System.IO.Path]::ChangeExtension(
        $PngFile.FullName,
        ".vtex"
    )

    $VtexContents = @"
<!-- dmx encoding keyvalues2_noids 1 format vtex 1 -->
"CDmeVtex"
{
    "m_inputTextureArray" "element_array"
    [
        "CDmeInputTexture"
        {
            "m_name" "string" "0"
            "m_fileName" "string" "$RelativePngPath"
            "m_colorSpace" "string" "srgb"
            "m_typeString" "string" "2D"
        }
    ]

    "m_outputTypeString" "string" "2D"
    "m_outputFormat" "string" "RGBA8888"
    "m_bNoLod" "bool" "1"

    "m_textureOutputChannelArray" "element_array"
    [
        "CDmeTextureOutputChannel"
        {
            "m_inputTextureArray" "string_array" [ "0" ]
            "m_srcChannels" "string" "rgba"
            "m_dstChannels" "string" "rgba"
            "m_outputColorSpace" "string" "srgb"
        }
    ]
}
"@

    Set-Content `
        -LiteralPath $VtexPath `
        -Value $VtexContents `
        -Encoding ASCII

    Write-Host "Created: $VtexPath" -ForegroundColor Green
}
