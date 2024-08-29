return function(on_attach)
        return {
                cmd = { "rustup", "run", "stable", "rust-analyzer" },
                settings = {
                        ["rust-analyzer"] = {
                                check = {
                                        command = "clippy",
                                },
                                checkOnSave = {
                                        command = "clippy",
                                        extraArgs = { "--all", "--", "-W", "clippy::all" },
                                },
                                assist = {
                                        importEnforceGranularity = true,
                                        importPrefix = "crate",
                                },
                                cargo = {
                                        allFeatures = true,
                                },
                                inlayHints = {
                                        locationLinks = true,
                                        lifetimeElisionHints = {
                                                enable = true,
                                                useParameterNames = true,
                                        },
                                },
                                procMacro = {
                                        ignored = {
                                                leptos_macro = {
                                                        -- optional: --
                                                        -- "component",
                                                        "server",
                                                },
                                        },
                                },
                        },
                },
        }
end
