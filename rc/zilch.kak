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

# highlighters
add-highlighter shared/zilch regions
add-highlighter shared/zilch/code default-region group
add-highlighter shared/zilch/line_comment region -- $ fill comment
add-highlighter shared/zilch/multiline_comment region /- -/ fill comment
add-highlighter shared/zilch/string region %{(?<!')(?<!'\\\\)"} %{(?<!\\\\)(?:\\\\\\\\)*"} fill string

evaluate-commands %sh{
  keywords='forall ∀ let rec effect alias enum record where impl export import as open match with type lam λ val constructor'
  builtins='u8 u16 u32 u64 s8 s16 s32 s64 char ptr ref'

  join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

  printf %s "
    add-highlighter shared/zilch/code/keywords regex \b($(join "${keywords}" '|'))\b 0:keyword
    add-highlighter shared/zilch/code/types regex \b($(join "${builtins}" '|'))\b 0:type
  "
}
add-highlighter shared/zilch/code/attrs regex "#\[.*?\]" 0:attribute
add-highlighter shared/zilch/code/numbers regex \b(0(x|X)[0-9a-fA-F]+|0(o|O)[0-7]+|0(b|B)[0-1]+|[0-9]+)\b 0:value
add-highlighter shared/zilch/code/char regex "'(\\.|[^'])'" 0:value

§
