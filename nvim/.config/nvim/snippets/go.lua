-- For LuaSnip (most common snippet engine)
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Basic error handling snippet
s("iferr", {
	t("if err != nil {"),
	t({ "", "\t" }),
	i(1, "return err"),
	t({ "", "}" }),
})

-- Error handling with log
s("iferrl", {
	t("if err != nil {"),
	t({ "", "\tlog.Fatal(err)" }),
	t({ "", "}" }),
})

-- Error handling with return and error wrapping
s("iferrw", {
	t("if err != nil {"),
	t({ "", "\treturn " }),
	i(1, "nil, "),
	t('fmt.Errorf("'),
	i(2, "failed to do something"),
	t(': %w", err)'),
	t({ "", "}" }),
})

-- Error handling with custom action
s("iferrc", {
	t("if err != nil {"),
	t({ "", "\t" }),
	i(1, "// handle error"),
	t({ "", "\treturn" }),
	t({ "", "}" }),
})
