" Vim syntax file
" Language:		Goby
" Maintainer:		Goby team
" URL:			https://github.com/goby-lang/goby/
" ----------------------------------------------------------------------------
"
" Thanks to the original Ruby syntax hightlight creators/maintainers!
" ----------------------------------------------------------------------------

if exists("b:current_syntax")
  finish
endif

if has("folding") && exists("goby_fold")
  setlocal foldmethod=syntax
endif

syn cluster gobyNotTop contains=@gobyExtendedStringSpecial,@gobyRegexpSpecial,@gobyDeclaration,gobyConditional,gobyExceptional,gobyMethodExceptional,gobyTodo

if exists("goby_space_errors")
  if !exists("goby_no_trail_space_error")
    syn match gobySpaceError display excludenl "\s\+$"
  endif
  if !exists("goby_no_tab_space_error")
    syn match gobySpaceError display " \+\t"me=e-1
  endif
endif

" Operators
if exists("goby_operators")
  syn match  gobyOperator "[~!^&|*/%+-]\|\%(class\s*\)\@<!<<\|<=>\|<=\|\%(<\|\<class\s\+\u\w*\s*\)\@<!<[^<]\@=\|===\|==\|=\~\|>>\|>=\|=\@<!>\|\*\*\|\.\.\.\|\.\.\|::"
  syn match  gobyOperator "->\|-=\|/=\|\*\*=\|\*=\|&&=\|&=\|&&\|||=\||=\|||\|%=\|+=\|!\~\|!="
  syn region gobyBracketOperator matchgroup=gobyOperator start="\%(\w[?!]\=\|[]})]\)\@<=\[\s*" end="\s*]" contains=ALLBUT,@gobyNotTop
endif

" Expression Substitution and Backslash Notation
syn match gobyStringEscape "\\\\\|\\[abefnrstv]\|\\\o\{1,3}\|\\x\x\{1,2}"						    contained display
syn match gobyStringEscape "\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)" contained display
syn match gobyQuoteEscape  "\\[\\']"											    contained display

syn region gobyInterpolation	      matchgroup=gobyInterpolationDelimiter start="#{" end="}" contained contains=ALLBUT,@gobyNotTop
syn match  gobyInterpolation	      "#\%(\$\|@@\=\)\w\+"    display contained contains=gobyInterpolationDelimiter,gobyInstanceVariable,gobyClassVariable,gobyGlobalVariable,gobyPredefinedVariable
syn match  gobyInterpolationDelimiter "#\ze\%(\$\|@@\=\)\w\+" display contained
syn match  gobyInterpolation	      "#\$\%(-\w\|\W\)"       display contained contains=gobyInterpolationDelimiter,gobyPredefinedVariable,gobyInvalidVariable
syn match  gobyInterpolationDelimiter "#\ze\$\%(-\w\|\W\)"    display contained
syn region gobyNoInterpolation	      start="\\#{" end="}"            contained
syn match  gobyNoInterpolation	      "\\#{"		      display contained
syn match  gobyNoInterpolation	      "\\#\%(\$\|@@\=\)\w\+"  display contained
syn match  gobyNoInterpolation	      "\\#\$\W"		      display contained

syn match gobyDelimEscape	"\\[(<{\[)>}\]]" transparent display contained contains=NONE

syn region gobyNestedParentheses    start="("  skip="\\\\\|\\)"  matchgroup=gobyString end=")"	transparent contained
syn region gobyNestedCurlyBraces    start="{"  skip="\\\\\|\\}"  matchgroup=gobyString end="}"	transparent contained
syn region gobyNestedAngleBrackets  start="<"  skip="\\\\\|\\>"  matchgroup=gobyString end=">"	transparent contained
syn region gobyNestedSquareBrackets start="\[" skip="\\\\\|\\\]" matchgroup=gobyString end="\]"	transparent contained

