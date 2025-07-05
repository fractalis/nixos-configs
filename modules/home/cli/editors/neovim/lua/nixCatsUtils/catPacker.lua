local M = {}

function M.setup(v)
    if not vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] then
        local function clone_paq()
            local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
            local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
            if not is_installed then
                vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path })
                return true
            end
        end
        local function bootstrap_paq(packages)
            local first_install = clone_paq()
            vim.cmd.packadd("paq-nvim")
            local paq = require("paq")
            if first_install then
                vim.notify("Installing plugins... If prompted, hit Enter to continue.")
            end
            paq(packages)
            paq.install()
        end
        bootstrap_paq(vim.list_extend({ "savq/pag-nvim" }, v))
    end
end
return M
