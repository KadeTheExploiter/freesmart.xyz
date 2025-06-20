![freetard](https://github.com/user-attachments/assets/d7db45b0-d3c2-4451-98e9-4f5b2f00ee75)

# hi so uh this is just a side project (that might be major later) umm..

```lua
-- code ok
local request = request or http_request or http and http.request or syn and syn.request

if request then
	local main = request({Method = "GET", Url = "https://raw.githubusercontent.com/KadeTheExploiter/freesmart.xyz/refs/heads/main/main.luau"})

	if main then
		loadstring(main.Body)()
	end
else
	loadstring(game:HttpGet("https://raw.githubusercontent.com/KadeTheExploiter/freesmart.xyz/refs/heads/main/main.luau"))()
end
```
