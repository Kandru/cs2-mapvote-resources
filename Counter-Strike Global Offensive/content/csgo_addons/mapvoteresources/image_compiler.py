#!/usr/bin/env python3
"""Generate .vtex sidecars for prop PNGs (Python port of image_compiler.ps1)."""

from pathlib import Path

ADDON_ROOT = Path(__file__).resolve().parent
PNG_ROOT = ADDON_ROOT / "panorama" / "images" / "custom_game" / "prophunt" / "props"

VTEX_TEMPLATE = """\
<!-- dmx encoding keyvalues2_noids 1 format vtex 1 -->
"CDmeVtex"
{{
    "m_inputTextureArray" "element_array"
    [
        "CDmeInputTexture"
        {{
            "m_name" "string" "0"
            "m_fileName" "string" "{relative_png_path}"
            "m_colorSpace" "string" "srgb"
            "m_typeString" "string" "2D"
        }}
    ]

    "m_outputTypeString" "string" "2D"
    "m_outputFormat" "string" "RGBA8888"
    "m_bNoLod" "bool" "1"

    "m_textureOutputChannelArray" "element_array"
    [
        "CDmeTextureOutputChannel"
        {{
            "m_inputTextureArray" "string_array" [ "0" ]
            "m_srcChannels" "string" "rgba"
            "m_dstChannels" "string" "rgba"
            "m_outputColorSpace" "string" "srgb"
        }}
    ]
}}
"""


def main() -> None:
    png_files = sorted(PNG_ROOT.glob("*.png"))
    if not png_files:
        print("No PNG files found in:")
        print(PNG_ROOT)
        return

    for png_file in png_files:
        relative_png_path = png_file.relative_to(ADDON_ROOT).as_posix()
        vtex_path = png_file.with_suffix(".vtex")
        vtex_path.write_text(
            VTEX_TEMPLATE.format(relative_png_path=relative_png_path),
            encoding="ascii",
        )
        print(f"Created: {vtex_path}")


if __name__ == "__main__":
    main()
