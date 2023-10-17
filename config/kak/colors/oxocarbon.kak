evaluate-commands %sh{
   color0='rgb:161616' 
   color1='rgb:262626' 
   color2='rgb:393939' 
   color3='rgb:525252' 
   color4='rgb:dde1e6' 
   color5='rgb:f2f4f8' 
   color6='rgb:ffffff' 
   color7='rgb:08bdba'
   color8='rgb:3ddbd9' 
   color9='rgb:78a9ff' 
   color10='rgb:ee5396' 
   color11='rgb:33b1ff' 
   color12='rgb:ff7eb6' 
   color13='rgb:42be65' 
   color14='rgb:be95ff' 
   color15='rgb:82cfff'


   echo "
        # code
        face global value              ${color15}
        face global type               ${color6}
        face global variable           ${color6}
        face global module             ${color6}
        face global function           ${color9}
        face global string             ${color14}
        face global keyword            ${color9}
        face global operator           ${color9}
        face global attribute          ${color6}
        face global comment            ${color3}
        face global meta               ${color7}
        face global builtin            default+b

        # markup
        face global title              ${color4}+b
        face global header             ${color4}
        face global bold               ${color4}+b
        face global italic             ${color4}+i
        face global mono               ${color4}
        face global block              ${color4}
        face global link               ${color10}
        face global bullet             ${color15}
        face global list               ${color4}

        # builtin
        face global Default            ${color4},${color0}
        face global PrimarySelection   ${color8},${color1}
        face global SecondarySelection ${color9},${color10}
        face global PrimaryCursor      ${color1},${color4}
        face global SecondaryCursor    ${color10},${color4}
        face global PrimaryCursorEol   ${color7},${color7}
        face global SecondaryCursorEol ${color11},${color7}
        face global LineNumbers        ${color3},${color0}
        face global LineNumberCursor   ${color10},${color1}
        face global LineNumbersWrapped ${color10},${color1}
        face global MenuForeground     ${color4},${color1}
        face global MenuBackground     ${color4},${color1}
        face global MenuInfo           ${color1}
        face global Information        ${color4},${color1}
        face global Error              ${color11},default+b
        face global StatusLine         ${color4},${color0}+b
        face global StatusLineMode     ${color13}
        face global StatusLineInfo     ${color8}
        face global StatusLineValue    ${color12}
        face global StatusCursor       ${color4},${color1}
        face global Prompt             ${color4}+b
        face global MatchingChar       ${color4},${color1}+b
        face global BufferPadding      ${color11},${color0}
    "
}
