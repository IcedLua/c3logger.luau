# Contributing to C3L (the best logger ever)
Really simple, just create a PR, and if you don't know how to do this, use Youtube I'm not walking you through that. But...

## Code LAWS
> if you violate these i'm sending you to GAOL!!!!
1. Strange one, but, the `-- // Code // --` comment header MUST be at line 25.
2. PLEASE don't write dictionaries horizontally like `{ a=true, b=false }`, it is horrible. Write them vertically like
  ```luau
local ENDINGS = { 
	[byte " "] = true,
	[byte "."] = true,
	[byte "!"] = true,
	[byte "?"] = true,
	[byte ")"] = true,
	[byte "]"] = true,
	[byte "}"] = true,
	[byte "-"] = true,
}
```
3. Stick to STANDARD naming conventions. Being: `PascalCase` for outer variables, `camelCase` for inner variables and object methods, `UPPERCASE` for constants. I will permit ALL uses of `rAndOMcAsE` because it's funny.
4. Log AI usage. Like, heavily, and change the `README.md` after.
