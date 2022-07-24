hook global BufCreate .*\.zc$ %{
  set-option buffer filetype zilch
}

hook -group zilch-highlight global WinSetOption filetype=zilch %{ 
  require-module zilch

  add-highlighter window/zilch ref zilch
  hook -once -always window WinSetOption filetype=.* %[
    remove-highlighter window/zilch
  ]
}


provide-module zilch %§

require-module latex
require-module markdown

# highlighters
add-highlighter shared/zilch regions
add-highlighter shared/zilch/code default-region group
add-highlighter shared/zilch/line_comment region "--" "$" fill comment

add-highlighter shared/zilch/doc_comment region -match-capture "/--" "-/" group
# add-highlighter shared/zilch/doc_comment/ default-region fill comment
add-highlighter shared/zilch/doc_comment/special group
add-highlighter shared/zilch/doc_comment/special/r regions
add-highlighter shared/zilch/doc_comment/special/r/bold1 region "\*\*" "\*\*" fill +b@comment
add-highlighter shared/zilch/doc_comment/special/r/bold2 region "__" "__" fill +b@comment
add-highlighter shared/zilch/doc_comment/special/r/italic region "\*" "\*" fill +i@comment
add-highlighter shared/zilch/doc_comment/special/r/mono1 region -match-capture "`" "`" fill mono
# add-highlighter shared/zilch/doc_comment/special/mono2 regex "" 0:mono 
add-highlighter shared/zilch/doc_comment/special/quote regex "^\h*>(.*?)$" 0:+i@header 1:@comment 
add-highlighter shared/zilch/doc_comment/special/link1 regex "<(.*?)>" 1:header 
add-highlighter shared/zilch/doc_comment/special/link2 regex "\((.*?)\)\[(.*?)\]" 1:+i@comment 2:header 
add-highlighter shared/zilch/doc_comment/text regex "." 0:comment
#add-highlighter shared/zilch/doc_comment/inner region "\A/--\K" "(?=-/)" ref markdown

add-highlighter shared/zilch/multiline_comment region "/-" "-/" fill comment
add-highlighter shared/zilch/attributes region "#\[" "\]" fill attribute
add-highlighter shared/zilch/string region %{(?<!')(?<!'\\\\)"} %{(?<!\\\\)(?:\\\\\\\\)*"} fill string

evaluate-commands %sh{
  keywords='let rec effect alias enum record where import as open match with type lam λ val constructor public mut region'
  builtins='u8 u16 u32 u64 s8 s16 s32 s64 char ptr ref'

  join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

  printf %s "
    add-highlighter shared/zilch/code/keywords regex \b($(join "${keywords}" '|'))\b 0:keyword
    add-highlighter shared/zilch/code/types regex \b($(join "${builtins}" '|'))\b 0:type
  "
}
add-highlighter shared/zilch/code/numbers regex \b(0(x|X)[0-9a-fA-F]+|0(o|O)[0-7]+|0(b|B)[0-1]+|[0-9]+)\b 0:value
add-highlighter shared/zilch/code/char regex "'(\\.|[^'])'" 0:value

§
