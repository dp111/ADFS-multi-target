make roms 2>&1 | sed -E -n "s/Unresolved external '([^']+).*/\1/p" | xargs -I mat grep -P '^\s*(\.proc)?\s*mat' src/*.asm | sort