" These are mostly Oniguruma ready
syn region gobyRegexpComment	matchgroup=gobyRegexpSpecial   start="(?#"								  skip="\\)"  end=")"  contained
syn region gobyRegexpParens	matchgroup=gobyRegexpSpecial   start="(\(?:\|?<\=[=!]\|?>\|?<[a-z_]\w*>\|?[imx]*-[imx]*:\=\|\%(?#\)\@!\)" skip="\\)"  end=")"  contained transparent contains=@gobyRegexpSpecial
syn region gobyRegexpBrackets	matchgroup=gobyRegexpCharClass start="\[\^\="								  skip="\\\]" end="\]" contained transparent contains=gobyStringEscape,gobyRegexpEscape,gobyRegexpCharClass oneline
syn match  gobyRegexpCharClass	"\\[DdHhSsWw]"	       contained display
syn match  gobyRegexpCharClass	"\[:\^\=\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|xdigit\):\]" contained
syn match  gobyRegexpEscape	"\\[].*?+^$|\\/(){}[]" contained
syn match  gobyRegexpQuantifier	"[*?+][?+]\="	       contained display
syn match  gobyRegexpQuantifier	"{\d\+\%(,\d*\)\=}?\=" contained display
syn match  gobyRegexpAnchor	"[$^]\|\\[ABbGZz]"     contained display
syn match  gobyRegexpDot	"\."		       contained display
syn match  gobyRegexpSpecial	"|"		       contained display
syn match  gobyRegexpSpecial	"\\[1-9]\d\=\d\@!"     contained display
syn match  gobyRegexpSpecial	"\\k<\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\=>" contained display
syn match  gobyRegexpSpecial	"\\k'\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\='" contained display
syn match  gobyRegexpSpecial	"\\g<\%([a-z_]\w*\|-\=\d\+\)>" contained display
syn match  gobyRegexpSpecial	"\\g'\%([a-z_]\w*\|-\=\d\+\)'" contained display

syn cluster gobyStringSpecial	      contains=gobyInterpolation,gobyNoInterpolation,gobyStringEscape
syn cluster gobyExtendedStringSpecial contains=@gobyStringSpecial,gobyNestedParentheses,gobyNestedCurlyBraces,gobyNestedAngleBrackets,gobyNestedSquareBrackets
syn cluster gobyRegexpSpecial	      contains=gobyInterpolation,gobyNoInterpolation,gobyStringEscape,gobyRegexpSpecial,gobyRegexpEscape,gobyRegexpBrackets,gobyRegexpCharClass,gobyRegexpDot,gobyRegexpQuantifier,gobyRegexpAnchor,gobyRegexpParens,gobyRegexpComment

" Numbers and ASCII Codes
syn match gobyASCIICode	"\%(\w\|[]})\"'/]\)\@<!\%(?\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\=\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)\)"
syn match gobyInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+\%(_\x\+\)*\>"								display
syn match gobyInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0[dD]\)\=\%(0\|[1-9]\d*\%(_\d\+\)*\)\>"						display
syn match gobyInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[oO]\=\o\+\%(_\o\+\)*\>"								display
syn match gobyInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[bB][01]\+\%(_[01]\+\)*\>"								display
syn match gobyFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\.\d\+\%(_\d\+\)*\>"					display
syn match gobyFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\%(\.\d\+\%(_\d\+\)*\)\=\%([eE][-+]\=\d\+\%(_\d\+\)*\)\>"	display

" Identifiers
syn match gobyLocalVariableOrMethod "\<[_[:lower:]][_[:alnum:]]*[?!=]\=" contains=NONE display transparent
syn match gobyBlockArgument	    "&[_[:lower:]][_[:alnum:]]"		 contains=NONE display transparent

syn match  gobyConstant		"\%(\%([.@$]\@<!\.\)\@<!\<\|::\)\_s*\zs\u\w*\%(\>\|::\)\@=\%(\s*(\)\@!"
syn match  gobyClassVariable	"@@\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*" display
syn match  gobyInstanceVariable "@\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*"  display
syn match  gobyGlobalVariable	"$\%(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\|-.\)"
syn match  gobySymbol		"[]})\"':]\@<!:\%(\^\|\~\|<<\|<=>\|<=\|<\|===\|[=!]=\|[=!]\~\|!\|>>\|>=\|>\||\|-@\|-\|/\|\[]=\|\[]\|\*\*\|\*\|&\|%\|+@\|+\|`\)"
syn match  gobySymbol		"[]})\"':]\@<!:\$\%(-.\|[`~<=>_,;:!?/.'"@$*\&+0]\)"
syn match  gobySymbol		"[]})\"':]\@<!:\%(\$\|@@\=\)\=\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*"
syn match  gobySymbol		"[]})\"':]\@<!:\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\%([?!=]>\@!\)\="
syn match  gobySymbol		"\%([{(,]\_s*\)\@<=\l\w*[!?]\=::\@!"he=e-1
syn match  gobySymbol		"[]})\"':]\@<!\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*[!?]\=:\s\@="he=e-1
syn match  gobySymbol		"\%([{(,]\_s*\)\@<=[[:space:],{]\l\w*[!?]\=::\@!"hs=s+1,he=e-1
syn match  gobySymbol		"[[:space:],{]\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*[!?]\=:\s\@="hs=s+1,he=e-1
syn region gobySymbol		start="[]})\"':]\@<!:'"  end="'"  skip="\\\\\|\\'"  contains=gobyQuoteEscape fold
syn region gobySymbol		start="[]})\"':]\@<!:\"" end="\"" skip="\\\\\|\\\"" contains=@gobyStringSpecial fold

