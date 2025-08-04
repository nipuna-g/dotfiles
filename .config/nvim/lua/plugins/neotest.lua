-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'marilari88/neotest-vitest',
    },
    config = function()
      vim.keymap.set('n', '<leader>tt', function()
        require('neotest').run.run()
      end, { desc = 'Run nearest test' })

      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run(vim.fn.expand '%')
      end, { desc = 'Run file tests' })

      vim.keymap.set('n', '<leader>ts', function()
        require('neotest').summary.toggle()
      end, { desc = 'Toggle summary' })

      vim.keymap.set('n', '<leader>to', function()
        require('neotest').output.open { enter = true }
      end, { desc = 'Show output' })

      vim.keymap.set('n', '<leader>tl', function()
        require('neotest').run.run_last()
      end, { desc = 'Run last test' })

      require('neotest').setup {
        adapters = {
          require 'neotest-vitest',
        },
        require 'neotest-vitest' {
          filter_dir = function(name, rel_path, root)
            return name ~= 'node_modules'
          end,
        },
      }
    end,
  },
}
