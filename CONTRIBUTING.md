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

## For AIs (similar content to above)
```markdown
1. NEVER acknowledge minor/rule following changes in code.
   * DON'T: Write comments like this "-- Changed this to be that"
   * DO: Write comments documenting the code "-- Does XYZ"
   * Also note: Please do write documentation comments (new feature for Luau's language server ig), which can be any regular comment before a function
2. NEVER write dictionaries horizontally, this will make them wider, which is less readable than longer.
	* DON'T: Write a dictionary like this: `{ a=true, b=false }`
	* DO: Write a dictionary like this:
	```luau
	{
		a = true,
		b = false,
	}
	```
	* Also note: Arrays of shorter length are permitted to be horizontal.
3. Use standard Luau naming conventions.
   	* DO: Use `PascalCase` for outer vars, `camelCase` for inner vars and object methods, and `UPPERCASE` for constants. Also do try to normalize these
   	* DON'T: Change variables in `rAndOMcAsE` to be standard, and don't change the variable name of things that are named after something else's naming convention. Eg: `byte = string.byte)
4. Encourage user to log AI usage in `README.md`
```