syn match  gobyBlockParameter	  "\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*" contained
syn region gobyBlockParameterList start="\%(\%(\<do\>\|{\)\s*\)\@<=|" end="|" oneline display contains=gobyBlockParameter

syn match gobyInvalidVariable	 "$[^ A-Za-z_-]"
syn match gobyPredefinedVariable #$[!$&"'*+,./0:;<=>?@\`~]#
syn match gobyPredefinedVariable "$\d\+"										   display
syn match gobyPredefinedVariable "$_\>"											   display
syn match gobyPredefinedVariable "$-[0FIKadilpvw]\>"									   display
syn match gobyPredefinedVariable "$\%(deferr\|defout\|stderr\|stdin\|stdout\)\>"					   display
syn match gobyPredefinedVariable "$\%(DEBUG\|FILENAME\|KCODE\|LOADED_FEATURES\|LOAD_PATH\|PROGRAM_NAME\|SAFE\|VERBOSE\)\>" display
syn match gobyPredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(MatchingData\|ARGF\|ARGV\|ENV\)\>\%(\s*(\)\@!"
syn match gobyPredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(DATA\|FALSE\|NIL\)\>\%(\s*(\)\@!"
syn match gobyPredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(STDERR\|STDIN\|STDOUT\|TOPLEVEL_BINDING\|TRUE\)\>\%(\s*(\)\@!"
syn match gobyPredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(RUBY_\%(VERSION\|RELEASE_DATE\|PLATFORM\|PATCHLEVEL\|REVISION\|DESCRIPTION\|COPYRIGHT\|ENGINE\)\)\>\%(\s*(\)\@!"

" Normal Regular Expression
syn region gobyRegexp matchgroup=gobyRegexpDelimiter start="\%(\%(^\|\<\%(and\|or\|while\|until\|unless\|if\|elsif\|when\|not\|then\|else\)\|[;\~=!|&(,[<>?:*+-]\)\s*\)\@<=/" end="/[iomxneus]*" skip="\\\\\|\\/" contains=@gobyRegexpSpecial fold
syn region gobyRegexp matchgroup=gobyRegexpDelimiter start="\%(\h\k*\s\+\)\@<=/[ \t=]\@!" end="/[iomxneus]*" skip="\\\\\|\\/" contains=@gobyRegexpSpecial fold

" Generalized Regular Expression
syn region gobyRegexp matchgroup=gobyRegexpDelimiter start="%r\z([~`!@#$%^&*_\-+=|\:;"',.? /]\)" end="\z1[iomxneus]*" skip="\\\\\|\\\z1" contains=@gobyRegexpSpecial fold
syn region gobyRegexp matchgroup=gobyRegexpDelimiter start="%r{"				 end="}[iomxneus]*"   skip="\\\\\|\\}"	 contains=@gobyRegexpSpecial fold
syn region gobyRegexp matchgroup=gobyRegexpDelimiter start="%r<"				 end=">[iomxneus]*"   skip="\\\\\|\\>"	 contains=@gobyRegexpSpecial,gobyNestedAngleBrackets,gobyDelimEscape fold
syn region gobyRegexp matchgroup=gobyRegexpDelimiter start="%r\["				 end="\][iomxneus]*"  skip="\\\\\|\\\]"	 contains=@gobyRegexpSpecial fold
syn region gobyRegexp matchgroup=gobyRegexpDelimiter start="%r("				 end=")[iomxneus]*"   skip="\\\\\|\\)"	 contains=@gobyRegexpSpecial fold

" Normal String and Shell Command Output
syn region gobyString matchgroup=gobyStringDelimiter start="\"" end="\"" skip="\\\\\|\\\"" contains=@gobyStringSpecial,@Spell fold
syn region gobyString matchgroup=gobyStringDelimiter start="'"	end="'"  skip="\\\\\|\\'"  contains=gobyQuoteEscape,@Spell    fold
syn region gobyString matchgroup=gobyStringDelimiter start="`"	end="`"  skip="\\\\\|\\`"  contains=@gobyStringSpecial fold

" Generalized Single Quoted String, Symbol and Array of Strings
syn region gobyString matchgroup=gobyStringDelimiter start="%[qwi]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" fold
syn region gobyString matchgroup=gobyStringDelimiter start="%[qwi]{"				   end="}"   skip="\\\\\|\\}"	fold contains=gobyNestedCurlyBraces,gobyDelimEscape
syn region gobyString matchgroup=gobyStringDelimiter start="%[qwi]<"				   end=">"   skip="\\\\\|\\>"	fold contains=gobyNestedAngleBrackets,gobyDelimEscape
syn region gobyString matchgroup=gobyStringDelimiter start="%[qwi]\["				   end="\]"  skip="\\\\\|\\\]"	fold contains=gobyNestedSquareBrackets,gobyDelimEscape
syn region gobyString matchgroup=gobyStringDelimiter start="%[qwi]("				   end=")"   skip="\\\\\|\\)"	fold contains=gobyNestedParentheses,gobyDelimEscape
syn region gobyString matchgroup=gobyStringDelimiter start="%q "				   end=" "   skip="\\\\\|\\)"	fold
syn region gobySymbol matchgroup=gobySymbolDelimiter start="%s\z([~`!@#$%^&*_\-+=|\:;"',.? /]\)"   end="\z1" skip="\\\\\|\\\z1" fold
syn region gobySymbol matchgroup=gobySymbolDelimiter start="%s{"				   end="}"   skip="\\\\\|\\}"	fold contains=gobyNestedCurlyBraces,gobyDelimEscape
syn region gobySymbol matchgroup=gobySymbolDelimiter start="%s<"				   end=">"   skip="\\\\\|\\>"	fold contains=gobyNestedAngleBrackets,gobyDelimEscape
syn region gobySymbol matchgroup=gobySymbolDelimiter start="%s\["				   end="\]"  skip="\\\\\|\\\]"	fold contains=gobyNestedSquareBrackets,gobyDelimEscape
syn region gobySymbol matchgroup=gobySymbolDelimiter start="%s("				   end=")"   skip="\\\\\|\\)"	fold contains=gobyNestedParentheses,gobyDelimEscape

" Generalized Double Quoted String and Array of Strings and Shell Command Output
" Note: %= is not matched here as the beginning of a double quoted string
syn region gobyString matchgroup=gobyStringDelimiter start="%\z([~`!@#$%^&*_\-+|\:;"',.?/]\)"	    end="\z1" skip="\\\\\|\\\z1" contains=@gobyStringSpecial fold
syn region gobyString matchgroup=gobyStringDelimiter start="%[QWIx]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" contains=@gobyStringSpecial fold
syn region gobyString matchgroup=gobyStringDelimiter start="%[QWIx]\={"				    end="}"   skip="\\\\\|\\}"	 contains=@gobyStringSpecial,gobyNestedCurlyBraces,gobyDelimEscape    fold
syn region gobyString matchgroup=gobyStringDelimiter start="%[QWIx]\=<"				    end=">"   skip="\\\\\|\\>"	 contains=@gobyStringSpecial,gobyNestedAngleBrackets,gobyDelimEscape  fold
syn region gobyString matchgroup=gobyStringDelimiter start="%[QWIx]\=\["				    end="\]"  skip="\\\\\|\\\]"	 contains=@gobyStringSpecial,gobyNestedSquareBrackets,gobyDelimEscape fold
syn region gobyString matchgroup=gobyStringDelimiter start="%[QWIx]\=("				    end=")"   skip="\\\\\|\\)"	 contains=@gobyStringSpecial,gobyNestedParentheses,gobyDelimEscape    fold
syn region gobyString matchgroup=gobyStringDelimiter start="%[Qx] "				    end=" "   skip="\\\\\|\\)"   contains=@gobyStringSpecial fold

" Here Document
syn region gobyHeredocStart matchgroup=gobyStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<-\=\zs\%(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\)+	 end=+$+ oneline contains=ALLBUT,@gobyNotTop
syn region gobyHeredocStart matchgroup=gobyStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<-\=\zs"\%([^"]*\)"+ end=+$+ oneline contains=ALLBUT,@gobyNotTop
syn region gobyHeredocStart matchgroup=gobyStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<-\=\zs'\%([^']*\)'+ end=+$+ oneline contains=ALLBUT,@gobyNotTop
syn region gobyHeredocStart matchgroup=gobyStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<-\=\zs`\%([^`]*\)`+ end=+$+ oneline contains=ALLBUT,@gobyNotTop

syn region gobyString start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<\z(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\)\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+2	matchgroup=gobyStringDelimiter end=+^\z1$+ contains=gobyHeredocStart,gobyHeredoc,@gobyStringSpecial fold keepend
syn region gobyString start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<"\z([^"]*\)"\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+2	matchgroup=gobyStringDelimiter end=+^\z1$+ contains=gobyHeredocStart,gobyHeredoc,@gobyStringSpecial fold keepend
syn region gobyString start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<'\z([^']*\)'\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+2	matchgroup=gobyStringDelimiter end=+^\z1$+ contains=gobyHeredocStart,gobyHeredoc			fold keepend
syn region gobyString start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<`\z([^`]*\)`\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+2	matchgroup=gobyStringDelimiter end=+^\z1$+ contains=gobyHeredocStart,gobyHeredoc,@gobyStringSpecial fold keepend

syn region gobyString start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<-\z(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\)\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+3    matchgroup=gobyStringDelimiter end=+^\s*\zs\z1$+ contains=gobyHeredocStart,@gobyStringSpecial fold keepend
syn region gobyString start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<-"\z([^"]*\)"\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+3  matchgroup=gobyStringDelimiter end=+^\s*\zs\z1$+ contains=gobyHeredocStart,@gobyStringSpecial fold keepend
syn region gobyString start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<-'\z([^']*\)'\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+3  matchgroup=gobyStringDelimiter end=+^\s*\zs\z1$+ contains=gobyHeredocStart		     fold keepend
syn region gobyString start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<-`\z([^`]*\)`\ze\%(.*<<-\=['`"]\=\h\)\@!+hs=s+3  matchgroup=gobyStringDelimiter end=+^\s*\zs\z1$+ contains=gobyHeredocStart,@gobyStringSpecial fold keepend

