local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("c", {
	s("st", {
		t("#include <stdio.h>"),
	}),
})
