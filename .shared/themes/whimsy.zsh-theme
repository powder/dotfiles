HOSTNAME=`hostname`
local col_whoami
col_whoami="%F{148}"

PROMPT='%F{magenta}[${col_whoami}%n%F{default}:%F{magenta}%c] %F{default}'

# The right-hand prompt

RPROMPT='${col_whoami}%M ${time} %{$fg[magenta]%}$(git_prompt_info)%F{default}$(git_prompt_status)%F{default}'

# Add this at the start of RPROMPT to include rvm info showing ruby-version@gemset-name
# %{$fg[yellow]%}$(~/.rvm/bin/rvm-prompt)%{$reset_color%}

# local time, color coded by last return code
time_enabled="%(?.%F{green}.%F{red})%*%F{default}"
time_disabled="%F{green}%*%F{default}"
time=$time_enabled

ZSH_THEME_GIT_PROMPT_PREFIX=" ☁  %F{red}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{default}"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{yellow} ☂" # Ⓓ
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{cyan} ✭" # ⓣ
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green} ☀" # Ⓞ

ZSH_THEME_GIT_PROMPT_ADDED="%F{cyan} ✚" # ⓐ ⑃
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{yellow} ✔"  # ⓜ ⑁
ZSH_THEME_GIT_PROMPT_DELETED="%F{red} ✖" # ⓧ ⑂
ZSH_THEME_GIT_PROMPT_RENAMED="%F{blue} ➜" # ⓡ ⑄
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{magenta} ♒" # ⓤ ⑊
ZSH_THEME_GIT_PROMPT_AHEAD="%F{blue} 𝝙"

# More symbols to choose from:
# ☀ ✹ ☄ ♆ ♀ ♁ ♐ ♇ ♈ ♉ ♚ ♛ ♜ ♝ ♞ ♟ ♠ ♣ ⚢ ⚲ ⚳ ⚴ ⚥ ⚤ ⚦ ⚒ ⚑ ⚐ ♺ ♻ ♼ ☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷
# ✡ ✔ ✖ ✚ ✱ ✤ ✦ ❤ ➜ ➟ ➼ ✂ ✎ ✐ ⨀ ⨁ ⨂ ⨍ ⨎ ⨏ ⨷ ⩚ ⩛ ⩡ ⩱ ⩲ ⩵  ⩶ ⨠ 
# ⬅ ⬆ ⬇ ⬈ ⬉ ⬊ ⬋ ⬒ ⬓ ⬔ ⬕ ⬖ ⬗ ⬘ ⬙ ⬟  ⬤ 〒 ǀ ǁ ǂ ĭ Ť Ŧ

## Determine if we are using a gemset.
#function rvm_gemset() {
#    GEMSET=`rvm gemset list | grep '=>' | cut -b4-`
#    if [[ -n $GEMSET ]]; then
#        echo "%{$fg[yellow]%}$GEMSET%{$reset_color%}|"
#    fi 
#}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))
           
            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))
            
            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "($COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "($COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
            else
                echo "($COLOR${MINUTES}m%{$reset_color%}|"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "($COLOR~|"
        fi
    fi
}