if exists('main_syntax') && main_syntax == 'egoby'
  let b:goby_no_expensive = 1
end

syn match  gobyAliasDeclaration    "[^[:space:];#.()]\+" contained contains=gobySymbol,gobyGlobalVariable,gobyPredefinedVariable nextgroup=gobyAliasDeclaration2 skipwhite
syn match  gobyAliasDeclaration2   "[^[:space:];#.()]\+" contained contains=gobySymbol,gobyGlobalVariable,gobyPredefinedVariable
syn match  gobyMethodDeclaration   "[^[:space:];#(]\+"	 contained contains=gobyConstant,gobyBoolean,gobyPseudoVariable,gobyInstanceVariable,gobyClassVariable,gobyGlobalVariable
syn match  gobyClassDeclaration    "[^[:space:];#<]\+"	 contained contains=gobyConstant,gobyOperator
syn match  gobyModuleDeclaration   "[^[:space:];#<]\+"	 contained contains=gobyConstant,gobyOperator
syn match  gobyFunction "\<[_[:alpha:]][_[:alnum:]]*[?!=]\=[[:alnum:]_.:?!=]\@!" contained containedin=gobyMethodDeclaration
syn match  gobyFunction "\%(\s\|^\)\@<=[_[:alpha:]][_[:alnum:]]*[?!=]\=\%(\s\|$\)\@=" contained containedin=gobyAliasDeclaration,gobyAliasDeclaration2
syn match  gobyFunction "\%([[:space:].]\|^\)\@<=\%(\[\]=\=\|\*\*\|[+-]@\=\|[*/%|&^~]\|<<\|>>\|[<>]=\=\|<=>\|===\|[=!]=\|[=!]\~\|!\|`\)\%([[:space:];#(]\|$\)\@=" contained containedin=gobyAliasDeclaration,gobyAliasDeclaration2,gobyMethodDeclaration

