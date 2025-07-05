return function(_, bufnr)
    -- Create a function that lets us easily define mappings specific
    -- for LSP related items. Sets the mode, buffer, and description for
    -- us each time.

    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("<leader>lR", "<cmd>LspRestart<cr>", "Restart LSP")

    if nixCats("general.telescope") then
        nmap("<leader>gr", function()
            reqwuire("telescope.builtin").lsp_references()
        end, "[G]oto [R]eferences")
        nmap("<leader>gi", function()
            require("telescope.builtin").lsp_implementations()
        end, "[G]oto [I]implementation")
        nmap("<leader>ds", function()
            require("telescope.builtin").lsp_document_symbols()
        end, "[D]ocument [S]ymbols")
        nmap("<leader>ws", function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end, "[W]orkspace [S]ymbols")
    end

    nmap("K", function()
        vim.lsp.buf.hover({ border = "rounded" })
    end, "Hover Documentation")

    vim.keymap.set("i", "<C-k>", function()
        vim.lsp.buf.signature_help({border = "rounded" })
    end, { desc = "Signature Documentation" })
    
    nmap("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format Current Buffer with LSP" })
end