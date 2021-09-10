hook global BufCreate .*\.nst$ %{
  set-option buffer filetype nstar
}

hook -group nstar-highlight global WinSetOption filetype=nstar %{ 
  require-module nstar

  add-highlighter window/nstar ref nstar
  hook -once -always window WinSetOption filetype=.* %[
    remove-highlighter window/nstar
  ]
}


provide-module nstar %§

# highlighters
add-highlighter shared/nstar regions
add-highlighter shared/nstar/code default-region group
add-highlighter shared/nstar/line_comment region "#" $ fill comment
add-highlighter shared/nstar/string region %{(?<!')(?<!'\\\\)"} %{(?<!\\\\)(?:\\\\\\\\)*"} fill string

evaluate-commands %sh{
  keywords='section include forall ∀'
  instructions='ret jmp call add sub nop mv salloc sfree sld sst ld st sref'
  builtins='u8 u16 u32 u64 s8 s16 s32 s64 char T1 T2 T4 T8 Ts Ta Tc'
  registers='r0 r1 r2 r3 r4 r5'

  join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

  printf %s "
    add-highlighter shared/nstar/code/keywords regex \b($(join "${keywords} ${instructions}" '|'))\b 0:keyword
    add-highlighter shared/nstar/code/keywords2 regex \B(!) 0:keyword
    add-highlighter shared/nstar/code/types regex \b($(join "${builtins}" '|'))\b 0:type
    add-highlighter shared/nstar/code/types2 regex \B(\*|::|∷|->|→) 0:type
    add-highlighter shared/nstar/code/registers regex \B%($(join "${registers}" '|'))\b 0:attribute
  "
}
add-highlighter shared/nstar/code/numbers regex \b(0(x|X)[0-9a-fA-F]+|0(o|O)[0-7]+|0(b|B)[0-1]+|[0-9]+)\b 0:value
add-highlighter shared/nstar/code/char regex "'(\\.|[^'])'" 0:value

§