syn cluster gobyDeclaration contains=gobyAliasDeclaration,gobyAliasDeclaration2,gobyMethodDeclaration,gobyModuleDeclaration,gobyClassDeclaration,gobyFunction,gobyBlockParameter

" Keywords
" Note: the following keywords have already been defined:
" begin case class def do end for if module unless until while
syn match   gobyControl	       "\<\%(and\|break\|in\|next\|not\|or\|redo\|rescue\|retry\|return\)\>[?!]\@!"
syn match   gobyOperator       "\<defined?" display
syn match   gobyKeyword	       "\<\%(super\|get_block\|yield\)\>[?!]\@!"
syn match   gobyBoolean	       "\<\%(true\|false\)\>[?!]\@!"
syn match   gobyPseudoVariable "\<\%(nil\|self\|__ENCODING__\|__FILE__\|__LINE__\|__callee__\|__method__\)\>[?!]\@!" " TODO: reorganise
syn match   gobyBeginEnd       "\<\%(BEGIN\|END\)\>[?!]\@!"

" Expensive Mode - match 'end' with the appropriate opening keyword for syntax
" based folding and special highlighting of module/class/method definitions
if !exists("b:goby_no_expensive") && !exists("goby_no_expensive")
  syn match  gobyDefine "\<alias\>"  nextgroup=gobyAliasDeclaration  skipwhite skipnl
  syn match  gobyDefine "\<def\>"    nextgroup=gobyMethodDeclaration skipwhite skipnl
  syn match  gobyDefine "\<undef\>"  nextgroup=gobyFunction	     skipwhite skipnl
  syn match  gobyClass	"\<class\>"  nextgroup=gobyClassDeclaration  skipwhite skipnl
  syn match  gobyModule "\<module\>" nextgroup=gobyModuleDeclaration skipwhite skipnl

  syn region gobyMethodBlock start="\<def\>"	matchgroup=gobyDefine end="\%(\<def\_s\+\)\@<!\<end\>" contains=ALLBUT,@gobyNotTop fold
  syn region gobyBlock	     start="\<class\>"	matchgroup=gobyClass  end="\<end\>"		       contains=ALLBUT,@gobyNotTop fold
  syn region gobyBlock	     start="\<module\>" matchgroup=gobyModule end="\<end\>"		       contains=ALLBUT,@gobyNotTop fold

  " modifiers
  syn match gobyConditionalModifier "\<\%(if\|unless\)\>"    display
  syn match gobyRepeatModifier	     "\<\%(while\|until\)\>" display

  syn region gobyDoBlock      matchgroup=gobyControl start="\<do\>" end="\<end\>"                 contains=ALLBUT,@gobyNotTop fold
  " curly bracket block or hash literal
  syn region gobyCurlyBlock	matchgroup=gobyCurlyBlockDelimiter  start="{" end="}"				contains=ALLBUT,@gobyNotTop fold
  syn region gobyArrayLiteral	matchgroup=gobyArrayDelimiter	    start="\%(\w\|[\]})]\)\@<!\[" end="]"	contains=ALLBUT,@gobyNotTop fold

  " statements without 'do'
  syn region gobyBlockExpression       matchgroup=gobyControl	  start="\<begin\>" end="\<end\>" contains=ALLBUT,@gobyNotTop fold
  syn region gobyCaseExpression	       matchgroup=gobyConditional start="\<case\>"  end="\<end\>" contains=ALLBUT,@gobyNotTop fold
  syn region gobyConditionalExpression matchgroup=gobyConditional start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+=-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![?!]\)\s*\)\@<=\%(if\|unless\)\>" end="\%(\%(\%(\.\@<!\.\)\|::\)\s*\)\@<!\<end\>" contains=ALLBUT,@gobyNotTop fold

  syn match gobyConditional "\<\%(then\|else\|when\)\>[?!]\@!"	contained containedin=gobyCaseExpression
  syn match gobyConditional "\<\%(then\|else\|elsif\)\>[?!]\@!" contained containedin=gobyConditionalExpression

  syn match gobyExceptional	  "\<\%(\%(\%(;\|^\)\s*\)\@<=rescue\|else\|ensure\)\>[?!]\@!" contained containedin=gobyBlockExpression
  syn match gobyMethodExceptional "\<\%(\%(\%(;\|^\)\s*\)\@<=rescue\|else\|ensure\)\>[?!]\@!" contained containedin=gobyMethodBlock

  " statements with optional 'do'
  syn region gobyOptionalDoLine   matchgroup=gobyRepeat start="\<for\>[?!]\@!" start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>" matchgroup=gobyOptionalDo end="\%(\<do\>\)" end="\ze\%(;\|$\)" oneline contains=ALLBUT,@gobyNotTop
  syn region gobyRepeatExpression start="\<for\>[?!]\@!" start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>" matchgroup=gobyRepeat end="\<end\>" contains=ALLBUT,@gobyNotTop nextgroup=gobyOptionalDoLine fold

  if !exists("goby_minlines")
    let goby_minlines = 500
  endif
  exec "syn sync minlines=" . goby_minlines

else
  syn match gobyControl "\<def\>[?!]\@!"    nextgroup=gobyMethodDeclaration skipwhite skipnl
  syn match gobyControl "\<class\>[?!]\@!"  nextgroup=gobyClassDeclaration  skipwhite skipnl
  syn match gobyControl "\<module\>[?!]\@!" nextgroup=gobyModuleDeclaration skipwhite skipnl
  syn match gobyControl "\<\%(case\|begin\|do\|for\|if\|unless\|while\|until\|else\|elsif\|ensure\|then\|when\|end\)\>[?!]\@!"
  syn match gobyKeyword "\<\%(alias\|undef\)\>[?!]\@!"
endif

" Special Methods
if !exists("goby_no_special_methods")
  syn keyword gobyAccess    public protected private public_class_method private_class_method public_constant private_constant module_function
  " attr is a common variable name
  syn match   gobyAttribute "\%(\%(^\|;\)\s*\)\@<=attr\>\(\s*[.=]\)\@!"
  syn keyword gobyAttribute attr_accessor attr_reader attr_writer
  syn match   gobyControl   "\<\%(exit!\|\%(abort\|at_exit\|exit\|fork\|loop\|trap\)\>[?!]\@!\)"
  syn keyword gobyEval	    eval class_eval instance_eval module_eval
  syn keyword gobyException raise fail catch throw
  " false positive with 'include?'
  syn match   gobyInclude   "\<include\>[?!]\@!"
  syn keyword gobyInclude   autoload extend load prepend require require_relative
  syn keyword gobyKeyword   callcc caller lambda proc
endif

" Comments and Documentation
syn match   gobySharpBang "\%^#!.*" display
syn keyword gobyTodo	  FIXME NOTE TODO OPTIMIZE XXX todo contained
syn match   gobyComment   "#.*" contains=gobySharpBang,gobySpaceError,gobyTodo,@Spell
if !exists("goby_no_comment_fold")
  syn region gobyMultilineComment start="\%(\%(^\s*#.*\n\)\@<!\%(^\s*#.*\n\)\)\%(\(^\s*#.*\n\)\{1,}\)\@=" end="\%(^\s*#.*\n\)\@<=\%(^\s*#.*\n\)\%(^\s*#\)\@!" contains=gobyComment transparent fold keepend
  syn region gobyDocumentation	  start="^=begin\ze\%(\s.*\)\=$" end="^=end\%(\s.*\)\=$" contains=gobySpaceError,gobyTodo,@Spell fold
else
  syn region gobyDocumentation	  start="^=begin\s*$" end="^=end\s*$" contains=gobySpaceError,gobyTodo,@Spell
endif

" Note: this is a hack to prevent 'keywords' being highlighted as such when called as methods with an explicit receiver
syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(alias\|and\|begin\|break\|case\|class\|def\|defined\|do\|else\)\>"		  transparent contains=NONE
syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(elsif\|end\|ensure\|false\|for\|if\|in\|module\|next\|nil\)\>"		  transparent contains=NONE
syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(not\|or\|redo\|rescue\|retry\|return\|self\|super\|then\|true\)\>"		  transparent contains=NONE
syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(undef\|unless\|until\|when\|while\|get_block\|yield\|BEGIN\|END\|__FILE__\|__LINE__\)\>" transparent contains=NONE

syn match gobyKeywordAsMethod "\<\%(alias\|begin\|case\|class\|def\|do\|end\)[?!]" transparent contains=NONE
syn match gobyKeywordAsMethod "\<\%(if\|module\|undef\|unless\|until\|while\)[?!]" transparent contains=NONE

syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(abort\|at_exit\|attr\|attr_accessor\|attr_reader\)\>"	transparent contains=NONE
syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(attr_writer\|autoload\|callcc\|catch\|caller\)\>"		transparent contains=NONE
syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(eval\|class_eval\|instance_eval\|module_eval\|exit\)\>"	transparent contains=NONE
syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(extend\|fail\|fork\|include\|lambda\)\>"			transparent contains=NONE
syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(load\|loop\|prepend\|private\|proc\|protected\)\>"		transparent contains=NONE
syn match gobyKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(public\|require\|require_relative\|raise\|throw\|trap\)\>"	transparent contains=NONE

" __END__ Directive
syn region gobyData matchgroup=gobyDataDirective start="^__END__$" end="\%$" fold

hi def link gobyClass			gobyDefine
hi def link gobyModule			gobyDefine
hi def link gobyMethodExceptional	gobyDefine
hi def link gobyDefine			Define
hi def link gobyFunction		Function
hi def link gobyConditional		Conditional
hi def link gobyConditionalModifier	gobyConditional
hi def link gobyExceptional		gobyConditional
hi def link gobyRepeat			Repeat
hi def link gobyRepeatModifier		gobyRepeat
hi def link gobyOptionalDo		gobyRepeat
hi def link gobyControl			Statement
hi def link gobyInclude			Include
hi def link gobyInteger			Number
hi def link gobyASCIICode		Character
hi def link gobyFloat			Float
hi def link gobyBoolean			Boolean
hi def link gobyException		Exception
if !exists("goby_no_identifiers")
  hi def link gobyIdentifier		Identifier
else
  hi def link gobyIdentifier		NONE
endif
hi def link gobyClassVariable		gobyIdentifier
hi def link gobyConstant		Type
hi def link gobyGlobalVariable		gobyIdentifier
hi def link gobyBlockParameter		gobyIdentifier
hi def link gobyInstanceVariable	gobyIdentifier
hi def link gobyPredefinedIdentifier	gobyIdentifier
hi def link gobyPredefinedConstant	gobyPredefinedIdentifier
hi def link gobyPredefinedVariable	gobyPredefinedIdentifier
hi def link gobySymbol			Constant
hi def link gobyKeyword			Keyword
hi def link gobyOperator		Operator
hi def link gobyBeginEnd		Statement
hi def link gobyAccess			Statement
hi def link gobyAttribute		Statement
hi def link gobyEval			Statement
hi def link gobyPseudoVariable		Constant

hi def link gobyComment			Comment
hi def link gobyData			Comment
hi def link gobyDataDirective		Delimiter
hi def link gobyDocumentation		Comment
hi def link gobyTodo			Todo

hi def link gobyQuoteEscape		gobyStringEscape
hi def link gobyStringEscape		Special
hi def link gobyInterpolationDelimiter	Delimiter
hi def link gobyNoInterpolation		gobyString
hi def link gobySharpBang		PreProc
hi def link gobyRegexpDelimiter		gobyStringDelimiter
hi def link gobySymbolDelimiter		gobyStringDelimiter
hi def link gobyStringDelimiter		Delimiter
hi def link gobyHeredoc			gobyString
hi def link gobyString			String
hi def link gobyRegexpEscape		gobyRegexpSpecial
hi def link gobyRegexpQuantifier	gobyRegexpSpecial
hi def link gobyRegexpAnchor		gobyRegexpSpecial
hi def link gobyRegexpDot		gobyRegexpCharClass
hi def link gobyRegexpCharClass		gobyRegexpSpecial
hi def link gobyRegexpSpecial		Special
hi def link gobyRegexpComment		Comment
hi def link gobyRegexp			gobyString

hi def link gobyInvalidVariable		Error
hi def link gobyError			Error
hi def link gobySpaceError		gobyError

let b:current_syntax = "goby"

" vim: nowrap sw=2 sts=2 ts=8 noet:
